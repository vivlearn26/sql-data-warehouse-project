# Logic App Standard MCP server for the data warehouse

This folder is an Azure Logic Apps **Standard** project. Its three workflows become
MCP tools. AI agents (GitHub Copilot in VS Code, Foundry agents, ...) call these tools
to query the gold layer of the `Datawarehouse` database on your on-premises SQL Server.

```
MCP client (VS Code / agent)
   │  Streamable HTTP + API key or OAuth
   ▼
Logic App Standard  ── Agents → MCP servers → "datawarehouse"
   │  get_sales_summary · get_top_products · get_customer
   ▼
SQL Server managed connector ── on-premises data gateway (your PC) ── SQL Server
                                                      gold.usp_get_* procedures
```

| Tool (workflow) | Stored procedure | Inputs |
|---|---|---|
| `get_sales_summary` | `gold.usp_get_sales_summary` | `group_by` (year / country / category), optional `year`, `country`, `category` |
| `get_top_products` | `gold.usp_get_top_products` | optional `top_n` (1-100, default 10), `year`, `category` |
| `get_customer` | `gold.usp_get_customer` | `customer_number` |

Why stored procedures: with a data gateway, the SQL Server connector does **not**
support *Execute a SQL query (V2)*. *Execute stored procedure (V2)* is supported,
but only the first result set is returned.

## 1. Create the stored procedures

Run [`scripts/gold/mcp_stored_procedures.sql`](../scripts/gold/mcp_stored_procedures.sql)
in SSMS against `Datawarehouse`. The gold views must already exist.

Create a login for the gateway connection that can only run the gold procedures.
This needs SQL Server authentication (mixed mode). Windows authentication also works.

```sql
CREATE LOGIN mcp_reader WITH PASSWORD = '<strong password>';
USE Datawarehouse;
CREATE USER mcp_reader FOR LOGIN mcp_reader;
GRANT EXECUTE ON SCHEMA::gold TO mcp_reader;
```

## 2. Install the on-premises data gateway

1. Install the [on-premises data gateway](https://learn.microsoft.com/data-integration/gateway/service-gateway-install)
   (standard mode) on the PC that runs SQL Server.
2. Sign in with your Azure account and register the gateway.
3. In the Azure portal, create an **On-premises data gateway** resource that points to it.
   Use the same subscription and region as your logic app.
   See [Connect to on-premises data sources](https://learn.microsoft.com/azure/logic-apps/connect-on-premises-data-sources).

## 3. Create and deploy the Logic App

1. In the portal, create a **Logic App (Standard)** on a **Workflow Service Plan** (for example WS1).
   MCP servers only work on Workflow Service Plan or App Service Environment v3.
2. In VS Code, install the *Azure Logic Apps (Standard)* extension.
3. Open this `logicapp-mcp` folder, then run **Azure Logic Apps: Deploy to Logic App...** and pick your app.

## 4. Create the SQL connection (through the gateway)

1. In the portal, open the logic app, then **Workflows** → `get_sales_summary` → **Designer**.
2. Select the **Execute stored procedure** action, then **Change connection** → **Add new**:
   - Authentication: *SQL Server Authentication* (or Windows)
   - Server name: your SQL Server as seen from the gateway PC, for example `localhost` or `MYPC\SQLEXPRESS`
   - Database: `Datawarehouse`
   - Username / password: `mcp_reader` from step 1
   - Gateway: the gateway resource from step 2
3. Save. Then open `get_top_products` and `get_customer`, select the same connection in their
   SQL action, and save them too.

The portal creates the API connection and grants the logic app's managed identity access to it.
If you redeploy from VS Code later, first copy **Workflows → Connections → JSON View**
into [`connections.json`](connections.json). Otherwise the deploy overwrites it with this template.
The template reads the app settings `WORKFLOWS_SUBSCRIPTION_ID`, `WORKFLOWS_RESOURCE_GROUP_NAME`,
`WORKFLOWS_LOCATION_NAME` and `SQL_CONNECTION_RUNTIME_URL`.

Test a workflow with **Run** → **Run with payload**, for example `{"group_by": "country", "year": 2013}`.

## 5. Expose the workflows as an MCP server

1. Logic app → **Agents** → **MCP servers** → **Create** → *Use existing workflows*.
2. Name it `datawarehouse`, describe it (for example "Sales, product and customer analytics from the
   SQL data warehouse"), and select the three workflows.
3. Under **Authentication**, choose one:
   - **Key-based**: select *Generate key* and copy the key. It is shown only once.
   - **OAuth**: set up Easy Auth with a Microsoft Entra app registration, as described in the guide below.
4. Under **Servers**, select **Copy URL**.

The tool descriptions come from each workflow's Request trigger description and the
`description` of each property in its JSON schema. Edit them there to change how agents pick tools.

Full guide: [Set up Standard logic apps as remote MCP servers](https://learn.microsoft.com/azure/logic-apps/set-up-model-context-protocol-server-standard).

## 6. Use it from VS Code

1. Run **MCP: Add Server**, choose **HTTP**, paste the URL, and name it `datawarehouse`.
2. In `mcp.json`, select **Start**, then sign in or enter the key.
3. In Copilot Chat **Agent** mode, enable the `datawarehouse` tools and ask questions like:
   - "What were total sales by country in 2013?"
   - "Top 5 products in the Bikes category?"
   - "Show me customer AW00011000."

Every tool call appears as a workflow run in the logic app's run history.
`get_customer` uses secure outputs and inputs, so customer profiles are hidden in run history.

# sql-data-warehouse-project

Building a data warehouse on SQL Server using a medallion architecture
(Bronze -> Silver -> Gold) over CRM and ERP source data.

## Repository layout

```
scripts/
  init_database.sql        -- creates the Datawarehouse database and schemas
  bronze/
    ddl_bronze.sql         -- raw ingestion tables
    proc_load_bronze.sql   -- bronze.load_bronze: BULK INSERT from CSVs
  silver/
    ddl_silver.sql         -- cleansed tables
    proc_load_silver.sql   -- silver.load_silver: bronze -> silver transforms
  gold/
    view_dim_customer.sql  -- gold.dim_customer
    view_dim_product.sql   -- gold.dim_product
    view_fact_sales.sql    -- gold.fact_sales
documents/                 -- star schema data model (.drawio)
datasets/                  -- CRM / ERP source CSV files
```

## Run order

1. `scripts/init_database.sql`
2. `scripts/bronze/ddl_bronze.sql`, then `scripts/bronze/proc_load_bronze.sql`
3. `scripts/silver/ddl_silver.sql`, then `scripts/silver/proc_load_silver.sql`
4. `EXEC bronze.load_bronze;` then `EXEC silver.load_silver;`
5. Gold views: `view_dim_customer.sql`, `view_dim_product.sql`, then `view_fact_sales.sql`

Note: `bronze.load_bronze` reads CSVs from
`C:\Datawarehouse\sql-data-warehouse-project\datasets\...`; adjust the paths
if your checkout lives elsewhere.

/*
Stored procedures that the Logic App MCP server (logicapp-mcp/) calls as tools.
The on-premises data gateway only supports "Execute stored procedure (V2)",
so each tool is a parameterized procedure over the gold views.
Optional filters use '' / 0 for "no filter" because the workflows always send every parameter.
*/
USE Datawarehouse;
GO

CREATE OR ALTER PROCEDURE gold.usp_get_sales_summary
    @group_by NVARCHAR(20) = N'year',
    @year     INT          = 0,
    @country  NVARCHAR(50) = N'',
    @category NVARCHAR(50) = N''
AS
BEGIN
    SET NOCOUNT ON;

    SET @group_by = LOWER(LTRIM(RTRIM(@group_by)));
    IF @group_by NOT IN (N'year', N'country', N'category')
        THROW 50001, 'group_by must be year, country or category.', 1;

    SET @year     = NULLIF(@year, 0);
    SET @country  = NULLIF(LTRIM(RTRIM(@country)), N'');
    SET @category = NULLIF(LTRIM(RTRIM(@category)), N'');

    SELECT g.group_value,
           SUM(g.sales_amount)            AS total_sales,
           SUM(g.quantity)                AS total_quantity,
           COUNT(DISTINCT g.order_number) AS order_count
    FROM (
        SELECT CASE @group_by
                   WHEN N'year'    THEN CAST(YEAR(f.order_date) AS NVARCHAR(50))
                   WHEN N'country' THEN c.country
                   ELSE p.product_category
               END AS group_value,
               f.sales_amount,
               f.quantity,
               f.order_number
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_customer c ON f.customer_key = c.customer_key
        LEFT JOIN gold.dim_product  p ON f.product_key  = p.product_key
        WHERE (@year     IS NULL OR YEAR(f.order_date) = @year)
          AND (@country  IS NULL OR c.country          = @country)
          AND (@category IS NULL OR p.product_category = @category)
    ) g
    GROUP BY g.group_value
    ORDER BY total_sales DESC
    OPTION (RECOMPILE);
END
GO

CREATE OR ALTER PROCEDURE gold.usp_get_top_products
    @top_n    INT          = 10,
    @year     INT          = 0,
    @category NVARCHAR(50) = N''
AS
BEGIN
    SET NOCOUNT ON;

    IF @top_n IS NULL OR @top_n < 1 SET @top_n = 10;
    IF @top_n > 100 SET @top_n = 100;
    SET @year     = NULLIF(@year, 0);
    SET @category = NULLIF(LTRIM(RTRIM(@category)), N'');

    SELECT TOP (@top_n)
           p.product_number,
           p.product_name,
           p.product_category,
           p.product_subcategory,
           SUM(f.sales_amount)            AS total_sales,
           SUM(f.quantity)                AS total_quantity,
           COUNT(DISTINCT f.order_number) AS order_count
    FROM gold.fact_sales f
    JOIN gold.dim_product p ON f.product_key = p.product_key
    WHERE (@year     IS NULL OR YEAR(f.order_date) = @year)
      AND (@category IS NULL OR p.product_category = @category)
    GROUP BY p.product_number, p.product_name, p.product_category, p.product_subcategory
    ORDER BY total_sales DESC
    OPTION (RECOMPILE);
END
GO

CREATE OR ALTER PROCEDURE gold.usp_get_customer
    @customer_number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT c.customer_number,
           c.first_name,
           c.last_name,
           c.gender,
           c.marital_status,
           c.country,
           c.birth_date,
           c.created_date,
           s.order_count,
           s.total_sales,
           s.first_order_date,
           s.last_order_date
    FROM gold.dim_customer c
    OUTER APPLY (
        SELECT COUNT(DISTINCT f.order_number) AS order_count,
               SUM(f.sales_amount)            AS total_sales,
               MIN(f.order_date)              AS first_order_date,
               MAX(f.order_date)              AS last_order_date
        FROM gold.fact_sales f
        WHERE f.customer_key = c.customer_key
    ) s
    WHERE c.customer_number = LTRIM(RTRIM(@customer_number));
END
GO

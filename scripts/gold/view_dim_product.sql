/*
===============================================================================
Gold View: gold.dim_product
===============================================================================
Purpose:
    Product dimension combining CRM product data with ERP category,
    subcategory and maintenance attributes. Only the current version of
    each product is included.
===============================================================================
*/

USE Datawarehouse;
GO

CREATE OR ALTER VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd.prd_start_date, prd.prd_key) AS product_key,
    prd.prd_id                                                   AS product_id,
    prd.prd_key                                                  AS product_number,
    prd.prd_nm                                                   AS product_name,
    prd.cat_id                                                   AS product_category_id,
    px.CAT                                                       AS product_category,
    px.SUBCAT                                                    AS product_subcategory,
    px.MAINTENANCE                                               AS product_maintenance,
    prd.prd_cost                                                 AS product_cost,
    prd.prd_line                                                 AS product_line,
    prd.prd_start_date                                           AS product_start_date
FROM silver.crm_prod_info prd
LEFT JOIN silver.erp_PX_CAT_G1V2 px
    ON prd.cat_id = px.ID
WHERE prd.prd_end_dt IS NULL;  -- current product versions only, so product_number is unique
GO

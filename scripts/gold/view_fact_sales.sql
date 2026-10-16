/*
===============================================================================
Gold View: gold.fact_sales
===============================================================================
Purpose:
    Sales fact table linking each order line to the product and customer
    dimensions via their surrogate keys.
    Depends on: gold.dim_product, gold.dim_customer
===============================================================================
*/

USE Datawarehouse;
GO

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num   AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt  AS order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS sales_amount,
    sd.sls_quantity  AS quantity,
    sd.sls_price     AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer cu
    ON sd.sls_cust_id = cu.customer_id;
GO

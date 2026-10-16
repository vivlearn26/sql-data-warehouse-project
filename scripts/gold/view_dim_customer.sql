/*
===============================================================================
Gold View: gold.dim_customer
===============================================================================
Purpose:
    Customer dimension combining CRM customer data with ERP demographics
    (birth date, gender) and location (country).
===============================================================================
*/

USE Datawarehouse;
GO

CREATE OR ALTER VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id                              AS customer_id,
    ci.cst_key                             AS customer_number,
    ci.cst_firstname                       AS first_name,
    ci.cst_last_name                       AS last_name,
    ci.cst_maritalstatus                   AS marital_status,
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- CRM is the primary source for gender
        ELSE COALESCE(ca.GEN, 'n/a')
    END                                    AS gender,
    ci.cst_create_date                     AS created_date,
    ca.BDATE                               AS birth_date,
    la.CNTRY                               AS country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_custAZ12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 la
    ON ci.cst_key = la.CID;
GO

/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Truncates each silver table and reloads it from bronze, applying
    cleansing and standardisation (trimming, code -> label mapping,
    de-duplication, invalid value handling).

Usage:
    EXEC silver.load_silver;
===============================================================================
*/

USE Datawarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME2, @end_time DATETIME2, @batch_start_time DATETIME2, @batch_end_time DATETIME2;

    SET @batch_start_time = GETDATE();
    PRINT '================================================';
    PRINT 'Loading Silver Layer';
    PRINT '================================================';

    BEGIN TRY
        PRINT '>> Loading silver.crm_sales_details';
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_sales_details;
        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading silver.erp_custAZ12';
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_custAZ12;
        INSERT INTO silver.erp_custAZ12 (
            CID,
            BDATE,
            GEN
        )
        SELECT
            CASE
                WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
                ELSE CID
            END AS CID,
            CASE
                WHEN BDATE > GETDATE() THEN NULL
                ELSE BDATE
            END AS BDATE,
            CASE
                WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE')   THEN 'Male'
                ELSE 'n/a'
            END AS GEN
        FROM bronze.erp_custAZ12;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading silver.crm_cust_info';
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_cust_info;
        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_last_name,
            cst_maritalstatus,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_last_name) AS cst_last_name,
            CASE
                WHEN UPPER(TRIM(cst_maritalstatus)) = 'M' THEN 'Married'
                WHEN UPPER(TRIM(cst_maritalstatus)) = 'S' THEN 'Single'
                ELSE 'n/a'
            END AS cst_maritalstatus,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                ELSE 'Unknown'
            END AS cst_gndr,
            cst_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
            FROM bronze.crm_cust_info
        ) t
        WHERE row_num = 1;  -- keep the most recent record per customer
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading silver.erp_PX_CAT_G1V2';
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
        INSERT INTO silver.erp_PX_CAT_G1V2 (
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
        )
        SELECT
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
        FROM bronze.erp_PX_CAT_G1V2;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading silver.erp_LOC_A101';
        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_LOC_A101;
        INSERT INTO silver.erp_LOC_A101 (
            CID,
            CNTRY
        )
        SELECT
            REPLACE(CID, '-', '') AS CID,
            CASE
                WHEN TRIM(CNTRY) = 'DE'               THEN 'Germany'
                WHEN TRIM(CNTRY) IN ('US', 'USA')     THEN 'United States'
                WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
                ELSE CNTRY
            END AS CNTRY
        FROM bronze.erp_LOC_A101;
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'Error occurred while loading silver layer';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT '================================================';
    END CATCH

    SET @batch_end_time = GETDATE();
    PRINT '================================================';
    PRINT 'Silver layer load finished in ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
    PRINT '================================================';
END
GO

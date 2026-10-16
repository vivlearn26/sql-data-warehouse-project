/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Purpose:
    Truncates each bronze table and bulk-loads it from the source CSV files,
    printing the load duration for every table.

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE Datawarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '>> Loading bronze.crm_cust_info';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading bronze.crm_prod_info';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prod_info;
        BULK INSERT bronze.crm_prod_info
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading bronze.crm_sales_details';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading bronze.erp_custAZ12';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_custAZ12;
        BULK INSERT bronze.erp_custAZ12
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading bronze.erp_LOC_A101';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_LOC_A101;
        BULK INSERT bronze.erp_LOC_A101
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '>> Loading bronze.erp_PX_CAT_G1V2';
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'C:\Datawarehouse\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        PRINT '================================================';
        PRINT 'Bronze layer loaded in ' + CAST(DATEDIFF(second, @batch_start_time, GETDATE()) AS NVARCHAR(10)) + ' seconds';
        PRINT '================================================';
    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'Error occurred while loading bronze layer';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(15));
        PRINT '================================================';
    END CATCH
END
GO

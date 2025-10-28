USE [Datawarehouse]
GO
/****** Object:  StoredProcedure [silver].[load_silver]    Script Date: 10/28/2025 8:16:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   procedure [silver].[load_silver] as
	BEGIN
	DECLARE @table_startdate DATETIME2,@table_enddate DATETIME2,@load_startdate DATETIME2,@load_Enddate DATETIME2
	set @load_startdate = GETDATE()
	print(@load_startdate)
	BEGIN TRY

	PRINT('==========================================================================')
	set @table_startdate = GETDATE()
	Print(@table_startdate)
	truncate table [silver].[crm_sales_details]
	INSERT INTO [silver].[crm_sales_details]([sls_ord_num]
		  ,[sls_prd_key]
		  ,[sls_cust_id]
		  ,[sls_order_dt]
		  ,[sls_ship_dt]
		  ,[sls_due_dt]
		  ,[sls_sales]
		  ,[sls_quantity]
		  ,[sls_price])
		  SELECT [sls_ord_num]
		  ,[sls_prd_key]
		  ,[sls_cust_id]
		  ,Format([sls_order_dt],'yyyy-MM-dd') as sls_order_dt
		  ,[sls_ship_dt]
		  ,[sls_due_dt]
		  ,[sls_sales]
		  ,[sls_quantity]
		  ,[sls_price]
	  FROM [Datawarehouse].[bronze].[crm_sales_details]
	  set @table_enddate = GETDATE()
	  Print(@table_enddate)
	  PRINT('THE Time taken to load this table is' + CAST(DATEDIFF(second,@table_startdate,@table_enddate) as NVARCHAR(10)) + 'Seconds')
	  PRINT('**==========================================================================**')
	  
	PRINT('==========================================================================')
	  set @table_startdate = GETDATE()
	Print(@table_startdate)
	  truncate table silver.erp_custaz12
	  Insert into silver.erp_custaz12 (cid,bdate,gen)SELECT 
		   case when cid like 'NAS%' THEN substring(CID,4,LEN(CID))
		   else cid
		   end as cid
		  ,case when [BDATE] >GETDATE() THEN NULL
				else bdate
				end as BDATE
		  ,case when upper(trim(gen)) in ('F','FEMALE') Then 'Female'
		 when upper(trim(gen)) in ('M','MALE') Then 'Male'
		 else 'n/a'
		 end as gen
	  FROM [Datawarehouse].[bronze].[erp_custAZ12]
	    set @table_enddate = GETDATE()
	  Print(@table_enddate)
	  PRINT('THE Time taken to load this table is' + CAST(DATEDIFF(second,@table_startdate,@table_enddate) as NVARCHAR(10)) + 'Seconds')
	    PRINT('**==========================================================================**')
	  

	  PRINT('==========================================================================')
	  set @table_startdate = GETDATE()
	Print(@table_startdate)
	   truncate table [silver].[crm_cust_info]
	  INSERT INTO [silver].[crm_cust_info] ( [cst_id]
		  ,[cst_key]
		  ,[cst_firstname]
		  ,[cst_last_name]
		  ,[cst_maritalstatus]
		  ,[cst_gndr]
		  ,[cst_create_date])
		select [cst_id]
		  ,[cst_key]
		  ,trim([cst_firstname]) as cst_firstname
		  ,trim([cst_last_name]) as cst_last_name
		  , case 
			 when UPPER(TRIM(cst_maritalstatus))='M' THEN 'Married'
			 when UPPER(TRIM(cst_maritalstatus))= 'S' THEN 'Single'
			 ELSE 'n/a'
			 END as cst_maritalstatus
		  ,case 
			 when UPPER(TRIM(cst_gndr)) ='M' THEN 'Male'
			 when UPPER(TRIM(cst_gndr))= 'F' THEN 'Female'
			 ELSE 'Unknown'
			 END as cst_gndr
		  ,[cst_create_date]
		  from 
		  (
		  select *,
	  RANK() over (partition by cst_id order by cst_create_date desc) as unique_cst
	  from  [bronze].[crm_cust_info])t 
	  where t.unique_cst=1
	    set @table_enddate = GETDATE()
	  Print(@table_enddate)
	 PRINT('THE Time taken to load this table is' + CAST(DATEDIFF(second,@table_startdate,@table_enddate) as NVARCHAR(10)) + 'Seconds')
	   PRINT('**==========================================================================**')
	  

	  PRINT('==========================================================================')
	  set @table_startdate = GETDATE()
	Print(@table_startdate)
	   truncate table [silver].[erp_PX_CAT_G1V2]
	  insert into[silver].[erp_PX_CAT_G1V2] ([ID]
		  ,[CAT]
		  ,[SUBCAT]
		  ,[MAINTENANCE])SELECT TOP (1000) [ID]
		  ,[CAT]
		  ,[SUBCAT]
		  ,[MAINTENANCE]
	  FROM [Datawarehouse].[bronze].[erp_PX_CAT_G1V2]
	    set @table_enddate = GETDATE()
	  Print(@table_enddate)
	 PRINT('THE Time taken to load this table is' + CAST(DATEDIFF(second,@table_startdate,@table_enddate) as NVARCHAR(10)) + 'Seconds')
	   PRINT('**==========================================================================**')
	  


  PRINT('==========================================================================')
  set @table_startdate = GETDATE()
	Print(@table_startdate)
	   truncate table  [silver].[erp_LOC_A101]
	  insert into [silver].[erp_LOC_A101] (cid,cntry)
	SELECT replace([CID],'-','') as cid
		  ,CASE WHEN TRIM([CNTRY]) ='DE' then 'Germany'
		  when TRIM(cntry) in ('US','USA') then 'United States'
		  when trim(cntry) = '' or cntry is NULL then 'n/a'
		  else cntry
		  end as cntry
	  FROM [Datawarehouse].[bronze].[erp_LOC_A101]
	    set @table_enddate = GETDATE()
	  Print(@table_enddate)
	  PRINT('THE Time taken to load this table is' + CAST(DATEDIFF(second,@table_startdate,@table_enddate) as NVARCHAR(10)) + 'Seconds')
	    PRINT('**==========================================================================**')
END TRY
	  BEGIN CATCH
       PRINT( 'ERROR MESSAGE is' + ERROR_MESSAGE())
	   PRINT('ERROR Number is' + CAST(ERROR_NUMBER() AS NVARCHAR(10)))
	  END CATCH
	  Set @load_Enddate = GETDATE()
	  print(@load_Enddate)
	  PRINT(' THE total time takne to load the whole silver database is '+ cast(datediff(second,@load_startdate,@load_enddate) as nvarchar(10)) + 'Seconds')
END

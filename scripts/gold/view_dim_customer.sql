CREATE or ALTER VIEW gold.dim_customer AS
SELECT 
ROW_NUMBER()OVER(ORDER BY ci.cst_id) as customer_key,
       ci.[cst_id] as customer_id
      ,ci.[cst_key] as customer_number
      ,ci.[cst_firstname] as first_name
      ,ci.[cst_last_name] as last_name
      ,ci.[cst_maritalstatus]as marital_status,
	   CASE when ci.cst_gndr !='n/a' THEN ci.cst_gndr 
		   ELSE COALESCE(ca.gen,'n/a')
		   END as gender
      ,ci.[cst_create_date] as created_date
	  ,ca.BDATE as birth_date
	  ,la.CNTRY as country
  FROM [silver].[crm_cust_info] ci
  LEFT JOIN [silver].[erp_custAZ12] ca ON ci.cst_key = ca.CID  
  LEFT JOIN [silver].[erp_LOC_A101] la on ci.cst_key = la.CID

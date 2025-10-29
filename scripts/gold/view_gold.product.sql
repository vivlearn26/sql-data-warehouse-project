CREATE OR ALTER VIEW gold.dim_product as
SELECT 
ROW_NUMBER() OVER( ORDER BY prd.[prd_start_date],prd.[prd_key]) as product_key,
prd.[prd_id] as product_id
      ,prd.[prd_key] as product_number
      ,prd.[prd_nm] as product_name
	   ,prd.[cat_id] as prdocut_category_id
	    ,px.CAT as product_category
		,px.SUBCAT as product_subcategory
		,px.MAINTENANCE as product_maintenance
      ,prd.[prd_cost] as product_cost
      ,prd.[prd_line] as product_line
      ,prd.[prd_start_date] as product_start_date
	 FROM [silver].[crm_prod_info] prd
 LEFT JOIN [silver].[erp_PX_CAT_G1V2]  px on prd.cat_id = px.ID

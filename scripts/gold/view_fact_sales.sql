CREATE OR ALTER VIEW gold.fact_sales AS
SELECT [sls_ord_num] as order_number
	  ,pr.product_key
	  ,cu.customer_key
      ,[sls_order_dt] as order_date
      ,[sls_ship_dt] as shipping_date
      ,[sls_due_dt] as due_date
      ,[sls_sales] as sales_amount
      ,[sls_quantity] as quantity
      ,[sls_price] as price
  FROM [silver].[crm_sales_details] sd
  left join gold.dim_product pr on sd.sls_prd_key = pr.product_number
  left join gold.dim_customer cu on sd.sls_cust_id = cu.customer_id
   


IF OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL
 DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(20),
cst_firstname NVARCHAR(30),
cst_last_name NVARCHAR(30),
cst_maritalstatus NVARCHAR(50),
cst_gndr NVARCHAR(30),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prod_info ','U') IS NOT NULL
 DROP TABLE silver.crm_prod_info ;
CREATE TABLE silver.crm_prod_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(100),
prd_cost float,
prd_line NVARCHAR(50),
prd_start_date DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
 DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price float,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_custAZ12','U') IS NOT NULL
 DROP TABLE silver.erp_custAZ12;
CREATE TABLE silver.erp_custAZ12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(20),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_LOC_A101','U') IS NOT NULL
 DROP TABLE silver.erp_LOC_A101;
CREATE TABLE silver.erp_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(30),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.erp_PX_CAT_G1V2','U') IS NOT NULL
 DROP TABLE silver.erp_PX_CAT_G1V2;
CREATE TABLE silver.erp_PX_CAT_G1V2 (
ID NVARCHAR(20),
CAT NVARCHAR(30),
SUBCAT NVARCHAR(30),
MAINTENANCE NVARCHAR(10),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

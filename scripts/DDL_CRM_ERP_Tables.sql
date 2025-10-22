
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
 DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(20),
cst_firstname NVARCHAR(30),
cst_last_name NVARCHAR(30),
cst_maritalstatus NVARCHAR(50),
cst_gndr NVARCHAR(30),
cst_create_date DATE
);

IF OBJECT_ID ('bronze.crm_prod_info ','U') IS NOT NULL
 DROP TABLE bronze.crm_prod_info ;
CREATE TABLE bronze.crm_prod_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(100),
prd_cost float,
prd_line NVARCHAR(50),
prd_start_date DATE,
prd_end_dt DATE
);

IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
 DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price float
);

IF OBJECT_ID ('bronze.erp_custAZ12','U') IS NOT NULL
 DROP TABLE bronze.erp_custAZ12;
CREATE TABLE bronze.erp_custAZ12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(20)
);

IF OBJECT_ID ('bronze.erp_LOC_A101','U') IS NOT NULL
 DROP TABLE bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(30)
);


IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2','U') IS NOT NULL
 DROP TABLE bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
ID NVARCHAR(20),
CAT NVARCHAR(30),
SUBCAT NVARCHAR(30),
MAINTENANCE NVARCHAR(10)
);

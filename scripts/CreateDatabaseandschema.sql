use master;

/* This scrpt creates a new Database "Datawarehouse" if it already exists
.This scripts alos creates Schemas for each layer
*/


--Create new Database
CREATE DATABASE Datawarehouse;


Use Datawarehouse;

--Create Schemas 
Create SCHEMA bronze;
GO
Create SCHEMA silver;
GO
Create SCHEMA gold;
GO

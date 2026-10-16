/*
===============================================================================
Create Database and Schemas
===============================================================================
Purpose:
    Creates the 'Datawarehouse' database (if it does not already exist) and
    the 'bronze', 'silver' and 'gold' schemas for each layer.
    Safe to re-run: existing objects are left untouched.
===============================================================================
*/

USE master;
GO

IF DB_ID('Datawarehouse') IS NULL
    CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO

IF SCHEMA_ID('bronze') IS NULL EXEC('CREATE SCHEMA bronze');
IF SCHEMA_ID('silver') IS NULL EXEC('CREATE SCHEMA silver');
IF SCHEMA_ID('gold')   IS NULL EXEC('CREATE SCHEMA gold');
GO

/*
===============================================================================
 Script: 01_database_setup.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Create database and load raw Online Retail II dataset into SQL Server
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - Update file path before running (see placeholder below).
   - Requires SQL Server 2019+ (2022 recommended for FORMAT='CSV').
   - SQL Server service account must have read access to CSV path.
===============================================================================
*/

-------------------------------------------------------------------------------
-- Create database (only if not exists)
-------------------------------------------------------------------------------
IF DB_ID('ecommerce_db') IS NULL
    CREATE DATABASE ecommerce_db;
GO

USE ecommerce_db;
GO

-------------------------------------------------------------------------------
-- 1) raw_transactions (online_retail_II.csv)
-------------------------------------------------------------------------------
IF OBJECT_ID('dbo.raw_transactions','U') IS NULL
BEGIN
    CREATE TABLE dbo.raw_transactions (
        InvoiceNo    VARCHAR(20),
        StockCode    VARCHAR(20),
        Description  VARCHAR(255),
        Quantity     INT,
        InvoiceDate  DATETIME,
        UnitPrice    DECIMAL(10,2),
        CustomerID   VARCHAR(20),
        Country      VARCHAR(100)
    );
END
GO

-------------------------------------------------------------------------------
-- Bulk Load CSV Data
-------------------------------------------------------------------------------
-- TODO: Replace <PATH_TO_DATASET> with your local or UNC file path

BULK INSERT dbo.raw_transactions
FROM '<PATH_TO_DATASET>/online_retail_II.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

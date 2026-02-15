/*
===============================================================================
 Script: 02_data_validation.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Perform data quality checks on raw transaction data
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - This script validates raw data after bulk insert.
   - No data is modified in this step.
   - Focus: Check data quality, correctness, unusual values, and duplicates.
===============================================================================
*/

USE ecommerce_db;
GO

-------------------------------------------------------------------------------
-- 1) Row Count Validation
-------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_rows
FROM dbo.raw_transactions;

-------------------------------------------------------------------------------
-- 2) Preview Sample Data
-------------------------------------------------------------------------------
SELECT TOP 10 *
FROM dbo.raw_transactions;

-------------------------------------------------------------------------------
-- 3) Date Range Check
-------------------------------------------------------------------------------
SELECT
    MIN(InvoiceDate) AS start_date,
    MAX(InvoiceDate) AS end_date
FROM dbo.raw_transactions;

-------------------------------------------------------------------------------
-- 4) NULL Value Checks
-------------------------------------------------------------------------------
SELECT COUNT(*) AS null_customers
FROM dbo.raw_transactions
WHERE CustomerID IS NULL;

SELECT COUNT(*) AS null_description
FROM dbo.raw_transactions
WHERE Description IS NULL;

SELECT COUNT(*) AS null_invoicedate
FROM dbo.raw_transactions
WHERE InvoiceDate IS NULL;

SELECT COUNT(*) AS null_unitprice
FROM dbo.raw_transactions
WHERE UnitPrice IS NULL;

SELECT COUNT(*) AS null_quantity
FROM dbo.raw_transactions
WHERE Quantity IS NULL;

SELECT COUNT(*) AS null_country
FROM dbo.raw_transactions
WHERE Country IS NULL;

-------------------------------------------------------------------------------
-- 5) Negative & Zero Value Checks
-------------------------------------------------------------------------------
SELECT COUNT(*) AS negative_or_zero_quantity
FROM dbo.raw_transactions
WHERE Quantity <= 0;

SELECT COUNT(*) AS negative_or_zero_price
FROM dbo.raw_transactions
WHERE UnitPrice <= 0;

-------------------------------------------------------------------------------
-- 6) Cancelled Invoice Check
-------------------------------------------------------------------------------
SELECT COUNT(*) AS cancelled_invoices
FROM dbo.raw_transactions
WHERE InvoiceNo LIKE 'C%';

-------------------------------------------------------------------------------
-- 7) Distinct Entity Counts
-------------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT InvoiceNo) AS unique_invoices,
    COUNT(DISTINCT StockCode) AS unique_products,
    COUNT(DISTINCT Country) AS unique_countries
FROM dbo.raw_transactions;

-------------------------------------------------------------------------------
-- 8) Exact Duplicate Check (All Columns)
-------------------------------------------------------------------------------
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    COUNT(*) AS duplicate_count
FROM dbo.raw_transactions
GROUP BY
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
HAVING COUNT(*) > 1;

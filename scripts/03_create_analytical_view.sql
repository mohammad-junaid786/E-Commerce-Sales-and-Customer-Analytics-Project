/*
===============================================================================
 Script: 03_create_analytical_view.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Create cleaned analytical view for business analysis
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - Removes exact duplicate rows using SELECT DISTINCT.
   - Keeps negative quantities and cancelled invoices (net revenue model).
   - Does not modify raw data.
   - Adds calculated columns for revenue and time-based analysis.
===============================================================================
*/

USE ecommerce_db;
GO

-------------------------------------------------------------------------------
-- Drop view if exists (safe re-run)
-------------------------------------------------------------------------------
IF OBJECT_ID('dbo.vw_transactions','V') IS NOT NULL
    DROP VIEW dbo.vw_transactions;
GO

-------------------------------------------------------------------------------
-- Create Analytical View
-------------------------------------------------------------------------------
CREATE VIEW dbo.vw_transactions
AS
SELECT DISTINCT
    CustomerID AS customer_id,
    InvoiceNo AS invoice_no,
    StockCode AS stock_code,
    Description AS description,
    Quantity AS quantity,
    InvoiceDate AS invoice_date,
    UnitPrice AS unit_price,
    Country AS country,
    CAST(Quantity * UnitPrice AS DECIMAL(18,2)) AS revenue,
    YEAR(InvoiceDate) AS order_year,
    MONTH(InvoiceDate) AS order_month,
    DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS month_start_date
FROM dbo.raw_transactions;
GO

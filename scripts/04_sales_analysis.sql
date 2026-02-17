/*
===============================================================================
 Script: 04_sales_analysis.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Analyze overall, yearly, and monthly sales performance
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - Revenue follows a net revenue model (includes returns and cancellations).
   - Completed orders exclude cancelled invoices (invoice_no NOT LIKE 'C%').
   - Customer metrics ignore NULL customer_id automatically via COUNT(DISTINCT).
   - Year-wise comparisons use only full years (2010 & 2011).
===============================================================================
*/

USE ecommerce_db;
GO

/* =========================================================
   Section 1: Overall Sales KPIs (All Available Data)
   ========================================================= */

-- Total Revenue (Net Model)
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM dbo.vw_transactions;

-- Total Completed Orders (Exclude Cancelled Invoices)
SELECT
    COUNT(DISTINCT invoice_no) AS total_orders
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%';

-- Total Customers (NULL automatically ignored)
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM dbo.vw_transactions;

-- Average Order Value (Completed Orders Only)
SELECT
    ROUND(
        SUM(revenue) * 1.0 / COUNT(DISTINCT invoice_no),
        2
    ) AS AOV
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%';


/* =========================================================
   Section 2: Year-wise Sales Performance (2010–2011)
   ========================================================= */

-- Year-wise Revenue
SELECT
    order_year,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM dbo.vw_transactions
WHERE order_year IN (2010, 2011)
GROUP BY order_year
ORDER BY order_year;

-- Year-wise Completed Orders
SELECT
    order_year,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%'
AND order_year IN (2010, 2011)
GROUP BY order_year
ORDER BY order_year;

-- Year-wise Customers
SELECT
    order_year,
    COUNT(DISTINCT customer_id) AS total_customers
FROM dbo.vw_transactions
WHERE order_year IN (2010, 2011)
GROUP BY order_year
ORDER BY order_year;

-- Year-wise Average Order Value
SELECT
    order_year,
    ROUND(
        SUM(revenue) * 1.0 / COUNT(DISTINCT invoice_no),
        2
    ) AS AOV
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%'
AND order_year IN (2010, 2011)
GROUP BY order_year
ORDER BY order_year;


/* =========================================================
   Section 3: Monthly Sales Trends (2010–2011)
   ========================================================= */

-- Monthly Revenue Trend
SELECT
    month_start_date,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM dbo.vw_transactions
WHERE order_year IN (2010, 2011)
GROUP BY month_start_date
ORDER BY month_start_date;

-- Monthly Completed Orders
SELECT
    month_start_date,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%'
AND order_year IN (2010, 2011)
GROUP BY month_start_date
ORDER BY month_start_date;

-- Monthly Customers
SELECT
    month_start_date,
    COUNT(DISTINCT customer_id) AS total_customers
FROM dbo.vw_transactions
WHERE order_year IN (2010, 2011)
GROUP BY month_start_date
ORDER BY month_start_date;

-- Monthly Average Order Value
SELECT
    month_start_date,
    ROUND(
        SUM(revenue) * 1.0 / COUNT(DISTINCT invoice_no),
        2
    ) AS AOV
FROM dbo.vw_transactions
WHERE invoice_no NOT LIKE 'C%'
AND order_year IN (2010, 2011)
GROUP BY month_start_date
ORDER BY month_start_date;


/* =========================================================
   Section 4: Top Countries by Net Revenue
   ========================================================= */

SELECT TOP 10
    country,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM dbo.vw_transactions
GROUP BY country
ORDER BY total_revenue DESC;

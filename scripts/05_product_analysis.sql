/*
===============================================================================
 Script: 05_product_analysis.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Analyze product-level performance, returns, pricing behavior, 
          and seasonality of top-performing products
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - Revenue follows a net revenue model (includes returns and cancellations).
   - Completed orders exclude cancelled invoices (invoice_no NOT LIKE 'C%').
   - Customer metrics ignore NULL customer_id automatically via COUNT(DISTINCT).
   - Return rate uses safe division with NULLIF to prevent divide-by-zero errors.
===============================================================================
*/

USE ecommerce_db;
GO

/* =========================================================
   Section 1: Top 10 Products by Net Revenue
   ========================================================= */

SELECT TOP 10
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT CASE 
        WHEN invoice_no NOT LIKE 'C%' 
        THEN invoice_no 
    END) AS total_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM dbo.vw_transactions
GROUP BY stock_code, description
ORDER BY total_revenue DESC;


/* =========================================================
   Section 2: Top 10 Products by Net Quantity Sold
   ========================================================= */

SELECT TOP 10
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT CASE 
        WHEN invoice_no NOT LIKE 'C%' 
        THEN invoice_no 
    END) AS total_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM dbo.vw_transactions
GROUP BY stock_code, description
ORDER BY total_quantity DESC;


/* =========================================================
   Section 3: Top 10 Products by Order Frequency
   ========================================================= */

SELECT TOP 10
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT CASE 
        WHEN invoice_no NOT LIKE 'C%' 
        THEN invoice_no 
    END) AS total_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM dbo.vw_transactions
GROUP BY stock_code, description
ORDER BY total_orders DESC;


/* =========================================================
   Section 4: High Return Products (Return Rate Analysis)
   ========================================================= */

SELECT TOP 10
    stock_code,
    description,
    SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END) AS gross_quantity,
    SUM(CASE WHEN quantity < 0 THEN ABS(quantity) ELSE 0 END) AS returned_quantity,
    CAST(
        SUM(CASE WHEN quantity < 0 THEN ABS(quantity) ELSE 0 END) * 1.0
        / NULLIF(SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END), 0)
    AS DECIMAL(10,2)) AS return_rate
FROM dbo.vw_transactions
GROUP BY stock_code, description
ORDER BY return_rate DESC;


/* =========================================================
   Section 5: Revenue vs Quantity Comparison
   ========================================================= */

SELECT TOP 10
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    CAST(
        SUM(revenue) * 1.0
        / NULLIF(SUM(quantity), 0)
    AS DECIMAL(10,2)) AS avg_revenue_per_unit
FROM dbo.vw_transactions
GROUP BY stock_code, description
ORDER BY total_revenue DESC;


/* =========================================================
   Section 6: Monthly Trend for Top 10 Revenue Products
   ========================================================= */

WITH top_products AS (
    SELECT TOP 10
        stock_code
    FROM dbo.vw_transactions
    GROUP BY stock_code
    ORDER BY SUM(revenue) DESC
)

SELECT
    t.month_start_date,
    t.stock_code,
    t.description,
    ROUND(SUM(t.revenue), 2) AS total_revenue,
    SUM(t.quantity) AS total_quantity,
    COUNT(DISTINCT CASE 
        WHEN t.invoice_no NOT LIKE 'C%' 
        THEN t.invoice_no 
    END) AS total_orders
FROM dbo.vw_transactions t
INNER JOIN top_products tp
    ON t.stock_code = tp.stock_code
GROUP BY
    t.month_start_date,
    t.stock_code,
    t.description
ORDER BY
    t.month_start_date,
    total_revenue DESC;

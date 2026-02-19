/*
===============================================================================
 Script: 06_customer_analysis.sql
 Project: E-Commerce Sales & Customer Analytics
 Purpose: Analyze customer value, retention behavior, revenue concentration,
          segmentation, and lifetime performance
 Author: Mohammad Junaid
 Assistant: ChatGPT
 Notes:
   - Revenue follows a net revenue model (includes returns and cancellations).
   - Completed orders exclude cancelled invoices (invoice_no NOT LIKE 'C%').
   - Customer analysis excludes NULL customer_id.
   - Window functions are used for ranking and cumulative calculations.
===============================================================================
*/

USE ecommerce_db;
GO

/* =========================================================
   Section 1: Overall Customer Metrics
   ========================================================= */

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(revenue) * 1.0
        / COUNT(DISTINCT customer_id),
        2
    ) AS avg_revenue_per_customer,
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN invoice_no NOT LIKE 'C%' 
            THEN invoice_no 
        END) * 1.0
        / COUNT(DISTINCT customer_id),
        2
    ) AS avg_completed_orders_per_customer
FROM dbo.vw_transactions
WHERE customer_id IS NOT NULL;


/* =========================================================
   Section 2: Top 10 Customers by Revenue
   ========================================================= */

SELECT TOP 10
    customer_id,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT CASE 
        WHEN invoice_no NOT LIKE 'C%' 
        THEN invoice_no 
    END) AS total_completed_orders
FROM dbo.vw_transactions
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_revenue DESC;


/* =========================================================
   Section 3: Repeat vs One-Time Customers
   ========================================================= */

SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        order_count,
        CASE 
            WHEN order_count = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS customer_type
    FROM (
        SELECT
            customer_id,
            COUNT(DISTINCT CASE 
                WHEN invoice_no NOT LIKE 'C%' 
                THEN invoice_no 
            END) AS order_count
        FROM dbo.vw_transactions
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ) c
    WHERE order_count > 0
) t
GROUP BY customer_type;


/* =========================================================
   Section 4: Revenue Concentration (Pareto Analysis)
   ========================================================= */

WITH revenue_ranked AS (
    SELECT
        customer_id,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC)
            * 1.0
            / SUM(total_revenue) OVER () AS cumulative_pct
    FROM (
        SELECT
            customer_id,
            SUM(revenue) AS total_revenue
        FROM dbo.vw_transactions
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ) t
)

SELECT
    customer_id,
    total_revenue,
    revenue_rank,
    ROUND(cumulative_pct * 100, 2) AS cumulative_revenue_pct
FROM revenue_ranked
ORDER BY revenue_rank;


/* =========================================================
   Section 5: Customer Segmentation (Revenue Quintiles)
   ========================================================= */

SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        total_revenue,
        NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_quintile,
        CASE
            WHEN NTILE(5) OVER (ORDER BY total_revenue DESC) = 1 THEN 'High Value'
            WHEN NTILE(5) OVER (ORDER BY total_revenue DESC) IN (2,3) THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM (
        SELECT
            customer_id,
            SUM(revenue) AS total_revenue
        FROM dbo.vw_transactions
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ) t
) s
GROUP BY customer_segment
ORDER BY total_customers DESC;


/* =========================================================
   Section 6: Customer Lifetime Value (Basic CLV)
   ========================================================= */

SELECT
    customer_id,
    ROUND(SUM(revenue), 2) AS lifetime_revenue,
    COUNT(DISTINCT CASE
        WHEN invoice_no NOT LIKE 'C%'
        THEN invoice_no
    END) AS total_completed_orders,
    ROUND(
        SUM(revenue) * 1.0
        / NULLIF(
            COUNT(DISTINCT CASE
                WHEN invoice_no NOT LIKE 'C%'
                THEN invoice_no
            END),
        0),
        2
    ) AS avg_order_value
FROM dbo.vw_transactions
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY lifetime_revenue DESC;

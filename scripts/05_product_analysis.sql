--Top Product By Revenue----

SELECT TOP 10
stock_code,
description,
SUM(revenue) as total_revenue,
SUM(quantity) as total_quantity,
COUNT(DISTINCT CASE WHEN invoice_no NOT LIKE 'C%' THEN invoice_no END) as order_count,
COUNT(DISTINCT customer_id) as distict_customer
FROM vw_transactions
GROUP BY stock_code, description
ORDER BY total_revenue DESC


--Top Product By Quantity----

SELECT TOP 10
stock_code,
description,
SUM(revenue) as total_revenue,
SUM(quantity) as total_quantity,
COUNT(DISTINCT CASE WHEN invoice_no NOT LIKE 'C%' THEN invoice_no END) as order_count,
COUNT(DISTINCT customer_id) as distict_customer
FROM vw_transactions
GROUP BY stock_code, description
ORDER BY total_quantity DESC


--Top Product Order Frequency----

SELECT TOP 10
stock_code,
description,
SUM(revenue) as total_revenue,
SUM(quantity) as total_quantity,
COUNT(DISTINCT CASE WHEN invoice_no NOT LIKE 'C%' THEN invoice_no END) as order_count,
COUNT(DISTINCT customer_id) as distict_customer
FROM vw_transactions
GROUP BY stock_code, description
ORDER BY order_count DESC


SELECT TOP 10
stock_code,
description,
SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END) as gross_quantity,
SUM(CASE WHEN quantity < 0 THEN ABS(quantity) ELSE 0 END) as returned_quantity,
SUM(CASE WHEN quantity < 0 THEN ABS(quantity) ELSE 0 END)*1.0 / NULLIF(SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END), 0) as return_rate
FROM vw_transactions
GROUP BY stock_code, description 
ORDER BY return_rate DESC


SELECT TOP 10
stock_code,
description,
SUM(revenue) as total_revenue,
SUM(quantity) as total_quantity,
CAST(SUM(revenue) * 1.0 / NULLIF(SUM(quantity), 0) as DECIMAL(10,2)) as avg_revenue_per_unit
FROM vw_transactions
GROUP BY stock_code, description
ORDER BY total_revenue DESC

-- SQL Portfolio 01: Retail Sales & Revenue Analysis
-- Queries can be run individually, each ending with a semicolon.
-- All financial analyses exclude Cancelled orders unless explicitly noted.
-- 2024/2025/2026 financial comparisons cover January–May only.

-- QUERY 01: Yearly revenue and profitability
SELECT
    strftime('%Y', o.order_date) AS year,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT c.customer_id) AS active_customers,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
    ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp,
    ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - oi.unit_cost))
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2) AS profit_margin_pct
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY strftime('%Y', o.order_date)
ORDER BY year;

-- QUERY 02: Year-over-year revenue and profit growth
WITH yearly_sales AS (
    SELECT strftime('%Y', o.order_date) AS year,
           SUM(oi.quantity * oi.unit_price) AS revenue,
           SUM(oi.quantity * (oi.unit_price - oi.unit_cost)) AS profit
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY strftime('%Y', o.order_date)
),
previous_year AS (
    SELECT year, revenue, profit,
           LAG(revenue) OVER (ORDER BY year) AS previous_revenue,
           LAG(profit) OVER (ORDER BY year) AS previous_profit
    FROM yearly_sales
)
SELECT year,
       ROUND(revenue, 2) AS revenue_gbp,
       ROUND(profit, 2) AS profit_gbp,
       ROUND(100.0 * (revenue - previous_revenue)
             / NULLIF(previous_revenue, 0), 2) AS revenue_yoy_pct,
       ROUND(100.0 * (profit - previous_profit)
             / NULLIF(previous_profit, 0), 2) AS profit_yoy_pct
FROM previous_year
ORDER BY year;

-- QUERY 03: Monthly completed-order revenue and profit
SELECT strftime('%Y-%m', o.order_date) AS month,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
       ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;

-- QUERY 04: Products ranked by completed-order revenue
SELECT p.product_name, p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
       ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp,
       ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - oi.unit_cost))
             / NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2) AS profit_margin_pct
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue_gbp DESC, p.product_name;

-- QUERY 05: Country revenue, customers and profit
SELECT c.country,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       COUNT(DISTINCT c.customer_id) AS active_customers,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
       ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.country
ORDER BY revenue_gbp DESC;

-- QUERY 06: Customer revenue and profitability
SELECT c.customer_name, c.country,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
       ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.country
ORDER BY revenue_gbp DESC;

-- QUERY 07: Revenue and profit by product category
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_gbp,
       ROUND(SUM(oi.quantity * (oi.unit_price - oi.unit_cost)), 2) AS profit_gbp,
       ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - oi.unit_cost))
             / NULLIF(SUM(oi.quantity * oi.unit_price), 0), 2) AS profit_margin_pct
FROM products AS p
JOIN order_items AS oi ON oi.product_id = p.product_id
JOIN orders AS o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue_gbp DESC;

-- QUERY 08: Completed versus cancelled orders
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- QUERY 09: Data-quality checks: missing joins and invalid values
SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.customer_id
        WHERE c.customer_id IS NULL) AS orders_without_customer,
    (SELECT COUNT(*) FROM order_items oi
        LEFT JOIN orders o ON oi.order_id = o.order_id
        WHERE o.order_id IS NULL) AS items_without_order,
    (SELECT COUNT(*) FROM order_items oi
        LEFT JOIN products p ON oi.product_id = p.product_id
        WHERE p.product_id IS NULL) AS items_without_product,
    (SELECT COUNT(*) FROM order_items
        WHERE quantity <= 0 OR unit_price < 0 OR unit_cost < 0) AS invalid_line_items;


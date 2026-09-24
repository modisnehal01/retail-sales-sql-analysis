-- SQL Portfolio 01: synthetic seed data; run ONCE after 01_create_tables.sql.
-- 2024, 2025 and 2026: January–May completed orders plus one cancelled June order per year.
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

INSERT INTO customers (customer_id, customer_name, country, signup_date) VALUES
(1, 'John Smith', 'UK', '2023-11-15'),
(2, 'Sarah Jones', 'UK', '2024-01-10'),
(3, 'Ali Ahmed', 'France', '2024-02-05'),
(4, 'Priya Patel', 'UK', '2024-03-12'),
(5, 'Emma Müller', 'Germany', '2024-04-20'),
(6, 'David Brown', 'UK', '2025-01-08');

INSERT INTO products (product_id, product_name, category, standard_cost) VALUES
(1, 'Laptop', 'Electronics', 600),
(2, 'Mouse', 'Accessories', 12),
(3, 'Desk', 'Furniture', 150),
(4, 'Chair', 'Furniture', 60),
(5, 'Monitor', 'Electronics', 170),
(6, 'Keyboard', 'Accessories', 25);

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1001, 1, '2024-01-08', 'Completed'),
(1002, 2, '2024-02-12', 'Completed'),
(1003, 3, '2024-03-05', 'Completed'),
(1004, 4, '2024-04-10', 'Completed'),
(1005, 5, '2024-05-15', 'Completed'),
(1006, 1, '2024-06-20', 'Cancelled'),
(2001, 1, '2025-01-05', 'Completed'),
(2002, 2, '2025-02-10', 'Completed'),
(2003, 3, '2025-03-03', 'Completed'),
(2004, 4, '2025-04-12', 'Completed'),
(2005, 5, '2025-05-18', 'Completed'),
(2006, 6, '2025-06-20', 'Cancelled'),
(3001, 1, '2026-01-05', 'Completed'),
(3002, 2, '2026-02-10', 'Completed'),
(3003, 3, '2026-03-03', 'Completed'),
(3004, 4, '2026-04-12', 'Completed'),
(3005, 5, '2026-05-18', 'Completed'),
(3006, 6, '2026-06-20', 'Cancelled');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, unit_cost) VALUES
(1, 1001, 1, 1, 750, 600),
(2, 1001, 2, 2, 18, 12),
(3, 1002, 4, 2, 90, 60),
(4, 1003, 3, 1, 220, 150),
(5, 1004, 1, 1, 800, 600),
(6, 1004, 6, 2, 35, 25),
(7, 1005, 5, 1, 200, 170),
(8, 1006, 2, 1, 18, 12),
(9, 2001, 1, 1, 800, 600),
(10, 2001, 2, 2, 20, 12),
(11, 2002, 4, 2, 100, 60),
(12, 2003, 3, 1, 250, 150),
(13, 2004, 1, 1, 850, 600),
(14, 2004, 6, 2, 40, 25),
(15, 2005, 5, 1, 220, 170),
(16, 2006, 2, 1, 20, 12),
(17, 3001, 1, 1, 900, 600),
(18, 3001, 2, 2, 25, 12),
(19, 3002, 4, 2, 120, 60),
(20, 3003, 3, 1, 300, 150),
(21, 3004, 1, 1, 950, 600),
(22, 3004, 6, 2, 45, 25),
(23, 3005, 5, 2, 260, 170),
(24, 3006, 2, 3, 25, 12);
COMMIT;

-- ============================================================
-- E-COMMERCE INTELLIGENCE PROJECT
-- SQL ANALYSIS
-- Dataset: Brazilian E-Commerce Public Dataset by Olist
-- ============================================================


-- 1. TOTAL NUMBER OF ORDERS
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 2. ORDERS BY STATUS
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 3. DELIVERED ORDERS
SELECT
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';


-- 4. ORDERS BY CUSTOMER STATE
SELECT
    c.customer_state,
    COUNT(*) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 5. MONTHLY ORDER TREND
SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    EXTRACT(YEAR FROM order_purchase_timestamp),
    EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY order_year, order_month;


-- 6. AVERAGE DELIVERY TIME
SELECT
    AVG(
        EXTRACT(
            EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )
        ) / 86400
    ) AS average_delivery_days
FROM orders
WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL;


-- 7. ORDERS DELIVERED LATE
SELECT
    COUNT(*) AS late_orders
FROM orders
WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date;


-- 8. ORDERS DELIVERED ON TIME
SELECT
    COUNT(*) AS on_time_orders
FROM orders
WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date <= order_estimated_delivery_date;


-- 9. TOP PRODUCT CATEGORIES BY ITEMS SOLD
SELECT
    p.product_category_name,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;


-- 10. TOP PRODUCT CATEGORIES BY REVENUE
SELECT
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;


-- 11. PAYMENT TYPE ANALYSIS
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 12. CUSTOMER REVIEW SCORE DISTRIBUTION
SELECT
    review_score,
    COUNT(*) AS number_of_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- 13. SELLER PERFORMANCE BY STATE
SELECT
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY total_orders DESC;


-- 14. TOP SELLERS BY NUMBER OF ORDERS
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_orders DESC
LIMIT 10;


-- 15. AVERAGE ORDER VALUE
SELECT
    AVG(order_total) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_values;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================
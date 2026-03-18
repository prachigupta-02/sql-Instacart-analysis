-- =========================================
-- Instacart SQL Data Analysis Project
-- Author: Prachi Gupta
-- =========================================

-- =========================================
-- 🛒 PRODUCT ANALYSIS
-- =========================================

-- 1. top 10 most ordered products 
SELECT 
    p.product_name, COUNT(op.product_id) AS count_of_product
FROM
    products AS p
        JOIN
    order_products__prior AS op ON p.product_id = op.product_id
GROUP BY p.product_name
ORDER BY count_of_product DESC
LIMIT 10; 

-- 2. Top 10 Most Reordered Products
SELECT 
    p.product_name, COUNT(*) AS reorder_count
FROM
    order_products__prior as op
        JOIN
    products AS p ON op.product_id = p.product_id
WHERE
    op.reordered = 1
GROUP BY p.product_name
ORDER BY reorder_count
LIMIT 10;  

-- 3. Rank products by number of orders
SELECT 
    p.product_name,
    COUNT(op.product_id) AS total_orders,
    RANK() OVER (ORDER BY COUNT(op.product_id) DESC) AS product_rank
FROM order_products__prior as op
JOIN products as p
ON op.product_id = p.product_id
GROUP BY p.product_name;


-- =========================================
-- 👥 CUSTOMER ANALYSIS
-- =========================================

-- 4. Customer Reorder Rate
SELECT 
    (SUM(reordered) * 100 / COUNT(*)) AS reorder_percentage
FROM
    order_products__prior;

-- 5. Customer Segmentation Based on Order Frequency
SELECT 
    user_id,
    round(avg(days_since_prior_order),0) AS days_between_orders,
    CASE
        WHEN avg(days_since_prior_order) <= 7 THEN 'frequent shopper'
        WHEN avg(days_since_prior_order) BETWEEN 8 AND 20 THEN 'occassional shoppers'
        ELSE 'rare shoppers'
    END as customer_preference
FROM
    orders
GROUP BY user_id;

-- 6. Average Number of Products per Order
SELECT 
    AVG(total_products) AS avg_products_per_order
FROM
    (SELECT 
        order_id, COUNT(product_id) AS total_products
    FROM
        order_products__prior
    GROUP BY order_id) AS avg_orders;


-- =========================================
-- 📊 SALES / ORDER ANALYSIS
-- =========================================

-- 7.  total orders per day of week
SELECT 
    order_dow, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY order_dow
ORDER BY total_orders DESC;

-- 8. peak hour to order 
SELECT 
    order_hour_of_day,
    COUNT(order_id) AS total_order
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_order DESC
LIMIT 1;


-- =========================================
-- 🏬 CATEGORY ANALYSIS
-- =========================================

-- 9. Top 10 aisles with most products
SELECT 
    a.aisle, COUNT(p.product_id) AS total_products
FROM
    aisles AS a
        JOIN
    products AS p ON a.aisle_id = p.aisle_id
GROUP BY a.aisle
ORDER BY total_products DESC
LIMIT 10;

-- 10. Most Popular Departments by Number of Purchases
SELECT 
    d.department, COUNT(op.product_id) AS total_purchases
FROM
    order_products__prior AS op
        JOIN
    products AS p ON op.product_id = p.product_id
        JOIN
    departments AS d ON p.department_id = p.department_id
GROUP BY d.department
ORDER BY total_purchases DESC;

-- 11. Most Popular Aisle in Each Department
SELECT 
    a.aisle,
    d.department,
    COUNT(op.product_id) AS total_purchase
FROM
    order_products__prior AS op
        JOIN
    products AS p ON op.product_id = p.product_id
        JOIN
    aisles a ON p.aisle_id = a.aisle_id
        JOIN
    departments AS d ON p.department_id = d.department_id
GROUP BY a.aisle, d.department
ORDER BY total_purchase desc;


    



-- ============================================================
-- DATABASE CREATION AND DATA IMPORT
-- ============================================================

CREATE DATABASE olist_ecommerce_project;
USE olist_ecommerce_project;
SHOW DATABASES;
-- ============================================================
-- DATA VALIDATION AND INITIAL EXPLORATION
-- ============================================================

-- Orders table Validation

SHOW COLUMNS FROM olist_orders_dataset;

SELECT COUNT(*) FROM olist_orders_dataset;

SELECT * FROM olist_orders_dataset limit 5;

-- Customers table Validation

SHOW COLUMNS FROM olist_customers_dataset;

SELECT COUNT(*) FROM olist_customers_dataset;

SELECT * FROM olist_customers_dataset limit 5;

-- Products table Validation

SHOW COLUMNS FROM olist_products_dataset;

SELECT COUNT(*) FROM olist_products_dataset;

SELECT * FROM olist_products_dataset limit 5;

-- Order items table Validation
 
SHOW COLUMNS FROM olist_order_items_dataset;

SELECT COUNT(*) FROM olist_order_items_dataset;

SELECT * FROM olist_order_items_dataset limit 5;

-- ============================================================
-- TABLE RENAMING
-- ============================================================

-- Rename Orders Table
RENAME TABLE olist_orders_dataset TO orders;

-- Rename Customers table 
RENAME TABLE olist_customers_dataset TO customers;

-- Rename Products Table
RENAME TABLE olist_products_dataset TO products;

-- Rename Table Order_items
RENAME TABLE olist_order_items_dataset TO Order_items;

-- ============================================================
-- DATA QUALITY ASSESSMENT
-- ============================================================

/* ==================================================
                ORDERS TABLE ASSESSMENT
   ================================================== */

-- Missing Values Check
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS order_purchase_timestamp_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS order_approved_at_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS order_delivered_carrier_date_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS order_delivered_customer_date_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS order_estimated_delivery_date_nulls
FROM orders;

-- Blank Values Check
SELECT
    SUM(CASE WHEN order_id = '' THEN 1 ELSE 0 END) AS order_id_blank,
    SUM(CASE WHEN customer_id = '' THEN 1 ELSE 0 END) AS customer_id_blank,
    SUM(CASE WHEN order_status = '' THEN 1 ELSE 0 END) AS order_status_blank,
    SUM(CASE WHEN order_purchase_timestamp = '' THEN 1 ELSE 0 END) AS order_purchase_timestamp_blank,
    SUM(CASE WHEN order_approved_at = '' THEN 1 ELSE 0 END) AS order_approved_at_blank,
    SUM(CASE WHEN order_delivered_carrier_date = '' THEN 1 ELSE 0 END) AS order_delivered_carrier_date_blank,
    SUM(CASE WHEN order_delivered_customer_date = '' THEN 1 ELSE 0 END) AS order_delivered_customer_date_blank,
    SUM(CASE WHEN order_estimated_delivery_date = '' THEN 1 ELSE 0 END) AS order_estimated_delivery_date_blank
FROM orders;

-- Duplicate Values Check
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Data Type Check
DESCRIBE orders;

-- Invalid Values Check
SELECT DISTINCT order_status
FROM orders;

-- Date Columns Check

SELECT
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
LIMIT 10;

## ORDERS TABLE DATA QUALITY ASSESSMENT CONCLUSION

-- No missing values were found in any column of the orders table.
-- Blank values were found only in delivery-related date columns (order_approved_at, order_delivered_carrier_date, order_delivered_customer_date), which are valid due to incomplete order stages.
-- No duplicate records were found using order_id as the unique identifier.
-- Data types of all columns were checked; date columns are stored as text and can be converted into datetime format.
-- order_status values were checked and all categories were valid.
-- Date columns were verified and no invalid date formats were found.
-- Overall, the orders table is clean and ready for further analysis.

/* =====================================================
             CUSTOMERS TABLE ASSESSMENT
   ===================================================== */
   
-- Missing Values check 
SELECT
SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS customer_unique_id_nulls,
SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS customer_zip_code_prefix_nulls,
SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS customer_city_nulls,
SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS customer_state_nulls
FROM customers;

-- Blank Vlues check 
SELECT
SUM(CASE WHEN customer_id = '' THEN 1 ELSE 0 END) AS customer_id_blank,
SUM(CASE WHEN customer_unique_id = '' THEN 1 ELSE 0 END) AS customer_unique_id_blank,
SUM(CASE WHEN customer_zip_code_prefix = '' THEN 1 ELSE 0 END) AS customer_zip_code_prefix_blank,
SUM(CASE WHEN customer_city = '' THEN 1 ELSE 0 END) AS customer_city_blank,
SUM(CASE WHEN customer_state = '' THEN 1 ELSE 0 END) AS customer_state_blank
FROM customers;

-- Duplicate Values Check
SELECT
    customer_id, COUNT(*) AS customer_duplicate_count
FROM
    customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Data Type Check
DESCRIBE customers;

-- Unique Values check 
SELECT DISTINCt customer_city, customer_state FROM customers;

## CUSTOMERS TABLE DATA QUALITY  ASSESSMENT CONCLUSION
-- All columns were checked for missing values, and no missing values were found.
-- All columns were checked for blank values, and no blank values were found.
-- No duplicate records were identified based on customer_id.
-- The customer_city and customer_state columns were checked for unique values, and no inconsistencies were found.
-- Overall, the customers table was found to be clean and suitable for further analysis.

/* =====================================================
             PRODUCTS TABLE ASSESSMENT
   ===================================================== */
   
-- Missing Values Check
SELECT 
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS product_category_name_nulls,
SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS product_name_lenght_nulls,
SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS product_description_lenght_nulls,
SUM(CASE WHEN product_photos_qty  IS NULL THEN 1 ELSE 0 END) AS product_photos_qty_nulls,
SUM(CASE WHEN product_weight_g  IS NULL THEN 1 ELSE 0 END) AS product_weight_g_nulls,
SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS product_length_cm_nulls,
SUM(CASE WHEN product_height_cm  IS NULL THEN 1 ELSE 0 END) AS product_height_cm_nulls,
SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS product_width_cm_nulls
FROM products;

-- Blank Values check 
SELECT 
SUM(CASE WHEN product_id = '' THEN 1 ELSE 0 END) AS product_id_blank,
SUM(CASE WHEN product_category_name = '' THEN 1 ELSE 0 END) AS product_category_name_blank,
SUM(CASE WHEN product_name_lenght =  '' THEN 1 ELSE 0 END) AS product_name_lenght_blank,
SUM(CASE WHEN product_description_lenght = '' THEN 1 ELSE 0 END) AS product_description_lenght_blank,
SUM(CASE WHEN product_photos_qty = '' THEN 1 ELSE 0 END) AS product_photos_qty_blank,
SUM(CASE WHEN  product_weight_g = '' THEN 1 ELSE 0 END) AS product_weight_g_blank,
SUM(CASE WHEN  product_length_cm = '' THEN 1 ELSE 0 END) AS product_length_cm_blank,
SUM(CASE WHEN product_height_cm  = '' THEN 1 ELSE 0 END) AS product_height_cm_blank,
SUM(CASE WHEN product_width_cm  = '' THEN 1 ELSE 0 END) AS product_width_cm_blank
FROM products;

SELECT *
FROM products
WHERE product_weight_g = '';

-- Duplicate Value check 
SELECT 
    product_id, COUNT(*) AS duplicate_count
FROM
    products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Data Type Check
DESCRIBE products;

-- Unique Values check 
SELECT DISTINCT product_category_name FROM products;

-- Invalid Value Check
SELECT
    MIN(product_name_lenght) AS min_name_length,
    MAX(product_name_lenght) AS max_name_length,

    MIN(product_description_lenght) AS min_description_length,
    MAX(product_description_lenght) AS max_description_length,

    MIN(product_photos_qty) AS min_photos_qty,
    MAX(product_photos_qty) AS max_photos_qty,

    MIN(product_weight_g) AS min_weight,
    MAX(product_weight_g) AS max_weight,

    MIN(product_length_cm) AS min_length,
    MAX(product_length_cm) AS max_length,

    MIN(product_height_cm) AS min_height,
    MAX(product_height_cm) AS max_height,

    MIN(product_width_cm) AS min_width,
    MAX(product_width_cm) AS max_width

FROM products;

## Products Table Data Quality Assessment Conclusion
-- No missing values were found in any column.
-- Four blank values (represented as 0) were found in the product_weight_g column.
-- No duplicate records were identified based on product_id.
-- The data types of all columns were checked and found to be appropriate.
-- The product_category_name column was checked for unique values, and no inconsistencies were found.
-- The numeric columns (product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, and product_width_cm) were checked for invalid values, and no negative values were found.
-- Overall, the products table was cleaned and prepared for further analysis.


/* =====================================================
           ORDER ITEMS TABLE ASSESSMENT
   ===================================================== */
   
-- Missing Values check 
SELECT
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id_nulls,
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_limit_date_nulls,
SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_value_nulls
FROM order_items;

-- Blank Vlues check 
SELECT
SUM(CASE WHEN order_id = '' THEN 1 ELSE 0 END) AS order_id_blank,
SUM(CASE WHEN order_item_id = '' THEN 1 ELSE 0 END) AS order_item_id_blank,
SUM(CASE WHEN product_id = '' THEN 1 ELSE 0 END) AS product_id_blank,
SUM(CASE WHEN seller_id = '' THEN 1 ELSE 0 END) AS seller_id_blank,
SUM(CASE WHEN shipping_limit_date = '' THEN 1 ELSE 0 END) AS shipping_limit_date_blank,
SUM(CASE WHEN price = '' THEN 1 ELSE 0 END) AS price_blank,
SUM(CASE WHEN freight_value = '' THEN 1 ELSE 0 END) AS freight_value_blank
FROM order_items;

SELECT freight_value FROM order_items WHERE freight_value = '';

-- Duplicate Values check 
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Data Type Check
DESCRIBE order_items;

-- Invalid Values check 
SELECT *
FROM order_items
WHERE price < 0
   OR freight_value < 0;
   
SELECT shipping_limit_date
FROM order_items
LIMIT 10;


## ORDER_ITEMS TABLE DATA QUALITY  ASSESSMENT CONCLUSION
-- No missing values were found in any column.
-- Blank values were checked in all columns. A total of 383 values equal to 0 were found in the freight_value column, while all other columns contained no blank values.
-- No duplicate records were identified.
-- The data types of all columns were verified and found to be appropriate.
-- The price and freight_value columns were checked for invalid values, and no negative values were found.
-- The shipping_limit_date column was checked, and the date values were found to be in the correct format.
-- Overall, the order_items table was found to be clean and suitable for further analysis. The only issue identified was the presence of 383 values equal to 0 in the freight_value column

-- ******************************************
-- DATA CLEANING
-- ******************************************

##  Orders table
--  Date columns were identified for conversion during EDA.

## Customers table
--  No data cleaning was required.

## Products table
--  No data cleaning was required.

## Order_items table
--  No data cleaning was required.

-- ==================================================
-- BUSINESS INSIGHTS AND ANALYSIS
-- ==================================================

/*----------------------------------------------------------
Objective 1: Analyze the Overall Order Volume

Business Question:
What is the total number of orders placed?
----------------------------------------------------------*/
SELECT  COUNT(*) AS total_orders FROM ORDERS;

### Business Insight: The large number of orders shows that customers were actively purchasing products.

### Key Finding: A total of 99,441 orders were placed during the period covered by the dataset.

/*----------------------------------------------------------
Objective 2: Determine the Total Number of Unique Customers

Business Question:
How many unique customers have placed orders?
----------------------------------------------------------*/
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

### Business Insight: The large customer base shows that the business attracted a wide range of customers.

### Key Finding: A total of 96,096 unique customers placed orders during the period covered by the dataset.

/*----------------------------------------------------------
Objective 3: Calculate the Total Number of Available Products

Business Question:
How many unique products are available in the product catalog?
----------------------------------------------------------*/
SELECT COUNT(*) AS total_products FROM products;

### Business Insight: The large number of products shows that customers had many different products to choose from.

### Key Finding: A total of 32,340 unique products were available in the product catalog.
/*----------------------------------------------------------
Objective 4: Calculate the Total Number of Order Items Sold

Business Question:
How many total order items have been sold?
----------------------------------------------------------*/
SELECT COUNT(*) AS total_order_items
FROM order_items;

### Business Insight: The high number of items sold shows strong product demand and customer purchasing activity.

### Key Finding: A total of 112,650 order items were sold.

/*----------------------------------------------------------
Objective 5: Identify the Top-Performing Customer States

Business Question:
Which customer states have the highest number of orders?
----------------------------------------------------------*/
SELECT customers.customer_state , Count(orders.order_id) AS total_orders
FROM customers
join orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_state
ORDER BY total_orders DESC
LIMIT 5;

### Business Insight: SP had much higher order activity than other states, making it the main customer market in the dataset.

### Key Finding: SP had the highest number of orders with 41,746 orders, followed by RJ with 12,852 and MG with 11,635 orders.

/*----------------------------------------------------------
Objective 6: Calculate Total Revenue

Business Question:
What is the total revenue generated from all orders?
----------------------------------------------------------*/
SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM
    order_items;
    
### Business Insight: The high total revenue shows that the business generated strong sales from customer orders.

### Key Finding: The total revenue generated from all orders was 13,591,643.70.

/*----------------------------------------------------------
Objective 7: Calculate the Average Order Value (AOV)

Business Question:
What is the average revenue generated per order?
----------------------------------------------------------*/
SELECT 
    ROUND(AVG(per_order_value), 2)
FROM
    (SELECT 
        order_id, SUM(price) AS per_order_value
    FROM
        order_items
    GROUP BY (order_id)) AS order_revenue;

### Business Insight: On average, customers spent about 137.75 on each order.

### Key Finding: The average order value (AOV) was 137.75 per order.

/*----------------------------------------------------------
Objective 8: Analyze Order Status Distribution

Business Question:
How many orders are in each order status category?
----------------------------------------------------------*/
SELECT 
    order_status, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY (order_status)
ORDER BY total_orders DESC;

### Business Insight: The high number of delivered orders shows that most customer orders were successfully completed.

### Key Finding: Most orders were delivered (96,478), while 1,107 were shipped and 625 were canceled. The remaining orders were in other statuses

/*----------------------------------------------------------
Objective 9: Analyze Unique Customers by Customer State

Business Question:
Which customer states have the highest number of unique customers?
----------------------------------------------------------*/
SELECT 
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

### Business Insight: SP had the largest customer base, showing that it was the main customer market in the dataset.

### Key Finding: SP had the highest number of unique customers with 40,302, followed by RJ with 12,384 and MG with 11,259.

/*----------------------------------------------------------
Objective 10: Identify the Top-Selling Products

Business Question:
Which products have the highest order volume, and which
product categories do they belong to?
----------------------------------------------------------*/
SELECT 
    p.product_id,
    p.product_category_name,
    COUNT(oi.order_id) AS total_orders
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id , p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;

### Business Insight: Products from moveis_decoracao, cama_mesa_banho, and ferramentas_jardim showed strong customer demand and were among the most frequently purchased products.

### Key Finding: The top-selling product was from moveis_decoracao with 527 orders, followed by cama_mesa_banho with 488 orders and several produtos from ferramentas_jardim with high order volumes.

/*----------------------------------------------------------
Objective 11: Identify the Top 10 Customers by Order Count

Business Question:
Which customers have placed the highest number of orders,
and who are the top 10 most active customers based on
total order count?
----------------------------------------------------------*/
SELECT c.customer_unique_id , COUNT(o.order_id) AS total_orders
FROM customers C
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY COUNT(o.order_id) DESC
LIMIT 10;

### Business Insight
-- The analysis reveals that customer purchase frequency is relatively low across the platform. The most active customer placed 17 orders, while the remaining top customers placed between 6 and 9 orders, indicating that repeat purchases are limited and customer orders are widely distributed.

### Key Finding
-- The highest purchasing customer placed only 17 orders, suggesting that the platform has a broad customer base with relatively low repeat purchase frequency.

/*----------------------------------------------------------
Objective 12: Analyze Repeat vs One-Time Customers

Business Question:
How many customers are repeat buyers, and how many customers
have placed only a single order on the platform?
----------------------------------------------------------*/

with customer_orders AS 
( SELECT c.customer_unique_id , COUNT(o.order_id) AS total_orders ,
CASE WHEN COUNT(o.order_id) = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS customer_type 
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
)
SELECT customer_type, COUNT(*) AS total_customers FROM customer_orders 
GROUP BY (Customer_type);

### Business Insight
-- The analysis shows that most customers made only one purchase. Out of 96,096 customers, 93,099 were one-time customers, while only 2,997 were repeat customers. This shows that customer retention is low and there is an opportunity to increase repeat purchases.

### Key Finding
-- The platform has 93,099 one-time customers compared with only 2,997 repeat customers, indicating low customer retention.

/*----------------------------------------------------------
Objective 13: Analyze the Average Number of Items per Order

Business Question:
What is the average number of items purchased per order,
and what is the typical order size?
----------------------------------------------------------*/
SELECT 
    ROUND(AVG(total_items) , 2) AS total_items_per_order
FROM
    (SELECT 
        order_id, COUNT(order_item_id) AS total_items
    FROM
        order_items
    GROUP BY order_id) AS order_summary;
    
### Business Insight
-- The analysis shows that customers purchased an average of 1.14 items per order. This indicates that most orders contain only one item, with a smaller number of orders containing multiple items.

### Key Finding
-- The average order contains 1.14 items, showing that most customers purchase a single item per order.

/*----------------------------------------------------------
Objective 14: Analyze the Average Order Value by Customer State

Business Question:
Which customer states have the highest average order value,
and how does the average order value differ across states?
----------------------------------------------------------*/
SELECT 
    customer_state,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM
    (SELECT 
        c.customer_state,
            o.order_id,
            SUM(oi.price + oi.freight_value) AS order_value
    FROM
        customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id , c.customer_state) AS order_values
GROUP BY customer_state
ORDER BY average_order_value DESC;

### Business Insight
-- The average order value is highest in PB at 265.01, followed by AC at 242.84 and AP at 239.16. SP has the lowest average order value at 143.12. This shows that average spending per order varies across customer states.

### Key Finding
-- PB has the highest average order value at 265.01, followed by AC at 242.84, while SP has the lowest average order value at 143.12.

/*----------------------------------------------------------
Objective 15: Analyze Monthly Order Trends Across Years

Business Question:
How does the number of orders change month by month across
different years, and which periods have the highest order volume?
----------------------------------------------------------*/
SELECT 
    YEAR(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS order_year,
    MONTH(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS order_month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY total_orders DESC;

### Business Insight
-- The number of orders increased strongly from the beginning of 2017 and reached the highest level in November 2017 with 7,544 orders. Order volume remained high during the first half of 2018, with January 2018 having 7,269 orders. The very low order counts in some 2016 and late 2018 months suggest that these periods may contain incomplete data.

### Key Finding
-- November 2017 recorded the highest number of orders with 7,544 orders, followed by January 2018 with 7,269 orders. Order volume was generally higher in 2018 compared with 2017.


 /*----------------------------------------------------------
 Objective 16: Calculate the Average Order Delivery Time

 Business Question:
 What is the average number of days taken to deliver an order
 to the customer?
 ----------------------------------------------------------*/
    
SELECT 
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM
    (SELECT 
        DATEDIFF(STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'), STR_TO_DATE(order_purchase_timestamp, ' %Y-%m-%d %H:%i:%s')) AS delivery_days
    FROM
        orders) AS delivery_days_summary;

### Business Insight
-- The average delivery time is 12.50 days, indicating that customers generally received their orders within about two weeks. However, the delivery times vary across orders, with some orders taking significantly longer than the average.

### Key Finding
-- The average delivery time for delivered orders is 12.50 days. Most orders were delivered within a few weeks, although some orders took considerably longer than the average.

/*----------------------------------------------------------
Objective 17: Analyze Order Cancellation and Delivery Status

Business Question:
What is the distribution of orders across different order
statuses, and how many orders were successfully delivered
compared with other order statuses?
----------------------------------------------------------*/
SELECT 
    order_status, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY order_status;

### Business Insight
-- Most orders were successfully delivered, with 96,478 orders reaching customers. A smaller number of orders were shipped, invoiced, processing, unavailable, or canceled, while only a few orders remained in the created or approved status.

### Key Finding
-- Delivered orders were the dominant order status, with 96,478 orders. Canceled orders totaled 625, while 609 orders were marked as unavailable.

 /*----------------------------------------------------------
 Objective 18: Calculate the Average Freight Cost per Order

 Business Question:
 What is the average freight cost associated with each order?
 ----------------------------------------------------------*/
SELECT 
    ROUND(AVG(total_freight_value), 2) AS avg_freight_value
FROM
    (SELECT 
        order_id, SUM(freight_value) AS total_freight_value
    FROM
        order_items
    GROUP BY order_id) AS freight_value_summary;
    
### Business Insight
-- The average freight cost per order was 22.82. This shows that customers paid an average of 22.82 in shipping charges for each order.

### Key Finding
-- The average total freight cost per order was 22.82.

/*----------------------------------------------------------
Objective 19: Analyze Order Volume by Customer State

Business Question:
Which customer states have the highest number of orders?
----------------------------------------------------------*/
SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

### Business Insight
-- SP has the highest order volume with 41,746 orders. RJ and MG also have high order volumes, while RR, AP, and AC have much lower order volumes.

### Key Finding
-- SP recorded the highest number of orders with 41,746 orders, followed by RJ with 12,852 orders and MG with 11,635 orders.

/*----------------------------------------------------------
Objective 20: Analyze Revenue by Customer State

Business Question:
Which customer states generate the highest total revenue,
and how does revenue vary across states?
----------------------------------------------------------*/
SELECT c.customer_state, ROUND(SUM(oi.price),2) AS total_revenue
FROM customers c 
JOIN orders o 
ON o.customer_id = c.customer_id 
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

### Business Insight
-- SP generated the highest total revenue at 5,202,955.05, followed by RJ at 1,824,092.67 and MG at 1,585,308.03. Revenue was much lower in states such as RR, AP, and AC.

### Key Finding
-- SP generated the highest total revenue of 5,202,955.05, followed by RJ with 1,824,092.67 and MG with 1,585,308.03. RR recorded the lowest total revenue at 7,829.43.

/*----------------------------------------------------------
Objective 21: Analyze Revenue by Product Category

Business Question:
Which product categories generate the highest total revenue,
and which categories contribute the least revenue?
----------------------------------------------------------*/

SELECT p.product_category_name , ROUND(SUM(oi.price), 2) AS total_revenue
FROM products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

### Business Insight
-- Revenue is concentrated among a few leading product categories. beleza_saude generated the highest revenue, followed by relogios_presentes and cama_mesa_banho, showing that these categories were strong revenue contributors.

### Key Finding
-- beleza_saude generated the highest revenue at 1,258,681.34, followed by relogios_presentes at 1,205,005.68 and cama_mesa_banho at 1,036,988.68. esporte_lazer and informatica_acessorios also ranked among the top revenue-generating categories.

/*----------------------------------------------------------
Objective 22: Analyze Average Product Price by Category

Business Question:
Which product categories have the highest average product
price, and how does the average price vary across categories?
----------------------------------------------------------*/
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.price), 2) AS average_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY average_price DESC;

### Business Insight
-- Average product prices vary significantly across categories. pcs has the highest average price at 1,098.34, followed by portateis_casa_forno_e_cafe at 624.29 and eletrodomesticos_2 at 476.12.

### Key Finding
-- pcs had the highest average product price at 1,098.34, followed by portateis_casa_forno_e_cafe at 624.29 and eletrodomesticos_2 at 476.12. casa_conforto_2 had the lowest average product price at 25.34.

/*----------------------------------------------------------
Objective 23: Analyze Freight Cost by Customer State

Business Question:
Which customer states have the highest average freight cost,
and how does freight cost vary across states?
----------------------------------------------------------*/
SELECT 
    customer_state,
    ROUND(AVG(total_freight_value), 2) AS avg_freight_value
FROM
    (SELECT 
        c.customer_state,
            oi.order_id,
            SUM(oi.freight_value) AS total_freight_value
    FROM
        customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_state , oi.order_id) AS freight_value_summary
GROUP BY customer_state
ORDER BY avg_freight_value DESC;

### Business Insight
-- Average freight cost varies considerably across customer states. RR has the highest average total freight cost per order at 48.59, while SP has the lowest at 17.37.

### Key Finding
-- RR recorded the highest average total freight cost per order at 48.59, followed by PB at 48.35 and RO at 46.22. SP had the lowest average total freight cost per order at 17.37.

/*----------------------------------------------------------
Objective 24: Analyze Average Delivery Time by Customer State

Business Question:
Which customer states have the longest average delivery time,
and how does delivery time vary across states?
----------------------------------------------------------*/
SELECT 
    customer_state ,ROUND(AVG(delivery_days),2) AS avg_delivery_days
FROM
    (SELECT 
        c.customer_state,
            DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, ' %Y-%m-%d %H:%i:%s'), STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS delivery_days
    FROM
        customers c
    JOIN orders o ON o.customer_id = c.customer_id
    WHERE
        o.order_delivered_customer_date IS NOT NULL) AS delivery_summary
GROUP BY customer_state
ORDER BY avg_delivery_days DESC;

### Business Insight
-- Delivery time varies considerably across customer states. RR has the highest average delivery time at 29.34 days, while SP has the lowest at 8.70 days. This indicates substantial differences in delivery performance across states.

### Key Finding
-- RR recorded the highest average delivery time at 29.34 days, followed by AP at 27.18 days and AM at 26.36 days. SP had the lowest average delivery time at 8.70 days, followed by PR at 11.94 days and MG at 11.95 days.


/*----------------------------------------------------------
Objective 25: Analyze Delivery Delays Against Estimated Dates

Business Question:
How often are orders delivered later than the estimated
delivery date, and which states experience more delays?
----------------------------------------------------------*/ 
SELECT 
    customer_state, ROUND(AVG(delay_days), 2) AS avg_delay_days
FROM
    (SELECT 
        c.customer_state,
            DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'), STR_TO_DATE(o.order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')) AS delay_days
    FROM
        customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE
        o.order_delivered_customer_date IS NOT NULL
            AND o.order_estimated_delivery_date IS NOT NULL) AS delivery_days_summary
GROUP BY customer_state
ORDER BY avg_delay_days DESC;

### Business Insight: 
-- The results indicate that delivery performance was generally ahead of estimated dates, while the variation across states suggests differences in logistics and delivery efficiency.

### Key Finding: 
-- AL had the highest average delivery difference at -8.71 days, while AC had the lowest at -20.73 days, indicating that orders were generally delivered before the estimated delivery date across all states.


/*----------------------------------------------------------
Overall Business Insights
------------------------------------------------------------*/

-- 1. The analysis shows that customers were actively placing orders, with a total of 99,441 orders.

-- 2. The business had a large customer base with 96,096 unique customers.

-- 3. The product catalog had a large number of products, giving customers many options to choose from.

-- 4. A total of 112,650 order items were sold, showing good demand for the products.

-- 5. SP had the highest number of orders and customers compared with other states.

-- 6. The business generated total revenue of 13,591,643.70, with an average order value of 137.75.

-- 7. Most orders were successfully delivered, with 96,478 orders having a delivered status.

-- 8. Most customers made only one purchase, showing that there is an opportunity to increase repeat purchases.

-- 9. Customers purchased an average of 1.14 items per order, which means most orders contained only one item.

-- 10. Average order value was different across states, with PB having the highest average order value and SP having the lowest.

-- 11. Order volume increased during 2017 and 2018, with November 2017 having the highest number of orders.

-- 12. The average delivery time was 12.50 days, so most customers received their orders within around two weeks.

-- 13. SP, RJ, and MG had the highest order volume and revenue, while some smaller states had much lower sales.

-- 14. beleza_saude, relogios_presentes, and cama_mesa_banho were among the highest revenue-generating product categories.

-- 15. Average product prices were different across categories, with pcs having the highest average product price.

-- 16. Freight costs were different across states, with RR having the highest average freight cost and SP having the lowest.

-- 17. Delivery time also varied across states, with RR having the longest average delivery time and SP having the shortest.

-- 18. Orders were generally delivered before the estimated delivery date, showing good overall delivery performance.

-- 19. The most active customer placed 17 orders, while the other top customers placed fewer orders, showing that purchases were spread across many customers.

-- 20. The differences in freight cost and delivery time across states show that logistics performance was not the same in every state.

-- 21. Overall, the analysis shows opportunities to improve repeat purchases, customer retention, and sales in lower-performing states and product categories.


SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

SELECT 







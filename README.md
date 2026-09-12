
# Olist E-Commerce SQL Analysis Project

## Project Overview

This project analyzes Olist e-commerce data using SQL. The main purpose is to understand order performance, product sales, customer behavior, revenue, delivery time, freight cost, and order status distribution.

This project includes 25 business questions and their SQL-based analyses. This section presents 10 selected analyses from the complete project.

The analysis was performed using MySQL and multiple related tables, including:

* `orders`
* `customers`
* `products`
* `order_items`

## Business Questions and SQL Analysis

### 1. What is the total number of orders placed?

```sql
SELECT COUNT(*) AS total_orders
FROM orders;
```

**Output:**

| total_orders |
| -----------: |
|        99441 |

**Key Finding:**
The dataset contains **99,441 total orders**.

---

### 2. How many unique products are available in the product catalog?

```sql
SELECT COUNT(*) AS total_products
FROM products;
```

**Output:**

| total_products |
| -------------: |
|          32340 |

**Key Finding:**
The product catalog contains **32,340 products**.

---

### 3. What is the total revenue generated from all orders?

```sql
SELECT ROUND(SUM(price), 2) AS total_revenue
FROM order_items;
```

**Output:**

| total_revenue |
| ------------: |
|   13591643.70 |

**Key Finding:**
The total revenue from product prices was **13,591,643.70**. Freight charges were not included in this calculation.

---

### 4. Which products have the highest order volume, and which product categories do they belong to?

```sql
SELECT 
    p.product_id,
    p.product_category_name,
    COUNT(oi.order_id) AS total_orders
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY 
    p.product_id,
    p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;
```

**Output:**

| product_id                       | product_category_name  | total_orders |
| -------------------------------- | ---------------------- | -----------: |
| aca2eb7d00ea1a7b8ebd4e68314663af | moveis_decoracao       |          527 |
| 99a4788cb24856965c36a24e339b6058 | cama_mesa_banho        |          488 |
| 422879e10f46682990de24d770e7f83d | ferramentas_jardim     |          484 |
| 389d119b48cf3043d311335e499d9c6b | ferramentas_jardim     |          392 |
| 368c6c730842d78016ad823897a372db | ferramentas_jardim     |          388 |
| 53759a2ecddad2bb87a079a1f1519f73 | ferramentas_jardim     |          373 |
| d1c427060a0f73f6b889a5c7c61f2ac4 | informatica_acessorios |          343 |
| 53b36df67ebb7c41585e8d54d6772e08 | relogios_presentes     |          323 |
| 154e7e31ebfa092203795c972e5804a6 | beleza_saude           |          281 |
| 3dd2a17168ec895c781a9191c1e95ad7 | informatica_acessorios |          274 |

**Key Finding:**
The product with the highest order volume belongs to the `moveis_decoracao` category and received **527 orders**. The `ferramentas_jardim` category appeared four times in the top 10 products.

---

### 5. How many customers are repeat buyers, and how many customers have placed only a single order?

```sql
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders,
        CASE 
            WHEN COUNT(o.order_id) = 1
                THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type;
```

**Output:**

| customer_type     | total_customers |
| ----------------- | --------------: |
| One-Time Customer |           93099 |
| Repeat Customer   |            2997 |

**Key Finding:**
There were **93,099 one-time customers** and **2,997 repeat customers**. Most customers placed only one order.

---

### 6. Which customer states have the highest average order value?

```sql
SELECT 
    customer_state,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT 
        c.customer_state,
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY 
        o.order_id,
        c.customer_state
) AS order_values
GROUP BY customer_state
ORDER BY average_order_value DESC
LIMIT 5;
```

**Output:**

| customer_state | average_order_value |
| -------------- | ------------------: |
| PB             |              265.01 |
| AC             |              242.84 |
| AP             |              239.16 |
| AL             |              234.13 |
| RO             |              233.03 |

**Key Finding:**
The state with the highest average order value was **PB**, with an average order value of **265.01**. **AC** ranked second with an average order value of **242.84**. The calculation includes both product prices and freight charges.

---

### 7. What is the average number of days taken to deliver an order to the customer?

```sql
SELECT 
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM (
    SELECT 
        DATEDIFF(
            STR_TO_DATE(
                order_delivered_customer_date,
                '%Y-%m-%d %H:%i:%s'
            ),
            STR_TO_DATE(
                order_purchase_timestamp,
                '%Y-%m-%d %H:%i:%s'
            )
        ) AS delivery_days
    FROM orders
    WHERE order_delivered_customer_date IS NOT NULL
) AS delivery_days_summary;
```

**Output:**

| avg_delivery_days |
| ----------------: |
|             12.50 |

**Key Finding:**
The average delivery time was **12.50 days** from order purchase to customer delivery.

---

### 8. What is the distribution of orders across different order statuses?

```sql
SELECT 
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status;
```

**Output:**

| order_status | total_orders |
| ------------ | -----------: |
| delivered    |        96478 |
| invoiced     |          314 |
| shipped      |         1107 |
| processing   |          301 |
| unavailable  |          609 |
| canceled     |          625 |
| created      |            5 |
| approved     |            2 |

**Key Finding:**
Most orders were successfully delivered, with **96,478 delivered orders**. Shipped orders were the second-largest group with **1,107 orders**. Canceled and unavailable orders were much lower compared with delivered orders.

---

### 9. What is the average freight cost associated with each order?

```sql
SELECT 
    ROUND(AVG(total_freight_value), 2) AS avg_freight_value
FROM (
    SELECT 
        order_id,
        SUM(freight_value) AS total_freight_value
    FROM order_items
    GROUP BY order_id
) AS freight_value_summary;
```

**Output:**

| avg_freight_value |
| ----------------: |
|             22.82 |

**Key Finding:**
The average freight cost associated with each order was **22.82**.

---

### 10. Which customer states generate the highest total revenue, and what are the top 5 states by revenue?

```sql
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 5;
```

**Output:**

| Customer State | Total Revenue |
| -------------- | ------------: |
| SP             |  5,202,955.05 |
| RJ             |  1,824,092.67 |
| MG             |  1,585,308.03 |
| RS             |    750,304.02 |
| PR             |    683,083.76 |

**Key Finding:**
São Paulo (SP) generated the highest total revenue of **5,202,955.05**. Rio de Janeiro (RJ) and Minas Gerais (MG) ranked second and third, with revenues of **1,824,092.67** and **1,585,308.03**, respectively. These three states generated considerably more revenue than the remaining states.

---

## Overall Key Findings

* The dataset contains **99,441 orders**.
* The product catalog contains **32,340 products**.
* Total product-price revenue was **13,591,643.70**, excluding freight charges.
* The highest-volume product received **527 orders**.
* The `ferramentas_jardim` category appeared four times among the top 10 products.
* There were **93,099 one-time customers** and **2,997 repeat customers**.
* PB had the highest average order value at **265.01**.
* The average delivery time was **12.50 days**.
* **96,478 orders** were successfully delivered.
* The average freight cost per order was **22.82**.
* São Paulo generated the highest total revenue at **5,202,955.05**.

## Power BI Dashboard

The SQL analysis was used to create an interactive Power BI dashboard for analyzing orders, customers, products, revenue, delivery performance, and freight costs.

### Dashboard Preview
![Overview Dashboard ](Overview%20Dashboard.png)

![Customer & Order Analysis Dashboard](Customer%20%26%20Order%20Analysis%20Dashboard.png)

![Product & Category Analysis Dashboard](Product%20%26%20Category%20Analysis%20Dashboard.png)


## Tools Used

* MySQL
* SQL
* Power BI
* Joins
* Aggregation Functions
* `GROUP BY`
* `ORDER BY`
* `CASE`
* Subqueries
* Common Table Expressions
* Date Functions

## Project Objective

The objective of this project is to use SQL to identify useful business insights from e-commerce data and understand customer behavior, product performance, revenue, delivery performance, and order operations.


# 👩‍💻 Author

**Komal Agarwal**

Data Analytics Project
Python • Pandas • Data Visualization • Exploratory Data Analysis

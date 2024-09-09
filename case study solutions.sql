CREATE SCHEMA dannys_diner;
use dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  -- task to do 
  -- 1. What is the total amount each customer spent at the restaurant?
  
 SELECT 
    s.customer_id, SUM(m.price) AS total_amount_spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
  
  -- 2. How many days has each customer visited the restaurant?
SELECT 
    customer_id, COUNT(DISTINCT order_date) AS visited_days
FROM
    sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH first_purchase AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM 
        sales
    GROUP BY 
        customer_id
)
SELECT 
    s.customer_id, 
    s.order_date,
    m.product_name
FROM 
    sales s
JOIN 
    first_purchase fp ON s.customer_id = fp.customer_id AND s.order_date = fp.first_order_date
JOIN 
    menu m ON s.product_id = m.product_id;
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    m.product_name, 
    COUNT(s.product_id) AS purchase_count
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
GROUP BY 
    m.product_name
ORDER BY 
    purchase_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH customer_purchases AS (
    SELECT 
        customer_id, 
        product_id, 
        COUNT(product_id) AS purchase_count
    FROM 
        sales
    GROUP BY 
        customer_id, 
        product_id
),
max_purchases AS (
    SELECT 
        customer_id, 
        MAX(purchase_count) AS max_purchase_count
    FROM 
        customer_purchases
    GROUP BY 
        customer_id
)
SELECT 
    cp.customer_id, 
    m.product_name, 
    cp.purchase_count
FROM 
    customer_purchases cp
JOIN 
    max_purchases mp ON cp.customer_id = mp.customer_id AND cp.purchase_count = mp.max_purchase_count
JOIN 
    menu m ON cp.product_id = m.product_id;
-- 6. Which item was purchased first by the customer after they became a member?
SELECT 
    s.customer_id,
    MIN(s.order_date) AS first_purchase_date,
    m.product_name
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
WHERE 
    s.order_date > (
        SELECT 
            join_date 
        FROM 
            members 
        WHERE 
            customer_id = s.customer_id
    )
GROUP BY 
    s.customer_id, m.product_name;
-- 7. Which item was purchased just before the customer became a member?
SELECT 
    s.customer_id,
    MAX(s.order_date) AS last_purchase_date,
    menu.product_name
FROM 
    sales s
JOIN 
    members m ON s.customer_id = m.customer_id
JOIN 
    menu ON s.product_id = menu.product_id
WHERE 
    s.order_date < m.join_date
GROUP BY 
    s.customer_id, menu.product_name;
-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
    m.customer_id,
    COUNT(s.product_id) AS total_items,
    SUM(menu.price) AS total_amount_spent
FROM 
    sales s
JOIN 
    members m ON s.customer_id = m.customer_id
JOIN 
    menu ON s.product_id = menu.product_id
WHERE 
    s.order_date < m.join_date
GROUP BY 
    m.customer_id;
-- 
SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN menu.product_name = 'sushi' THEN 2 * menu.price * 10
            ELSE menu.price * 10
        END
    ) AS total_points
FROM 
    sales s
JOIN 
    menu ON s.product_id = menu.product_id
GROUP BY 
    s.customer_id;
    
-- 10. In the first week after a customer joins the program (including their join date) they earn
-- 2x points on all items, not just sushi—how many points do customer A and B have at the
-- end of January?

WITH customer_points AS (
    SELECT 
        s.customer_id,
        SUM(
            CASE 
                WHEN s.order_date < DATE_ADD(m.join_date, INTERVAL 1 WEEK) THEN 2 * menu.price * 10
                ELSE menu.price * 10
            END
        ) AS total_points
    FROM 
        sales s
    JOIN 
        menu ON s.product_id = menu.product_id
    JOIN 
        members m ON s.customer_id = m.customer_id
    WHERE 
        s.order_date <= '2021-01-31'  -- End of January
    GROUP BY 
        s.customer_id
)
SELECT 
    customer_id,
    total_points
FROM 
    customer_points
WHERE 
    customer_id IN ('A', 'B');
-- Bonus Questions
/* Join All The Things
The following questions are related creating basic data tables that Danny and his team can use
to quickly derive insights without needing to join the underlying tables using SQL.
Recreate the following table output using the available data:
customer_idorder_dateproduct_namepricememberA2021–01–01curry15NA2021–01–01sushi10
NA2021–01–07curry15YA2021–01–10ramen12YA2021–01–11ramen12YA2021–01–11ramen12
YB2021–01–01curry15NB2021–01–02curry15NB2021–01–04sushi10NB2021–01–11sushi10YB
2021–01–16ramen12YB2021–02–01ramen12YC2021–01–01ramen12NC2021–01–01ramen12
NC2021–01–07ramen12N*/ 
SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
        WHEN mem.customer_id IS NULL THEN 'N'
        ELSE 'Y'
    END AS member
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
LEFT JOIN 
    members mem ON s.customer_id = mem.customer_id AND s.order_date >= mem.join_date
ORDER BY 
    s.customer_id, s.order_date;
-- Rank All The Things
/*Danny also requires further information about the ranking of customer products, but he
purposely does not need the ranking for non-member purchases so he expects null ranking
values for the records when customers are not yet part of the loyalty program.
customer_idorder_dateproduct_namepricememberrankingA2021–01–01curry15NnullA2021–01
–01sushi10NnullA2021–01–07curry15Y1A2021–01–10ramen12Y2A2021–01–11ramen12Y3A2
021–01–11ramen12Y3B2021–01–01curry15NnullB2021–01–02curry15NnullB2021–01–04sushi
10NnullB2021–01–11sushi10Y1B2021–01–16ramen12Y2B2021–02–01ramen12Y3C2021–01–
01ramen12NnullC2021–01–01ramen12NnullC2021–01–07ramen12Nnull*/
SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
        WHEN mem.customer_id IS NULL THEN 'N'
        ELSE 'Y'
    END AS member,
    CASE 
        WHEN mem.customer_id IS NOT NULL THEN
            (SELECT COUNT(*)
             FROM sales s_inner
             JOIN members mem_inner ON s_inner.customer_id = mem_inner.customer_id
             WHERE s_inner.customer_id = s.customer_id
             AND s_inner.order_date <= s.order_date
             AND s_inner.product_id = s.product_id
             AND s_inner.order_date >= mem_inner.join_date)  -- Ranking for members
    END AS ranking
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
LEFT JOIN 
    members mem ON s.customer_id = mem.customer_id
ORDER BY 
    s.customer_id, s.order_date;

















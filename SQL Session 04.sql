/* DS 7 
● Understanding Relationships Between Tables
● ERD=> Entity Relationship Diagram

composite attribute => combination of two or more attribute
attribute => Column
Entity => tables

● Primary and Foriegn Key
● JOINs to Combine Data from Multiple Tables
*/

-- INNER join: only the same matching values / common values from both tables
-- LEFT join: inner join + remaining records from left table
-- RIGHT join: inner join + remaining records from right table
-- FULL JOIN:  all records from both tables
-- CROSS JOIN: Returns the Cartesian product of the two tables, i.e., all possible combinations of rows.
/*
col_1    col2
A         1
B         2

A 1
A 2
B 1
B 2
/*
-- SELF join =  Joins a table to itself.

/*

employee_1
ahmad
usman
aliyan
fayyaz


employee_1
ahmad
usman
aliyan
fayyaz


emplyee_1   employee_2   department 
Ahmad      Usman          DS
ALiyan      Fayyaz        Software department

*/



-- Display datasets
select * from customer;
select * from products;
select * from purchase_history;


-- check data types
-- customer => date_of_birth

set sql_safe_updates = 0;
select * from customer;
update customer
set date_of_birth = str_to_date(date_of_birth,"%m/%d/%Y");

alter table customer 
modify date_of_birth DATE;



-- customer => signup_date
select * from customer;
update customer
set signup_date = str_to_date(signup_date,"%m/%d/%Y");

alter table customer 
modify signup_date DATE;

-- purchase_history => purchase_date
select * from purchase_history;
update purchase_history
set purchase_date = str_to_date(purchase_date,"%m/%d/%Y %H:%i");

alter table purchase_history 
modify purchase_date DATETIME;

-- temporary date format
select date_of_birth, date_format(date_of_birth, "%d-%m-%Y") from customer;


-- Primary and Foriegn Key

-- Table: customer
ALTER TABLE customer
ADD PRIMARY KEY (customer_id);

-- Table: products
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Table: purchase_history
ALTER TABLE purchase_history
ADD PRIMARY KEY (purchase_id);



-- Add foreign Keys
/*
Syntax:
ALTER TABLE child_table
ADD CONSTRAINT fk_name_id
FOREIGN KEY (parent_id) 
REFERENCES parent_table(id);

*/

-- customer_id in purchase_history refers to customer_id in customer_profile
ALTER TABLE purchase_history
ADD Constraint fk_customer_id
Foreign Key (customer_id)
References customer(customer_id);


/*
-- for removing foreign key
alter table purchase_history
drop Foreign key fk_customer_id;
*/

-- product_id in purchase_history refers to product_id in products:
ALTER TABLE purchase_history
ADD Constraint fk_product_id
Foreign Key (product_id)
References products(product_id);



-- INNER JOIN 
-- Exercise 1: Write a query to retrieve customer information with their purchase history:
select c.* , ph.*
from customer c
inner join purchase_history ph
On c.customer_id = ph.customer_id;


-- Exercise 2: Write a query to retrieve product details and their purchase history
select p.* , ph.purchase_date, ph.quantity, ph.total_amount
from products p
inner join purchase_history ph
On p.product_id = ph.product_id;


select products.* , purchase_history.purchase_date, purchase_history.quantity, purchase_history.total_amount
from products
inner join purchase_history 
On products.product_id = purchase_history.product_id;




-- Exercise 3: How many purchases (purchase_id) were made by each customer (customer_id) in total? (only mention those who have made payments)
select c.customer_id, count(ph.purchase_id) "Total Purchases"
from customer c
inner join purchase_history ph
On c.customer_id = ph.customer_id
group by c.customer_id;



-- Exercise 4: Which customers (customer_id) have spent more than $1500 in total (SUM(ph.total_amount)) on purchases?
select c.customer_id, sum(ph.total_amount) "Total Spent"
from customer c
inner join purchase_history ph
On c.customer_id = ph.customer_id
group by c.customer_id
having sum(ph.total_amount) > 1500;



-- Exercise 5: How many purchases (purchase_id) were made for each product category (p.category) that has been purchased?
select p.category, count(ph.purchase_id) "total purchases"
from products p
inner join purchase_history ph
on p.product_id = ph.product_id
group by p.category;

-- Exercise 6: Which products (p.product_name) are most frequently purchased (COUNT(ph.purchase_id)) by Female customers (c.gender = 'Female')?
select p.product_name, COUNT(ph.purchase_id) as "total purchases"
from products p
inner join purchase_history ph
on p.product_id = ph.product_id
inner join customer c
on ph.customer_id = c.customer_id
where c.gender = "Female"
group by p.product_name
order by COUNT(ph.purchase_id) desc;


-- products (product_id ) purchase_history ( customer_id ) customer




-- Left Join
-- Exercise 1: Which customers (customer_id) have not made any purchases (ph.purchase_id IS NULL)?
select c.*, ph.*
from customer c
left join purchase_history ph
on c.customer_id = ph.customer_id
where ph.purchase_id is NULL;


-- Exercise 2: Which products (product_id) have not been purchased (ph.purchase_id IS NULL)?
select p.*, ph.*
from products p
left join purchase_history ph
on p.product_id = ph.product_id
where ph.purchase_id is NULL;



-- Exercise 3: Analyze the sales (total_amount) for all products.
select p.product_name, sum(ph.total_amount) as "Total amount"
from products p
left join purchase_history ph
on p.product_id = ph.product_id
group by p.product_name;




-- RIGHT JOIN
-- Exercise 1: What is the total number of purchases (COUNT(ph.purchase_id)) and the total amount spent (SUM(ph.total_amount)) for each product brand (p.brand)?
select p.brand, count(ph.purchase_id) as Total_Purchases, SUM(ph.total_amount) as Total_Amount_Spent
from purchase_history ph
right join products p
on ph.product_id = p.product_id
group by p.brand;

-- Exercise 2: How many purchases (COUNT(ph.purchase_id)) has each customer (c.customer_id) made?
select c.customer_id ,count(ph.purchase_id) as TOtal_purchases
from purchase_history ph
right join customer c
on ph.customer_id = c.customer_id
group by c.customer_id;

-- TO DO task
-- Exercise 1: Fetch those customer's first name and last name who have made puchases.
select first_name,last_name from customer as c
inner join purchase_history as ph 
on c.customer_id = ph .customer_id;

-- Exercise 2: Display how much amount have been spent by each and every customer.
SELECT c.customer_id, c.first_name, SUM(ph.total_amount) AS total_spent
FROM customer AS c
RIGHT JOIN purchase_history AS ph
ON c.customer_id = ph.customer_id
GROUP BY c.customer_id, c.first_name;




-- Exercise 3: What is the the total amount spent (SUM(ph.total_amount)) for each category?
select p.category, sum(ph.total_amount) from products as p
left join purchase_history as ph
on p.product_id = ph.product_id
group by p.category;


select c.*, ph.*
from customer c
left join purchase_history ph
on c.customer_id =ph.customer_id

union

select c.*, ph.*
from customer c
right join purchase_history ph
on c.customer_id =ph.customer_id;


-- products with category

--  Exercise 1: Find products within the same category
select * from products;
select p1.product_name As Product1_Name,
p2.product_name As Product2_Name,
p1.category
from products p1
Join products p2
on p1.category = p2.category
and p1.product_id <> p2.product_id;
-- Exercise 2: Which customers live in the same city?
select * from customer;
SELECT 
    c1.first_name AS customer_1,
    c2.first_name AS customer_2,
    c2.city AS city
FROM
    customer c1
        JOIN
    customer c2 ON c1.city = c2.city
        AND c1.customer_id <> c2.customer_id;
        
        
        -- Exercise 3: Which products have similar prices?
SELECT 
    p1.product_id AS p1_ID,
    p1.product_name AS p1_Name,
    p2.product_id AS p2_ID,
    p2.product_name AS p2_Name,
    ABS(p1.price_per_unit - p2.price_per_unit) AS price_difference
FROM
    products p1
        JOIN
    products p2 ON p1.product_id < p2.product_id
WHERE
    ABS(p1.price_per_unit - p2.price_per_unit) < 3;
    
    -- Exercise: Pair each category with brand 
-- cross + self join
select * from products;
SELECT 
     distinct p1.category, p2.brand
FROM
    products p1
        CROSS JOIN
    products p2
    order by p1.category, p2.brand;
    
    
    
    SELECT avg(price_per_unit) FROM session_04.products;
-- '19.91466666666667'

-- list down products with price greater than average
select *
from products
where price_per_unit >  (SELECT avg(price_per_unit) FROM products);


-- Exercise: Display details of product which has the highest price?

select * from products;
-- Method-1
select max(price_per_unit) from products;
SELECT 
    *
FROM
    products
WHERE
    price_per_unit = 30;

-- Method 2
SELECT 
    *
FROM
    products
ORDER BY price_per_unit DESC
LIMIT 1;

-- Exercise 2: List the names of customers who have made purchases of a product with a specific product_id (e.g., product_id = 1).
SELECT customer_id,first_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM purchase_history
    WHERE product_id = 1
);

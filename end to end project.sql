select * from orders;
select * from user;
/*Find customers who have never ordered
Average Price per dish
Find the top restaurant in terms of the number of orders for a given month
Restaurants with monthly sales greater than x
Show all orders with order details for a particular customer in a particular date range
Find restaurants with max repeated customers
Month-over-month revenue growth of Foodpanda
Customer - favorite food
Find the most loyal customers for all restaurants
Month-over-month revenue growth of a restaurant
Most paired produ*/
-- 1
SELECT u.user_id,u.name,o.order_id
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
WHERE o.user_id IS NULL;

-- 2 Average Price per dish
select f.f_id, f.f_name, round(avg(m.price))
from food f
join menu m
on f.f_id = m.f_id
group by f.f_id,f.f_name;

-- 3 Find the top restaurant in terms of the number of orders for a given month
select r.r_name,count(o.order_id) as order_count 
from users

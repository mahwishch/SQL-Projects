-- data definition language 
-- create database

create database user_record; -- ctrl+enter
-- use or select database 
use user_record;
-- table create 

-- column name data type constriants 
create table users
(
ID int primary key,
user_name VARCHAR(100),
age int 
);
-- retreive data 

Select* from users; -- * refers all the data 
-- insert  a single entry 
insert into users (id , user_name, age )
values 
(2, "Ahmad", 22 ),
(3, "Ali",23),
(4, "Usman",24),
(5, "Bilal", 22),
(6, "Basit",19),
(7, "Ariyana", 17),
(8, "Daniyal",19),
(9, "Zia", 20),
(10,"Aliyan",19);

-- task 1
-- Task:
-- 1. Create Databse
-- 2. Create table with 3 columns atleast
-- 3. Insert around 15 entries

use task1;
CREATE TABLE Students (
    ID INT PRIMARY KEY,
    user_name VARCHAR(100),
    age INT
);
INSERT INTO Students(id , user_name, age )
values 
 (1,"nadia",23),
(2,"sana",24),
(3,"hina",22),
(4,"ali",27);

-- load data  using GUI using tble import wizard

SELECT * FROM books_data;

-- fetch only 2 columns 
select book_name,type ,on_promotion from books_data; -- querry optimization 

-- fetch all unique language from books_data

Select language from books_data;
select distinct language from books_data;

-- list down details of books with product_real_price is greater than 950
select * from books_data
where product_real_price > 950;

-- where (in ,and ,or ,like,or  not and not equal to)
-- show those book with engliah language

select * from books_data 
where language ="English";

-- order by

--  sort the dataset by 
select * from books_data
order by product_real_price;  -- by default it is in ascending

select * from books_data
order by product_real_price desc;

-- limit 

select * from books_data
limit 3;

-- top 5 expensive books
select * from books_data
order by product_real_price desc
limit 5;

show databases; -- to show the names of all existing databases 
show tables;










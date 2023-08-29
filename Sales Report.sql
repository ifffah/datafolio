-- Dataset from: https://www.kaggle.com/datasets/ronnykym/online-store-sales-data
-- Queried using: MySQL Workbench

-- First, using the in built functions on MySQL Workbench, I create a new database titled testdb3
-- Next, we import the dataset as a csv file into the database
use testdb3;
show tables;

-- To preview the full dataset
Select *
FROM salesreport;

-- We want to know the categories and persons for each list
SELECT distinct category
FROM salesreport;
SELECT Distinct sales_rep
FROM salesreport
ORDER BY sales_rep asc;
SELECT Distinct sales_manager
FROM salesreport
ORDER BY sales_manager asc;
SELECT Distinct device_type
FROM salesreport;

-- To count each of them
SELECT 
	count(Distinct device_type) as "No. of devices",
    count(distinct category) AS "No. of category",
    count(Distinct sales_rep) AS "No. of sale representatives",
    count(Distinct sales_manager) AS "No. of sale managers",
    count(Distinct customer_name) AS "No. of customers"
FROM salesreport;
-- So there are 3 devices customers use to order
-- 10 different categories
-- 35 sale representatives
-- 15 sale managers
-- And 75 customers

-- Are the managers specified to a certain item category?
SELECT 
	sales_manager, 
    count(DISTINCT sales_manager, category) AS "No. of categories handled"
FROM salesreport
GROUP BY Sales_manager
ORDER BY count(DISTINCT sales_manager, category) desc;
-- Seems like the sale managers are not assigned
-- However, Orsa Geekin only handles 2 categories
SELECT *
FROM salesreport
WHERE sales_manager = "Orsa Geekin";
-- Orsa Geekin might be a new sales manager considering she only has 2 sales

-- Sort sales manager according to the number of sales
SELECT 
	sales_manager, 
    COUNT(*) AS 'No. of Sales'
FROM salesreport
GROUP BY sales_manager
ORDER BY count(*) desc;
-- Celine Tumasian and Othello Bowes are two managers with the highest number of sales

-- Now we look for the same insights for sale representatives
SELECT 
	sales_rep, 
	count(DISTINCT sales_rep, category) AS "No. of categories handled"
FROM salesreport
GROUP BY Sales_rep
ORDER BY count(DISTINCT sales_rep, category) desc;

-- Sort sales rep according to the number of sales
SELECT sales_rep, COUNT(*) AS 'No. of Sales'
FROM salesreport
GROUP BY sales_rep
ORDER BY count(*) desc;

-- Before we dive into sale and cost
-- I will change the column order_value_eur to sales to make querying slighty easier

ALTER TABLE salesreport 
RENAME COLUMN order_value_eur TO sales;

-- Who is the highest-paying customer
SELECT 
customer_name,
CONCAT('$', CAST(sum(sales) AS DECIMAL(10,2))) AS "Total sales"
FROM salesreport
GROUP BY customer_name
ORDER BY sum(sales) DESC
LIMIT 1;

-- What is the best and least selling category?
SELECT category, COUNT(*) AS 'No. of Sales'
FROM salesreport
GROUP BY category;
-- Highest selling category: clothing and least selling Other

-- The average order value of books
SELECT CONCAT('$', CAST(avg(sales) AS DECIMAL(10,2)))  AS "Average Orders on Books"
FROM salesreport
WHERE category LIKE 'Books';

-- Profit
SELECT CONCAT('$', sum(sales - cost)) AS "Total Profits"
FROM salesreport;

-- Which manager raked in the most sales
SELECT 
	sales_manager,
    CONCAT('$', sum(sales - cost)) AS "Total Profits",
    count(*) AS "No. of Sales"
FROM salesreport
GROUP BY sales_manager
ORDER BY sum(sales - cost) desc;

SELECT 
	sales_rep,
    CONCAT('$', sum(sales - cost)) AS "Total Profits",
    count(*) AS "No. of Sales"
FROM salesreport
GROUP BY sales_rep
ORDER BY sum(sales - cost) desc;
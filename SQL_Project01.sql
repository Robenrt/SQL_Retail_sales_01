CREATE DATABASE sql_project01;

USE sql_project01;
DROP TABLE IF exists sql_retail_sales_analysis_utf;
CREATE TABLE retail_sales(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
                gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);

SELECT * FROM retail_sales;
SELECT count(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;


SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;



SELECT count(*) as total_sale FROM retail_sales;
SELECT count(customer_id) as total_sale FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;



-- Business Problems
-- write a SQL query to review all columns for sales made on "2022-11-05"
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Write a  SQL query to retrieve all transaction where the category is 'clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales rs
Where rs.category = 'Beauty' AND rs.quantity > 3 AND (rs.sale_date BETWEEN '2022-11-01' AND '2022-11-30');


-- Write a Sql query to calculate the total sales for each category
SELECT category, SUM(total_sale), count(*) as total_orders FROM retail_sales
GROUP BY 1;


-- Write a Sql query to find the average age of customers who purchased items from the Beauty category.
SELECT ROUND(AVG(age)) as average_age FROM retail_sales
WHERE category='Beauty';


-- Write a Sql query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Write sql query to find the total number of transactions made by each gender in each country.
SELECT  Category, gender, COUNT(transactions_id) as total_transactions FROM retail_sales
GROUP BY Category, gender;


-- Write a sql query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT * FROM(
SELECT YEAR(sale_date) as  year, MONTH(sale_date), AVG(total_sale) AS avg_sale, RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranks FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC ) as t1
WHERE ranks = 1;


-- write a sql query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) as total_sales FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Write a sql query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(distinct customer_id) AS Unique_customer FROM retail_sales
GROUP BY category;


-- Write a sql query to create each shift and number of orders(example morning, afternoon, evening)
WITH hourly_sales AS
(
SELECT *,
		CASE
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
			END AS shift
	FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders FROM hourly_sales
GROUP BY shift
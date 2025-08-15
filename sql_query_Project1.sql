-- SQL Retail Sales Analysis -p1
CREATE DATABASE sql_project_p1;

-- Create Table
CREATE TABLE retail_sales
                         (
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

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE
     transactions_id IS NULL
     OR
     sale_date IS NULL
     OR 
     sale_time IS NULL
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

SELECT 
COUNT(*) 
FROM retail_sales;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customer we have?
SELECT COUNT(Distinct customer_id) as total_customers FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business key problems & Answers

-- Q.1 Write a SQL query to retieve all columns for sales made on '2022-11-05'
-- Q.2. Write a SQL query to retieve all transactions where the category is 'cloyhinh' and the 
quantity sold is more than 4 in the month of Nov-2022
-- Q.3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty'
category.
-- Q.5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6. Write a SQL query to find the total number of transactions (transaction_id) made by each
gender in each category.
-- Q.7. Write a SQL query to calculate the average sale for each month. Find out best selling month
in each year.
-- Q.8. Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q.9. Write a SQL query to find the  number of unique customers who purchased items 
from each category.
-- Q.10. Write a SQL query to create each shift and number of orders
(Example Morning <12, Afternoon between 12 & 17, Evening >17).

-- Q.1 Write a SQL query to retieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q.2. Write a SQL query to retieve all transactions where the category is 'clothing' and the 
quantity sold is more than 4 in the month of Nov-2022;

SELECT category, SUM(quantity)
FROM retail_sales
WHERE category = 'Clothing'
  AND 
  date_format(sale_date, '%y-%m') = '2022-11'
  AND
  quantity >= 4;
  
  -- Q.3. Write a SQL query to calculate the total sales (total_sale) for each category.
  
SELECT 
      category,
      SUM(total_sale) AS net_sale,
      COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
;

-- Q.4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty'
category;

SELECT 
	  AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

SELECT 
	 ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6. Write a SQL query to find the total number of transactions (transaction_id) made by each
gender in each category;

SELECT
	  category,
      gender,COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category,
		 gender
ORDER BY 1;

-- Q.7. Write a SQL query to calculate the average sale for each month. Find out best selling month
in each year;

SELECT year, month, avg_sale
FROM ( 
      SELECT
			YEAR(sale_date) AS year,
			month(sale_date) AS month,
            avg(total_sale) AS avg_sale,
            RANK() OVER (PARTITION BY YEAR(sale_date)
ORDER BY AVG(total_sale) DESC) AS rnk
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rnk =1;

-- Q.8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	  customer_id,
      sum(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

-- Q.9. Write a SQL query to find the  number of unique customers who purchased items 
from each category;

SELECT 
	  category,
      COUNT(DISTINCT customer_id) AS cnt_uniq_ustomers
FROM retail_sales
GROUP BY category
;

-- Q.10. Write a SQL query to create each shift and number of orders
(Example Morning <12, Afternoon between 12 & 17, Evening >17);

WITH hourly_sale
AS
(
SELECT *,
      CASE
          WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
          WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
          ELSE 'Evening'
	  END AS shift
FROM retail_sales
)
SELECT 
      shift,
	  count(*) as total_orders
FROM hourly_sale
GROUP BY shift;

-- End of the Project
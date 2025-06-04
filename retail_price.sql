create database retail_price;
use retail_price;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
-- 
select count(*) from retail_sales;
-- Data Cleaning
select * from retail_sales where transaction_id is null;
select * from retail_sales where 
transaction_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantity is null
or cogs is null
or total_sale is null;
-- 
delete from retail_sales where 
transaction_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantity is null
or cogs is null
or total_sale is null;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many uniuque customers we have ?
select count(distinct customer_id)as total_sale from retail_sales;

select count(distinct category)as total_sale from retail_sales;

select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    sale_date >= '2022-11-01'and sale_date<'2022-12-01'
    AND
    quantity >= 4;
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, 
sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales 
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
round(avg(age),2) as avg_age
from retail_sales 
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales 
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category, gender,
count(*) as total_trans
from retail_sales
group by
category, gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_avg AS 
(
select 
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
	avg(total_sale) as avg_sale
from retail_sales
group by YEAR,MONTH
),
ranked_months AS 
(
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rn
  FROM monthly_avg
)
SELECT year, month, avg_sale
FROM ranked_months
WHERE rn = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select 
customer_id,
sum(total_sale) as Total
 from retail_sales
group by 1
order by 2 desc
limit 5; 

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) as unique_customer
from retail_sales
group by category; 

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT
  CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY shift;

-- END OF PROJECT

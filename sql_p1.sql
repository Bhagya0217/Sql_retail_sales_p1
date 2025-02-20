create table retail_sales(
transactions_id int primary key,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(25),
age	int,
category varchar(25),	
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float
);

select * from retail_sales;


select count(*)
from retail_sales where transactions_id
is null;


select *
from retail_sales 
where
transactions_id is null or
sale_date is null or
sale_time	is null or
customer_id	is null or
gender	is null or
category	is null or
quantiy	is null or
price_per_unit	is null or
cogs	is null or
total_sale is null ;
delete from retail_sales
where
transactions_id is null or
sale_date is null or
sale_time	is null or
customer_id	is null or
gender	is null or
category	is null or
quantiy	is null or
price_per_unit	is null or
cogs	is null or
total_sale is null ;

---data exploration


-- how many sales we have
select count(*) as total_sale from retail_sales;

---how many unique customers we have
select count (distinct customer_id )as total_customer from retail_sales;

---how many categories are there
select count (distinct category )as total_category from retail_sales;




-----data analysis & business key problems and answers

--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

select * from retail_sales
where sale_date = '2022-11-05';


--2. **Write a SQL query to retrieve all transactions where the category is
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

SELECT *FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4

---3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

---
--4. **Write a SQL query to find the average age of customers 
--who purchased items from the 'Beauty' category.**:

select 
round(avg(age), 2) as avg_age
from retail_sales 
where category = 'Beauty'


----5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

select  * from retail_sales
where total_sale >1000;

---6. **Write a SQL query to find the total number of transactions 
--(transaction_id) made by each gender in each category.**:

select category,gender,
count(*) as total_trans
from retail_sales
group by category, gender
order by 1;

---7. **Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year**

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

---8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


---9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category


---10. **Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift




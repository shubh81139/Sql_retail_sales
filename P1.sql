-- SQl Retail Sales Analysis 

-- Create Table 
create table retail_sales
(
	 transactions_id int, 
	 sale_date	date, 
	 sale_time	time,
	 customer_id	int,
	 gender	varchar(15),
	 age	int,
	 category	varchar(15),
	 quantiy	int,
	 price_per_unit	float,
	 cogs	float,
	 total_sale float

);

select count(*) from retail_sales

-- Checking for null values 
	
select * from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or
    customer_id is null
    or 
    gender is null
    or 
    age is null
    or 
    category is null
    or 
    quantiy is null
    or 
    price_per_unit is null
    or 
    cogs is null 
    or
    total_sale is null;


--Deleting the null value rows

delete from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or
    customer_id is null
    or 
    gender is null
    or 
    age is null
    or 
    category is null
    or 
    quantiy is null
    or 
    price_per_unit is null
    or 
    cogs is null 
    or
    total_sale is null;


-- Data Exploration

-- How many sales we have ?

Select count(*) as total_sale from retail_sales;

-- How many customers we have ?

select count (distinct customer_id)
from retail_sales ;

select count (distinct category)
from retail_sales ;

-- Data Analysis And Business key Problems And Answer

-- Q.1 Write a sql query to retrieve all the columns for sales made on 2022-11-05 .

select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of nov-22

select * from retail_sales
where category ='Clothing' and quantiy >=4 and to_char(sale_date,'yyyy-mm') = '2022-11'


-- Q.3 Write a sql query to calculate total sale from each category .

select category , sum(total_sale) as total_sale from retail_sales 
group by category;

--Q.4 Write a sql query to find the average age of customers who purchased item for the 'beauty category' 

select category , round(avg(age),2) as avg_age from retail_sales
where category = 'Beauty'
group by category;

--Q.5 Write a sql query to find all the transaction where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >1000

--Q.6 Write a sql query to find total number of transaction made by each gender in each category.

select  gender , category ,count(transactions_id) as total_trans from retail_sales
group by gender ,category;


--Q.7 Write a sql query to calculate the average sale for each month. Find out best selling month in each year.

select * from 
	
	( select 
	extract (year from sale_date) as year, 
	extract (month from sale_date) as month,
	avg(total_sale) as avg_sale,
    rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc)	as rank 
    from retail_sales
    group by 1,2
	) as t1

where rank = 1;

--Q.8 Write a sql query to find the top 5 customers based on the highest total sale 
	
select
	customer_id as customer,
	sum(total_sale) as total_sales
from  retail_sales
group by 1
order by 2 desc
limit 5;

--Q.9 Write a sql query to find the number of unique customers who purchased item 	from each category.

select 
	category,
	count(distinct customer_id)
	
from retail_sales
group by category;

--Q.10 Write a sql query to create each shift and number of orders (Example Morning  <=12 , Afternoo between 12 and 17 Evening >17)

with hourly_sales as 
	(
	select *,
	case
	when  extract(hour from sale_time) < 12 then 'Morning' 
	when  extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
    from retail_sales
	) 

select 
	shift ,
	count (*) as total_sales
from hourly_sales	
group by shift;





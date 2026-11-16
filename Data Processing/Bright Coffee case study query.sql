---Check for duplicates records
SELECT store_location,product_type,--,product_detail,product_category,
COUNT(*) AS duplicate_count
FROM retail.coffee_sales.bright_coffee_shop
GROUP BY store_location,product_type--,product_detail,product_category
HAVING COUNT(*) > 1;


----Check the number of records
SELECT COUNT(*) AS number_of_records
FROM retail.coffee_sales.bright_coffee_shop;

---Check for NULL
select  * 
from retail.coffee_sales.bright_coffee_shop
WHERE (transaction_id,transaction_date,transaction_time,transaction_qty,store_id,store_location,product_id,unit_price,product_category,product_type,product_detail) IS NOT NULL;

------------------------
--Total Revenue
select 
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop;

--Total revenue per product type
select 
product_type,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by all;
order by total_revenue desc

---Total revenue per product quantity
select 
product_category,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by all;

--Total revenue per store
Select 
Store_location,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
Group by all
Order by total_revenue desc;

--Revenue per transaction
select 
transaction_id,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by all;

--Total revenue per product category and product details
select 
Product_category,
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by all;

--Total units solds
select 
sum(transaction_qty) as units_solds
from retail.coffee_sales.bright_coffee_shop;

---Products generating most revenue
select 
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by product_detail
order by total_revenue desc;


--Products generating least revenue
select 
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by product_detail
order by total_revenue ASC;

---Product category generating most revenue
select 
Product_category,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by product_category
order by total_revenue desc;

--Product category generating least revenue
select 
Product_category,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by product_category
order by total_revenue ASC;

---Product by store that is generating most revenue
select 
Store_location,
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by Store_location,Product_detail
order by total_revenue desc;    

---Product by store that is generating least revenue
select 
Store_location,
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue
from retail.coffee_sales.bright_coffee_shop
group by Store_location,Product_detail
order by total_revenue ASC;    

----earliest and latest transaction time
select 
min(transaction_time) as Earliest_transaction_time,
Max(transaction_time) as Latest_transaction_time
from retail.coffee_sales.bright_coffee_shop;

--Transaction time per day
select 
Store_location,
Product_detail,
product_category,
 sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS DECIMAL(10,2)))) as total_revenue,
case  when transaction_time between '06:00:00' and '11:59:59' then 'Morning'
      when transaction_time between '12:00:00' and '16:59:59' then 'Afternoon'
      when transaction_time between '17:00:00' and '19:59:59' then 'Evening'
 Else 'Night'
END AS Time_of_the_day
from retail.coffee_sales.bright_coffee_shop
Group by all
order by total_revenue;

---Total transaction per hour
select 
case  when transaction_time between '06:00:00' and '11:59:59' then 'Morning'
      when transaction_time between '12:00:00' and '16:59:59' then 'Afternoon'
      when transaction_time between '17:00:00' and '19:59:59' then 'Evening'
 Else 'Night'
END AS Time_of_the_day,
Count(transaction_id) as total_transactions
from retail.coffee_sales.bright_coffee_shop
Group by all;

------Total product transaction per hour
select
Store_location,
--Product_detail,
--product_category,
case  when transaction_time between '06:00:00' and '11:59:59' then 'Morning'
      when transaction_time between '12:00:00' and '16:59:59' then 'Afternoon'
      when transaction_time between '17:00:00' and '19:59:59' then 'Evening'
 Else 'Night'
END AS Transaction_time_bucket,
Count(transaction_id) as total_transactions
from retail.coffee_sales.bright_coffee_shop
Group by all;

--Product revenue percentage
select 
Product_detail,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS double))) as total_revenue,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS Double)))* 100/sum(sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS Double)))) over() as percentage
from retail.coffee_sales.bright_coffee_shop
Group by all
order by total_revenue desc;

---Date extraction (month_name,month_id)

select 
product_category,
transaction_date,
monthname(transaction_date) as month_name,
month(transaction_date) as month_id,
dayname(transaction_date) as day,
dayofweek(transaction_date) as day_of_week,
year(transaction_date) as year
from  retail.coffee_sales.bright_coffee_shop
group by all;

-------Final Query

Select 
transaction_id,
Store_location,
product_type,
Product_detail,
product_category,
transaction_date,
monthname(transaction_date) as month_name,
month(transaction_date) as month_id,
dayname(transaction_date) as day,
dayofweek(transaction_date) as day_of_week,
year(transaction_date) as year,
case  when transaction_time between '06:00:00' and '11:59:59' then 'Morning'
      when transaction_time between '12:00:00' and '16:59:59' then 'Afternoon'
      when transaction_time between '17:00:00' and '19:59:59' then 'Evening'
 Else 'Night'
END AS Transaction_time_bucket,
sum(transaction_qty*(CAST(REPLACE(UNIT_PRICE,',','.')AS decimal(10,2)))) as total_Amount,
sum(transaction_qty) as units_solds,
Count(transaction_id) as total_transactions
from retail.coffee_sales.bright_coffee_shop
Group by all
Order by total_amount desc;
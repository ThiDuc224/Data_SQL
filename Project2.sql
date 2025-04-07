select* from bigquery-public-data.thelook_ecommerce.distribution_centers
---1.  number of customers and completed orders 1/2019 to 4/2022 
---- count distinct_ number of customers and number of orders=> then group by month , to group by month , need to chain the M-Y as a string so group by will be valid 
select* from bigquery-public-data.thelook_ecommerce.order_items
SELECT 
  FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year,
  COUNT(DISTINCT user_id) AS total_customer,
  COUNT(DISTINCT order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE created_at BETWEEN '2019-01-01' AND '2022-05-01'
GROUP BY 1
ORDER BY 1;
--- Insight analysis: 
  - 
---2. AVO  averge orders and total number of customers each month 
--- output month_year, distinct_users, average_order_value 
select
FORMAT_TIMESTAMP('%Y-%m', created_at) as month_year,
 COUNT(DISTINCT user_id) AS total_customer,
round(sum(sale_price)/count(distinct order_id),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01' and '2022-05-01'
group by 1;
--- Insight: comment 2019 
-- notes : try to use CTE, select from the previous data? 
---3.Segmentation Analysis: group customer by age and gender 
  ---- find youngest cutomers and oldest customer by genders. 
  --- output: first_name, last_name, gnder, age, tag(yougest or oldest customer)
--- use row_number over (partition by gender and order by age asc/desc)
--- then tag yougest and oldest per gender base on previous ranking 
--- combine and count total 
with needed_data as (select id as user_id, gender, age
from bigquery-public-data.thelook_ecommerce.users
where created_at BETWEEN '2019-01-01' AND '2022-04-30' )

,ranking_group as (select *, 
 DENSE_RANK() OVER (PARTITION BY gender ORDER BY age ASC) AS youngest_rank,
    DENSE_RANK() OVER (PARTITION BY gender ORDER BY age DESC) AS oldest_rank
from  needed_data), tag_age as 
(SELECT *,
    CASE 
      WHEN youngest_rank = 1 THEN 'Youngest'
      WHEN oldest_rank = 1 THEN 'Oldest'
    END AS tag
  FROM ranking_group
  WHERE youngest_rank = 1 OR oldest_rank = 1) 

select  gender, tag,
count(*) as user_count 
from tag_age
group by gender, tag 
order by gender, tag
  ---Insight: 
---4. top five highest revenue products each month 
---- rank each product . Expected output: month_year, product_id, name, sales, cost, profit, rank_per month 
select* 
from bigquery-public-data.thelook_ecommerce.products
select* 
from bigquery-public-data.thelook_ecommerce.distribution_centers
select* 
from bigquery-public-data.thelook_ecommerce.order_items
--- check the table have needed information , take information from products table and order_items where product_id = id 
--select, time  sale, cost, profit= sale-cost, only completed orders is calculated 
select*from(with profit_table as (Select 
CAST(FORMAT_DATE('%Y-%m', t1.delivered_at) AS STRING) as month_year,
t1.product_id as product_id,
t2.name as product_name,
sum(t1.sale_price) as sales,
sum(t2.cost) as cost,
sum(t1.sale_price)-sum(t2.cost)  as profit
from bigquery-public-data.thelook_ecommerce.order_items as t1
Join bigquery-public-data.thelook_ecommerce.products as t2 on t1.product_id=t2.id
Where t1.status='Complete'
Group by month_year, t1.product_id, t2.name)

select * , 
dense_rank() over(partition by month_year order by month_year,profit) as rank
from  profit_table) as rank_table
where rank_table.rank <=5 
order by rank_table.month_year,rank_table.rank

--- daily revenue of each category of productt in the last 3 months 
--- output : date(yyy-mm-date), product_categories, revenue 

Select 
CAST(FORMAT_DATE('%Y-%m-%d', t1.delivered_at) AS STRING) as dates,
t2.category as product_categories,
round(sum(t1.sale_price),2) as revenue,
from bigquery-public-data.thelook_ecommerce.order_items as t1
Join bigquery-public-data.thelook_ecommerce.products as t2 on t1.product_id=t2.id
Where t1.status='Complete' and t1.delivered_at BETWEEN '2022-01-15 00:00:00' AND '2022-04-16 00:00:00'
Group by dates, product_categories
Order by dates
----Part 2 : create data set and cohort_table 
---Assume that your team need the data file with required information which prepare to use with BI tool in the future. Create a data set using SQL and save as vw_ecommerce_analyst in view 
---  extract month, year, product_category, total revenue/month(TPV), total order_per month(TPO), revenue growth(%), order_growth(%), tptal cost per month 
---- total profit_ permonth 
--- profit_cost_ratio 






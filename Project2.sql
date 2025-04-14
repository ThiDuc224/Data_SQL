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
---2. AVO  average orders and the total number of customers each month 
--- output month_year, distinct_users, average_order_value 
select
FORMAT_TIMESTAMP('%Y-%m', created_at) as month_year,
 COUNT(DISTINCT user_id) AS total_customer,
round(sum(sale_price)/count(distinct order_id),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01' and '2022-05-01'
group by 1;
--- Insight: comment 2019 
-- notes: try to use CTE, select from the previous data? 
---3.Segmentation Analysis: group customers by age and gender 
  ---- Find the youngest customers and the oldest customer by gender. 
  --- output: first_name, last_name, gnder, age, tag(yougest or oldest customer)
--- use row_number over (partition by gender and order by age asc/desc)
--- then tag youngest and oldest per gender based onthe  previous ranking 
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
---- Rank each product . Expected output: month_year, product_id, name, sales, cost, profit, rank_per month 
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
---- Revenue_growth ((current-previous)/previous) * 100% -- uses lag() over(pertition by...) to find the previous value 

Create view vw_ecommerce_analyst as (with base_data as (SELECT 
    FORMAT_DATE('%m', t1.created_at) AS Month,
    FORMAT_DATE('%Y', t1.created_at) AS Year,
    t2.category AS product_category, 
    ROUND(SUM(t1.sale_price), 2) AS TPV, 
    ROUND(SUM(t2.cost), 2) AS total_cost, 
    COUNT(t1.order_id) AS TPO
  FROM bigquery-public-data.thelook_ecommerce.order_items AS t1 
  JOIN bigquery-public-data.thelook_ecommerce.products AS t2 
    ON t1.product_id = t2.id
  GROUP BY Month, Year, product_category)
  select base_data.Month,base_data.Year,base_data.product_category,base_data.TPO,base_data.TPV,base_data.total_cost,
  round(((base_data.TPV- base_data.total_cost)/base_data.total_cost),2) as profit_ration ,
 round((base_data.TPV-lag(base_data.TPV) over(partition by base_data.product_category order by base_data.Month,base_data.Year))/lag(base_data.TPV) over(partition by base_data.product_category order by base_data.Month,base_data.Year)*100 ,2)|| "%" as  revenue_growth,
 round((base_data.TPO-lag(base_data.TPO) over(partition by base_data.product_category order by base_data.Month,base_data.Year )/lag(base_data.TPO) over(partition by base_data.product_category order by base_data.Month,base_data.Year ))*100,2)|| "%" as TPO_growth
 from base_data 
order by base_data.product_category, base_data.Month, base_data.Year)
--- Cohort_analysis filted_data
  --- Corhort_month as index  ( (year - year first_purchase)* 12 + month1 - month 2 +1 ) as index , customer
  --- first_purchase : min invoice_date, current_date 
  --- count number of customers and sum_revenue 
--- Cohort Chart 
-- pivot table=> cohort_chart: sum ( case index and the number of customers in each index) 
WITH a AS (
  SELECT 
    user_id AS customer_id,
    created_at,
    MIN(created_at) OVER (PARTITION BY user_id) AS first_date_purchase,
    sale_price AS amount
  FROM 
    `bigquery-public-data.thelook_ecommerce.order_items),

b AS (
  SELECT
    customer_id,
    amount,
    FORMAT_DATE('%Y-%m', DATE(first_date_purchase)) AS cohort_month,
    ((EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_date_purchase)) * 12 +
      EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_date_purchase) + 1) AS index
  FROM a),

c AS (
  SELECT 
    COUNT(DISTINCT customer_id) AS num_customers,
    cohort_month,
    index,
    SUM(amount) AS total_revenue
  FROM 
    b
  GROUP BY 
    cohort_month, index),

customer_cohort AS (
  SELECT 
    cohort_month, 
    SUM(CASE WHEN index = 1 THEN num_customers ELSE 0 END) AS m1,
    SUM(CASE WHEN index = 2 THEN num_customers ELSE 0 END) AS m2,
    SUM(CASE WHEN index = 3 THEN num_customers ELSE 0 END) AS m3,
    SUM(CASE WHEN index = 4 THEN num_customers ELSE 0 END) AS m4
  FROM 
    c 
  GROUP BY 
    cohort_month),

retention_cohort AS (
  SELECT 
    cohort_month,
    m1,
    ROUND(100.0 * m1 / m1, 2) AS r1,
    ROUND(100.0 * m2 / m1, 2) AS r2,
    ROUND(100.0 * m3 / m1, 2) AS r3,
    ROUND(100.0 * m4 / m1, 2) AS r4
  FROM 
    customer_cohort)

-- Churn cohort calculation from numeric retention
SELECT 
  cohort_month,
  (100 - r1) || '%' AS m1_churn,
  (100 - r2) || '%' AS m2_churn,
  (100 - r3) || '%' AS m3_churn,
  (100 - r4) || '%' AS m4_churn
FROM 
  retention_cohort
ORDER BY 
  cohort_month;
----insights 
https://docs.google.com/spreadsheets/d/121spu6F1K7FZhHTMye1tc-EBlFJR2eF6/edit?gid=1772514665#gid=1772514665
-- Comment: In general, the number of customers increased each month. However, the return rate is quite low in the first 4 months under 10% 
---=> indicates low loyalty rate 








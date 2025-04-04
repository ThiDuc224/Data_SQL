--EX1: 
with new_table as 
(SELECT 
extract(year from transaction_date) as year_spend, product_id,
sum(spend) as current_spend
FROM user_transactions
group by extract(year from transaction_date), product_id
order by product_id)
select year_spend, product_id, current_spend,
lag(current_spend)over(partition by product_id order by year_spend) as pre_spending, 
round(((current_spend-lag(current_spend)over(partition by product_id order by year_spend))/lag(current_spend)over(partition by product_id order by year_spend))*100,2)
from new_table
;
--EX2 
with new as 
(select card_name, issue_month, 
sum(issued_amount)over(partition by card_name,issue_month) as total_monthly
from monthly_cards_issued
order by  card_name,issue_month)
select card_name,
total_monthly
from new 
where issue_month =1;
--Exercise 1 
select name
from city 
Where countrycode='USA'
and population > 120000
;
--- Exercise 2 
select * 
from city 
where countrycode='JPN'
;
---Ex3
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE 'A%'
AND CITY NOT LIKE 'E%'
AND CITY NOT LIKE 'I%'
AND CITY NOT LIKE 'O%'
AND CITY NOT LIKE 'U%';
--EX 8
select name
from employee
where salary > 2000
and months <10
order by employee_id asc;
-- Ex9 
select product_id 
from Products 
where low_fats= 'Y'
and recyclable='Y'
;
---ex10
select name 
from customer
where referee_id is null or  referee_id <> 2 -- Null is the customers are not refered by anyone
;
--ex 11 
Select name, population, area
from World 
where area >= 3000000 
or population >= 25000000
order by name asc
;
--ex12 select distinct+ remane the output
select distinct author_id as id
from Views 
where author_id= viewer_id
order by id asc
;
--Tesla Interview 
SELECT part, assembly_step
FROM parts_assembly
where finish_date is NULL
;
--ex 15
SELECT advertising_channel
FROM uber_advertising
WHERE money_spent > 100000
AND year = 2019;

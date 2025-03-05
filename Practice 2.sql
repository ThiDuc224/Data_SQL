-- EX1 
select distinct city 
from station 
where ID%2=0;
--EX2 
Select count(city)- count(distinct city )
from station; 
---EX4: mean of order
SELECT ROUND(CAST(SUM(item_count * order_occurrences) AS NUMERIC) / SUM(order_occurrences),  1) AS mean
FROM items_per_order;
----EX5 : select candidates have all 3 skills in P, T and SQL
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) = 3
ORDER BY candidate_id ASC;
---ex6
SELECT 
  user_id,
  (DATE(MAX(post_date)) - DATE(MIN(post_date))) AS different
FROM posts
WHERE post_date >= '2021-01-01' 
  AND post_date < '2022-01-01'
GROUP BY user_id 
HAVING COUNT(post_id) >= 2;
--ex7
SELECT card_name, 
  (max(issued_amount)- min(issued_amount)) as different
FROM monthly_cards_issued
group by card_name
order by different desc;
---ex8 
select manufacturer, 
count(drug) as total_drug, 
sum(total_sales-cogs) as total_loss
from pharmacy_sales
where total_sales<cogs
group by manufacturer
order by total_loss ASC;
--ex9 
SELECT id, movie, description, rating
FROM Cinema
WHERE id % 2 = 1
  AND description <> 'boring'
ORDER BY rating DESC;
--ex10 
select teacher_id, 
count(distinct subject_id) as total
from Teacher 
group by teacher_id;
--ex11 
select distinct user_id,
count(follower_id) as followers_count
from followers 
group by user_id
order by user_id asc;
--ex12
select class
from Courses
group by class 
having count(student)>=5
; 

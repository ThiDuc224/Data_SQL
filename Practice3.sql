---ex-1-
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3) ASC, ID ASC;
SELECT 
    manufacturer, 
    CONCAT('$', ROUND(SUM(total_sales) / 1000000), ' million') AS total_sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;
--ex 2 
SELECT user_id, 
       CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;
---ex3 
SELECT 
    manufacturer, 
    CONCAT('$', ROUND(SUM(total_sales) / 1000000), ' million') AS total_sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;
---ex4
SELECT 
    product_id, 
    EXTRACT(MONTH FROM submit_date) AS month, 
    ROUND(AVG(stars), 2) AS rating
FROM reviews
GROUP BY product_id, EXTRACT(MONTH FROM submit_date)
ORDER BY month ASC, product_id ASC;
----ex5
SELECT 
sender_id, count(message_id)
FROM messages
where send_date between "2022-08-01" and "2022-02-02"---- or WHERE EXTRACT(MONTH FROM sent_date) = 8 AND EXTRACT(YEAR FROM sent_date) = 2022--
group by sender_id
order by count(message_id)desc
limit 2
;
--ex6
select tweet_id
from tweets
where length(content)>15;
--ex7 
select activity_date, count(distinct user_id) as active_users
from Activity
where activity_date between " 2019-06-28" and "2019-07-27"
group by activity_date;
--Ex8 
select 
count(id) as total_hired
 from employees
 where extract(month from joining_date) between 1 and 7
 and  extract(year from joining_date)=2022
;
---x9

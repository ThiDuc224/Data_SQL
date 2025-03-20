--EX1 
SELECT B.continent, 
Floor(AVG(A.Population)) as average
from City as A 
join Country as B on A.Countrycode=B.code 
group by B.continent;
--EX2-- 
SELECT 
    ROUND((COUNT(DISTINCT CASE WHEN b.signup_action = 'Confirmed' THEN a.email_id END) * 100.0) / COUNT(DISTINCT a.email_id), 2 ) AS activation_rate
FROM Emails AS a
LEFT JOIN Texts AS b ON a.email_id = b.email_id;
---EX3-- using CTE for the shorten name 
WITH activity_summary AS (
    SELECT 
        ab.age_bucket,
        SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) AS total_send,
        SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) AS total_open
    FROM activities AS a
    JOIN age_breakdown AS ab ON a.user_id = ab.user_id
    WHERE a.activity_type IN ('send', 'open')
    GROUP BY ab.age_bucket)

SELECT 
    age_bucket,
    ROUND(total_send * 100.0 / (total_send + total_open), 2) AS send_perc,
    ROUND(total_open * 100.0 / (total_send + total_open), 2) AS open_perc
FROM activity_summary;
---EX4 
SELECT 
    a.customer_id
FROM customer_contracts AS a
JOIN products AS b ON a.product_id = b.product_id
WHERE b.product_category IN ('Analytics', 'Containers', 'Compute')
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) = 3;
----Ex5 
SELECT 
    e1.employee_id, 
    e1.name, 
    COUNT(e2.employee_id) AS reports_count, 
    ROUND(AVG(e2.age)) AS average_age
FROM 
    Employees e1
LEFT JOIN 
    Employees e2 ON e1.employee_id = e2.reports_to
GROUP BY 
    e1.employee_id, e1.name
HAVING 
    COUNT(e2.employee_id) > 0
ORDER BY 
    e1.employee_id;

---Ex6: 
select A.product_name, sum(B.unit) as unit
from products as A 
join orders as B on A.product_id=B.product_id
where extract(Year from B.order_date)=2020
and  extract(month from B.order_date)=2
group by A.product_name
having sum(B.unit)>=100
; 
---Ex7
SELECT p.page_id
FROM pages AS p
LEFT JOIN page_likes AS l ON p.page_id = l.page_id
WHERE l.page_id IS NULL
ORDER BY p.page_id ASC;

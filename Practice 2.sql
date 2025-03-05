-- EX1 
select distinct city 
from station 
where ID%2=0;
--EX2 
Select count(city)- count(distinct city )
from station; 
---EX4
SELECT ROUND(CAST(SUM(item_count * order_occurrences) AS NUMERIC) / SUM(order_occurrences),  1) AS mean
FROM items_per_order;

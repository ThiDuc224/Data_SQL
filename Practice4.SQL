---EX1: 
select 
  sum(case when device_type='laptop' then 1 else 0 end)as laptop_views,
  sum(case when device_type in ('tablet','phone') then 1 else 0 end)as mobile_views
from viewership;
--EX2: 
select x,y,z,
case 
    when x+y>z and y+z>x and z+y>x then 'Yes'else 'No'
end as triangle
from triangle;
---EX3: 
SELECT 
    ROUND((SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END) * 100.0)/ COUNT(*), 1) AS uncategorized_percentage
FROM callers;
--Ex4: 
select name 
from customer
where referee_id is null or  referee_id <> 2
;
--Ex5 

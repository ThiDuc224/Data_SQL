-- EX1 
select distinct city 
from station 
where ID%2=0;
--EX2 
Select count(city)- count(distinct city )
from station; 
---EX3 

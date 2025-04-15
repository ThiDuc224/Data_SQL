---1: Subqueries where: https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50
Select customer_id, 
round(sum(case when order_date=customer_pre_delivery_date then 1 else 0 end)/count(*)*100,2) as Immedidate
from delivery 
where (customer_id,order_date)in 
(select customer_id, Min(order_date)
from delivery 
group by customer_id);

---2: # list the first_date log in 
# The list of player log in in the next day 
# select  total player access in next day/total_players from first_list
with first_list as  (select 
player_id, 
Min(event_date) as first_log_in 
from activity 
group by player_id),
Next_log_in as (select 
a.player_id
from activity a 
join first_list as b on a.player_id=b.player_id
and a.event_date = DATE_ADD(f.first_login_date, INTERVAL 1 DAY))
select 
round (count(distinct c.player_id)/count(distinct b.player_id),2) as Fraction
from first_list as b
left join next_log_in as c on b.player_id=c.player_id;
----3: 
     # select seat_id 
# find last student is odd or even 
# even case : id/2=0, odd: id/2<>0 
# Swap : id: odd +1 and id even -1> example 1 swap for 2 : then 1(odd)+1=2 and 2(even)-1=1
# last id: select max(id)from seat 
select 
    case 
        when id%2=0 then id-1 
        when id%2=1and id+1<= (select max(id)from seat) then id+1
        else id
    end as id, 
    student 
from seat 
order by id;   
----4: 
          # average moving: 6 days before 
# first_day visit +6 
# select visit on between visit on and interval 6 previous day 
# Select visit on and amount 
# sum visit on total amount and average =total/7
select
    visited_on,
    sum(amount) as amount,
    round(sum(amount) / 7, 2) as average_amount
from (
    select
        a.visited_on,
        b.amount
    from
        (select distinct visited_on from Customer) a
    join Customer b 
        on b.visited_on between date_sub (a.visited_on, intervalL 6 day) and a.visited_on
) moving
group by visited_on
having count(*) >= 7
order by  visited_on;
--5 # find total tiv_2016 
# same value as tiv_2015 as one or more other policy holders 
# unique location , lat,lon only once 
select sum(tiv_2016) as tiv_2016
from insurance 
where tiv_2015 in (select tiv_2015 
from insurance 
group by tiv_2015 
having count(*) >1) and (lat,lon) in (select lon, lat 
from insurance 
group by lon, lat 
having count(*)=1)
;
--6 
  with boarding_order as (
  select *,sum(weight) over(order by turn) as total_weight
  from Queue)
  select person_name 
  from (select person_name, turn 
        from boarding_order where total_weight <=1000) as listed_order
  order by turn DESC
  limit 1;


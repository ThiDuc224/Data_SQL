select* 
from actor;
select first_name,last_name
from actor; 
select*
from customer;
select first_name as "ten kh", last_name as "ten",email
from customer;
-- Orderby
select* 
from payment
order by customer_id DESC, payment_date asc
;
--- Distinct 
select distinct first_name,last_name
from actor 
order by first_name
; 
select distinct amount 
from payment
order by amount asc;
----Limit 
select* 
from payment 
order by amount DESC 
limit 100;
--- where 
select * 
from payment 
where not amount >= 10
order by payment desc
;

select* ---select five latest order customers
from actor
where not first_name is null
order by last_update desc
limit 5
;
--example: select the amount of payment <= $2
select* 
from payment 
where amount <=2
order by amount desc
;
-- and or 
select *
from payment 
where (customer_id= 322 or customer_id= 346 or customer_id=354 )
and (amount < 2 or amount >10 )
order by customer_id ASC , amount desc
;
--- IN- WHEN WANT TO SELECT THE SEPECIFIC ITEMS 
select * 
from payment 
where (customer_id in ( 322,346,354))
and (amount<2 or amount>10)
;
select* 
from payment 
where (customer_id in ( 12,25,67,93,124,134))
AND (amount in ( 4.99,7.99,9.99))
and payment_date between '2020-01-01'and '2020-02-01'
;
--- like 
select * 
from actor
where first_name  like 'N%'
or first_name like '_S%' and first_name  like '_J%'
;
select* 
from film
where description like '%Saga%'
and (title like '%A' or title like 'R%')
order by title ASC
;
select* 
from customer
where first_name like '%ER%'
and first_name like '_A%'
order by last_name asc
;
-- Aggregate function 

select * 
from payment
;
SELECT customer_id, 
       SUM(amount) AS total_amount
FROM payment 
GROUP BY customer_id;
---group by 
SELECT* 
FROM FILM;
SELECT film_id, title, 
	Min(replacement_cost) as min_cost,  
	Max(replacement_cost) as max_cost, 
	round(avg(replacement_cost),2) as avg_cost
from film 
group by film_id 
order by film_id; 
---Having - select after calculating data 
SELECT customer_id, 
       DATE(payment_date) AS payment_date, 
       round(AVG(amount),2) AS avg_payment, 
       COUNT(payment_id) AS payment_count
FROM payment
WHERE DATE(payment_date) IN ('2020-04-28', '2020-04-29', '2020-04-30')
GROUP BY customer_id, DATE(payment_date)
HAVING COUNT(payment_id) > 1
ORDER BY avg_payment DESC;

SELECT film_id, 
       rental_rate, 
       replacement_cost, 
       ROUND(rental_rate / replacement_cost, 2) AS percentage
FROM film
WHERE ROUND(rental_rate / replacement_cost, 2) < 4
ORDER BY film_id;
-----Date, String-------
select 
Upper(first_name) as Ten,
lower(last_name) as Ho
from customer
where length(first_name)>= 10 
or length(last_name)>=10 
;
--left,right--
select 
left(right(email,4),1)
from customer;

---Concatenate-- 
SELECT 
  CONCAT(first_name, '.', last_name, '@sakilacustomer.org') AS customer_email,
  CONCAT(LEFT(first_name, 3), '***.', last_name,right(email,20)) AS securities
FROM customer;


----position 
SELECT 
  email, 
  position('@'in email) AS at_position,
  LEFT(email, position('@'in email) - 1) AS new_name
FROM customer;

----substring-- extract information from the available one-- 
SELECT 
  email, 
  POSITION('.' IN email) AS position_1,
  POSITION('@' IN email) AS position_2,
  SUBSTRING(email FROM POSITION('.' IN email) + 1 FOR POSITION('@' IN email) - POSITION('.' IN email) - 1) AS last_names
FROM customer;
--- 
SELECT 
  email, 
  SUBSTRING(email FROM 1 FOR POSITION('.' IN email) - 1) AS name_customer,
  CONCAT(SUBSTRING(email FROM 1 FOR POSITION('.' IN email) - 1),' ' ,last_name) AS name_surname
FROM customer;
select extract(month from payment_date),
	sum(amount)
from payment
group by extract(month from payment_date);

--Interval 
SELECT 
  customer_id, 
  rental_date, 
  return_date,
 CONCAT(EXTRACT(DAY FROM return_date - rental_date) * 24 + EXTRACT(HOUR FROM return_date - rental_date),' hours') AS duration
FROM rental
group by customer_id,rental_date,return_date
	having(EXTRACT(DAY FROM return_date - rental_date) * 24 + EXTRACT(HOUR FROM return_date - rental_date)
) >=50
order by customer_id;
-- 
select
film_id,
case 
	when rating in('PG','PG-13') or length> 210 then 'tier1'
	when description like '%Drama%'and length>90 then 'tier2'
	when description like '%Drama%'and length<90 then 'tier3'
	when rental_rate <1 then 'very_cheap'
end as four_tier
from film
where
   rating in('PG','PG-13') or length> 210 or
	 (description like '%Drama%'and length>90 )
	or description like '%Drama%'and length<90 
	or rental_rate <1 
;
--- pivot table--
SELECT 
    CASE 
        WHEN length > 120 THEN 'long'
        WHEN length BETWEEN 60 AND 120 THEN 'medium'
        ELSE 'short'
    END AS category,
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS r,
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS PG,
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS PG_13
FROM film
GROUP BY category;
# Window function 
select 
from film as F 
join category as C on F.
select* 
from category;
select *
from film;
select* 
from film_category;
---window function rank, avg
select a.film_id,c.name,a.length,a.title,
avg(a.length)over(partition by c.name )
from film as a 
join film_category as b on a.film_id=b.film_id 
join category as c on b.category_id=c.category_id
order by film_id;
select a.customer_id, 
sum(b.amount) over(partition by a.customer_id) as total_amount,
count(b.payment_id)over(partition by a.customer_id,b.amount) as number_payment
from customer as A
join payment as B on A.customer_id=B.customer_id
order by A.customer_id;

--window function rank
select a.film_id,c.name,a.length,a.title,
rank() over(partition by c.name order by a.length)desc )
from film as a 
join film_category as b on a.film_id=b.film_id 
join category as c on b.category_id=c.category_id
;


select a.film_id,c.name,a.length,a.title,
rank() over(partition by c.name order by a.length desc) as rank1, 
Dense_rank() over(partition by c.name order by a.length desc) as rank_2,
row number() over(partition by c.name order by a.length desc as rank_3
from film as a 
join film_category as b on a.film_id=b.film_id 
join category as c on b.category_id=c.category_id
;
select* 
from customer;
select*
from address; 
select *
from country; 
select* from city; 
select * from payment;
---- 
select * 
from(select a.first_name,a.last_name, d.country, 
count(*) as so_luong, 
sum(e.amount) as total_amount,
rank() over(partition by d.country order by sum(e.amount) desc) as rank1
from customer as a 
join address as b on a.address_id=b.address_id
join city as c on b.city_id=c.city_id 
join country as d on c.country_id.country_id 
join payment as e on a.customer_id=e.customer_id
group by a.first_name,a.last_name, d.country)
as T
where T.rank1 <=3
;

select * 
from(select 
customer_id, payment_date, amount, 
row_number()over(partition by customer_id order by payment_date desc)as rank1
from payment) as A
where rank1=1
;

with new_table as
(select date(payment_date) as date,
sum(amount) as total_revenue 
from payment
group by date(payment_date))
select date,total_revenue, 
lag(total_revenue)over(order by date)as previous_value,
total_revenue-lag(total_revenue)over(order by date)
from new_table;
next_value-
lag(amount)over(partition by customer_id order by payment_date ) as previous_value,
(amount-lag(amount)over(partition by customer_id order by payment_date ) as dff
from payment;
# ALTER TABLE 
#create& drop 
# customer_id, full_name,email, address
# save as customer_information 
create table customer_infromation as 
(select 
customer_id, concat(first_name,'  ',last_name) as full_name, 
email, b.address
from customer as a 
join address as b on a.address_id=b.address_id) 
drop table customer_infromation

select*
from customer_infromation; 


## create view to see the table change with the update data at the same time
create view vw_customer as  
(select 
customer_id, concat(first_name,'  ',last_name) as full_name, 
email, b.address
from customer as a 
join address as b on a.address_id=b.address_id) 




# film, title, length, category, order by length desc 
# only film category in ( "action","comody")
select* from film_category
select * from category 
create or replace view  view_film as 
(select a.film_id, a.title, a.length as film_duration, c.name as category_name 
from film as a 
join film_category as b on a.film_id=b.film_id
join category as c on b.category_id=c.category_id )
where c.name in ('Action','Comedy')
order by a.length desc)
select * 
from view_film
where category_name in ('Action','Comedy')
order by category_name desc
; 


# update film 0.99 into 1.99 
# Change table customer 
	# add column initial( data type varchar( 10)) 
	# update data to initial ( 1 letter of first_name and 1 of last_name 
	)
update film 
set rental_rate= 1.99 
where rental_rate=0.99
select * from film 
order by rental_rate asc;
#alter table 
alter table customer 
add column initials varchar(10)
select* from customer; 
update customer
set initials =left(first_name,1)||'.'|| left(last_name,1)
select * from customer;

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

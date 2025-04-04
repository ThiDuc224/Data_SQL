# 2 ways to find outliers by SQL
# 1st way: using plot box: find min( Q1-1.5*IQR) and max (Q3+1.5IQR) in which : IQR=Q3-Q1
	# finding Q1,Q3, Min and Max=> create CTE 
	# find outlier=>from CTE select min, Max =>  use subqueries with where to find outlier
WITH new_table AS (
  SELECT
    percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS Q1,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY users) AS Q3,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY users) -percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS IQR,
    
    percentile_cont(0.25) WITHIN GROUP (ORDER BY users) -1.5 * ( percentile_cont(0.75) WITHIN GROUP (ORDER BY users) - percentile_cont(0.25) WITHIN GROUP (ORDER BY users)) AS min_outlier,
    
    
    percentile_cont(0.75) WITHIN GROUP (ORDER BY users) +
    1.5 * (percentile_cont(0.75) WITHIN GROUP (ORDER BY users) - percentile_cont(0.25) WITHIN GROUP (ORDER BY users) ) AS max_outlier FROM user_data)

SELECT *
FROM user_data 
WHERE users < (SELECT min_outlier FROM new_table)
   OR users > (SELECT max_outlier FROM new_table);

# 2nd way using Z_core= (actual value - avg)/ stdev
	# select avg, stdv, create cte 
	# create new table and find Z_score 
	# Update data from the new table found Z_score 
with new_table as(select data_date, users,
(select avg(users) from user_data) as avg_users,(select stddev(users) from user_data) as Stdd
from user_data), out_liner as 
(select 
data_date, users, (users-avg_users)/Stdd as Z_score 
from new_table
where abs((users-avg_users)/Stdd)>2.5)

update user_data 
set users=(select avg(users) from user_data)
where users in (select users from out_liner)
select * from user_data;
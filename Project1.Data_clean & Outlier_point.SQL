#project1 import&clean data 
# create new table 
create table SALES_DATASET_RFM_PRJ

(ordernumber VARCHAR,

quantityordered VARCHAR,

priceeach        VARCHAR,

orderlinenumber  VARCHAR,

sales            VARCHAR,

orderdate        VARCHAR,

status           VARCHAR,

productline      VARCHAR,

msrp             VARCHAR,

productcode      VARCHAR,

customername     VARCHAR,

phone            VARCHAR,

addressline1     VARCHAR,

addressline2     VARCHAR,

city             VARCHAR,

state            VARCHAR,

postalcode       VARCHAR,

country          VARCHAR,

territory        VARCHAR,

contactfullname  VARCHAR,

dealsize         VARCHAR

) 

#clean data using alter 
# modify data_type 
alter table sales_dataset_rfm_prj 
alter column price_each type integer

alter table sales_dataset_rfm_prj 
alter column quantity_ordered type numeric

alter table sales_dataset_rfm_prj 
alter column quantity_ordered type integer 

alter table sales_dataset_rfm_prj 
alter column price_each type numeric
# check null/blank 
select* 
from sales_dataset_rfm_prj 
where price_each is null  
	or order_number is  null or order_number =' '
	or sales is null 
	 or quantity_ordered is null;
# add column, first_name, last_name 
select* 
from sales_dataset_rfm_prj;
alter table sales_dataset_rfm_prj
add column first_name varchar(10)
alter table sales_dataset_rfm_prj
add column last_name varchar(10)
# update column 
alter table sales_dataset_rfm_prj
alter column first_name type varchar(50)
alter table sales_dataset_rfm_prj
alter column last_name type varchar(50)
# update first_name column
update sales_dataset_rfm_prj
set first_name=left(contact_full_name,position('-' in contact_full_name)-1)
# update last_name column 
update sales_dataset_rfm_prj
set last_name=substring(contact_full_name from position('-' in contact_full_name)+1)
select* 
from  sales_dataset_rfm_prj
upper(last_name);
select 
substring(contact_full_name from position('-' in contact_full_name)-1)
from sales_dataset_rfm_prj;
update sales_dataset_rfm_prj
set first_name=concat(upper(left(first_name,1),lower(substring(first_name,2));
UPDATE sales_dataset_rfm_prj
SET first_name = CONCAT(
    UPPER(LEFT(first_name, 1)), 
    LOWER(SUBSTRING(first_name FROM 2))
);
UPDATE sales_dataset_rfm_prj
SET last_name = CONCAT(
    UPPER(LEFT(last_name, 1)), 
    LOWER(SUBSTRING(last_name FROM 2))
);
select* 
from  sales_dataset_rfm_prj;
alter table sales_dataset_rfm_prj
add column month_id int ;
alter table sales_dataset_rfm_prj
add column year_id int;
alter table sales_dataset_rfm_prj
add column QTR_ID int;
update sales_dataset_rfm_prj
set month_id= extract(month from order_date );
update sales_dataset_rfm_prj
set year_id= extract(year from order_date );
update sales_dataset_rfm_prj
set QTR_ID= extract(quarter from order_date ); 
select * 
from  sales_dataset_rfm_prj;

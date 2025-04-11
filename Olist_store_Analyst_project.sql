#Start of the project 
#creation of database
create database Olist_Store_Analyst;
use Olist_Store_Analyst;

select * from customer_o;
select * from location;
select * from order_iteam;
select * from order_o;
select * from order_payments;
select * from order_review;
select * from products;
select * from sellers;
select * from product_category_name;

-- KPI1 --
-- Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics --

select 
  case when weekday(str_to_date(o.order_purchase_timestamp,"%m/%d/%Y %H:%i")) In (5,6) then "Weekend" else "Weekday" end as DayType,
  count(Distinct o.order_id) as Total_orders,
  round(sum(p.payment_value)) as Total_payments,
  round(avg(p.payment_value)) as Average_Payment
from
  order_o o
join
  order_payments p on o.order_id=p.order_id
group by
DayType;

-- KPI 2 -- 
-- Number of Orders with review score 5 and payment type as credit card. --


select payment_type,
 count(Distinct p.order_id) as Total_Orders
from  
 order_payments p 
join
 order_review r on p.order_id=r.order_id
where  p.payment_type="credit_card"
and r.review_score=5;

-- KPI 3 --
-- Average number of days taken for order_delivered_customer_date for pet_shop --


select
 p.product_category_name,
 round(avg(datediff(str_to_date(order_delivered_customer_date,"%m/%d/%Y %H:%i"),str_to_date(order_purchase_timestamp,"%m/%d/%Y %H:%i")))) as Avg_delvery_time
from 
order_o o
join
order_iteam oi on oi.order_id=o.order_id
join
products p on  p.product_id=oi.product_id
where p.product_category_name="pet_shop";

-- KPI 4 -- 
-- Average price and payment values from customers of sao paulo city --


select
 round(avg(oi.price)) as Avg_price,
 round(avg(p.payment_value)) as Avg_payment_value
from 
customer_o c 
join 
order_o o  on o.customer_id  = c.customer_id
join
order_iteam oi on oi.order_id = o.order_id
join
order_payments p on p.order_id=oi.order_id
where
c.customer_city = "sao paulo";

-- KPI 5 --
-- Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.--


select
   round(avg(datediff(str_to_date(order_delivered_customer_date,"%m/%d/%Y %H:%i"),str_to_date(order_purchase_timestamp,"%m/%d/%Y %H:%i")))) as Avg_Shipping_days,
   review_score
  from
  order_o o
  join
  order_review r on o.order_id = r.order_id
  group by
  review_score
  order by
  Avg_shipping_days desc;









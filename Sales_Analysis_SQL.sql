--pre analysis
exec sp_help 'orders'

select top 5 * from orders;
select count(*) from orders;--9994 rows
select distinct state from orders;--532
select distinct category from orders;--Office Supplies, Furniture, Technology --3
select distinct sub_category from orders;--17 
select distinct ship_mode from orders;--First class , Same day, Standard class, Second class
select distinct segment from orders;--Corporate, Home Office, Consumer

-------------------------*WILDCARDS*
--1- write a query to get all the orders where customer name neither start with "A" nor ends with "N"
select * from orders where customer_name like '[^A]%[^N]';

select distinct customer_name from orders where customer_name like '%e[i apq][anc]g%'

select distinct customer_name from orders where customer_name like 'a[a-f]%' 

------------------------*DATA AGGREGATION*
--2- write a query to get total profit, first order date and latest order date for each category
select category , sum(profit) as total_profit, min(order_date) as first_order_date,max(order_date) as latest_order_date from orders group by category

--3- write a query to find total number of products in each category.
 select category,count(distinct product_id) total_products from orders group by category

--4- write a query to find top 5 sub categories in west region by total quantity sold
select top 5  sub_category, sum(quantity) as total_quantity
from orders
where region='West'
group by sub_category
order by total_quantity desc

--5- write a query to find total sales for each region and ship mode combination for orders in year 2020
select region,ship_mode ,sum(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region,ship_mode

------------------------*JOINS*
--6- write a query to get region wise count of return orders
select region,count(distinct o.order_id) as no_of_return_orders
from orders o 
inner join returns r on o.order_id=r.order_id
group by region 

--7- write a query to get category wise sales of orders that were not returned
select o.category,round(sum(sales),2) sales
from orders o
left join returns r
on o.order_id=r.order_id
where r.order_id is null
group by o.category

--8- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3

--9- write a query to find cities where not even a single order was returned.
select city
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0

--10- write a query to find top 3 subcategories by sales of returned orders in east region
select top 3 sub_category,sum(o.sales) as return_sales
from orders o
inner join returns r on o.order_id=r.order_id
where o.region='East'
group by sub_category
order by return_sales  desc

------------------------*BUILT IN FUNCTIONS*
--11- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)

select sub_category
from orders o
left join returns r 
on o.order_id=r.order_id
where DATEPART(month,order_date)=11
group by sub_category
having count(r.order_id)=0;

--12-write a query to find order ids where there is only 1 product bought by the customer.

select order_id
from orders 
group by order_id
having count(1)=1

--13- write a query to get number of business days between order_date and ship_date (exclude weekends). Assume that all order date and ship date are on weekdays only

select 
datediff(day,order_date,ship_date) as actual_day,
datediff(day,order_date,ship_date) - 2*(datediff(week,order_date,ship_date)) as business_days  
from orders

--14- write a query to get number of business days between order_date and ship_date (including weekends).

with cte as (
select order_date,ship_date,DATENAME(DW, order_date) as ord,DATENAME(DW, ship_date) as ship 
from orders
)
,cte_week as(
select *
,case ord when 'Saturday' then DATEADD(day, 2, order_date) when 'Sunday' then DATEADD(day, 1, order_date) else order_date end as week_order
,case ship when 'Saturday' then DATEADD(day, 2, ship_date) when 'Sunday' then DATEADD(day, 1, ship_date) else order_date end as week_ship
 from cte
)
select week_order,week_ship
,datediff(day,week_order,week_ship) as actual_days
,datediff(day,week_order,week_ship)-2*datediff(week,week_order,week_ship) as business_days
from cte_week
order by week_order

--15- write a query to print 3 columns : category, total_sales and (total sales of returned orders)
select o.category,sum(o.sales) as total_sales
,sum(case when r.order_id is not null then sales end) as return_orders_sales
from orders o
left join returns r on o.order_id=r.order_id
group by category

--16- write a query to print below 3 columns
--category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)
select category,sum(case when datepart(year,order_date)=2019 then sales end) as total_sales_2019
,sum(case when datepart(year,order_date)=2020 then sales end) as total_sales_2020
from orders 
group by category

--17- write a query print top 5 cities in west region by average no of days between order date and ship date.

select top 5 city, avg(datediff(day,order_date,ship_date) ) as avg_days
from orders
where region='West'
group by city
order by avg_days desc

--18- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
select customer_name , 
charindex(' ' ,customer_name) as position_spacee,
SUBSTRING(customer_name,1,charindex(' ' ,customer_name)) as first_name,
SUBSTRING(customer_name,charindex(' ' ,customer_name),len(customer_name)) as last_name
from orders

------------------------*CASE AND CTE*
--19-write a query to print below output from orders data. example output
--hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
--category , Technology, ,
--category, Furniture, ,
--category, Office Supplies, ,
--sub_category, Art , ,
--sub_category, Furnishings, ,
----and so on all the category ,subcategory and ship_mode hierarchies

select category,sub_category,ship_mode,
round(sum(case when region='east' then sales end),2) as east_sales,
round(sum(case when region='west' then sales end),2) as west_sales
from orders
group by category,sub_category,ship_mode
order by category,sub_category,ship_mode

--20- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.
with no_of_orders_each_customer as (
select customer_id,count(distinct order_id) as no_of_orders
from orders 
group by customer_id)
select * from 
no_of_orders_each_customer where no_of_orders > (select avg(no_of_orders) from no_of_orders_each_customer)

--21- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
				
with product_quantity as (
select category,product_id,sum(quantity) as total_quantity
from orders 
group by category,product_id)
,cat_max_quantity as (
select category,max(total_quantity) as max_quantity from product_quantity 
group by category
)
select *
from product_quantity pq
inner join cat_max_quantity cmq on pq.category=cmq.category
where pq.total_quantity  = cmq.max_quantity

------------------------*WINDOW FUNCTIONS*
--22- write a query to find top 3 and bottom 3 products by sales in each region.

with region_sales as (
select region,product_id,sum(sales) as sales
from orders
group by region,product_id
)
,rnk as (
select *
, rank() over(partition by region order by sales desc) as drn
, rank() over(partition by region order by sales asc) as arn
from region_sales
) 
select region,product_id,sales,case when drn <=3 then 'Top 3' else 'Bottom 3' end as top_bottom
from rnk
where drn <=3 or arn<=3

--23- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.

with sbc_sales as (
select sub_category,format(order_date,'yyyyMM') as year_month, sum(sales) as sales
from orders
group by sub_category,format(order_date,'yyyyMM')
)
, prev_month_sales as (
select *,lag(sales) over(partition by sub_category order by year_month) as prev_sales
from sbc_sales)
select  top 1 * , (sales-prev_sales)/prev_sales as mom_growth
from prev_month_sales
where year_month='202001'
order by mom_growth desc

--24- write a query to print top 3 products in each category by year over year sales growth in year 2020.

with cat_sales as (--furniture - chair-2021-2k
select category,product_id,datepart(year,order_date) as order_year, sum(sales) as sales
from orders
group by category,product_id,datepart(year,order_date)
)
, prev_year_sales as (
select *,lag(sales) over(partition by category order by order_year) as prev_year_sales
from cat_sales) 
,rnk as (
select   * ,rank() over(partition by category order by (sales-prev_year_sales)/prev_year_sales desc) as rn
from prev_year_sales
where order_year='2020'
)
select * from rnk where rn<=3

------------------------*AGGREGATION with WINDOW FUNCTIONS*
--25- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

with xxx as (select category,product_id,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by category,product_id,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,sum(sales) over(partition by category,product_id order by yo,mo rows between 2 preceding and current row ) as roll3_sales
from xxx)
select * from (
select *,rank() over(partition by category order by roll3_sales desc) as rn from yyyy 
where yo=2020 and mo=1) A
where rn<=3

--26- write a query to find products for which month over month sales has never declined.

with xxx as (select product_id,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by product_id,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,lag(sales,1,0) over(partition by product_id order by yo,mo) as prev_sales
from xxx)
select distinct product_id from yyyy where product_id not in
(select product_id from yyyy where sales<prev_sales group by product_id)

--27- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.

with xxx as (select category,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by category,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,sum(sales) over(partition by category order by yo,mo rows between 2 preceding and 1 preceding ) as prev2_sales
from xxx)
select * from yyyy where  sales>prev2_sales






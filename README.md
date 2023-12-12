Introduction
Super Store is a small retail business located in the United States. 
They sell Furniture, Office Supplies and Technology products and their customers are the mass Consumer, Corporate and Home Offices.
The data set contains sales, profit and geographical information of Super Store.
Our task is to analyse the sales data and identify weak areas and opportunities for Super Store to boost business growth.

Business Questions

1- write a query to get total profit, first order date and latest order date for each category.
	->Technolgy has highest profit.

2- write a query to find total number of products in each category.
	-> Office Supplies has highest number of products with 1083 followed by Technology and Furniture.

3- write a query to find top 5 sub categories in west region by total quantity sold
	->Binders, Paper, Furnishings, Phones, Storage
	->Office Supplies sales is large in west region

4- write a query to find total sales for each region and ship mode combination for orders in year 2020
	-> Highest sale ( East Standard Class 120927.031 )

5- write a query to get region wise count of return orders.
	->Maximum number of returned orders are from West region followed by East, Central and South.
	->South region is performing well whereas there needs improvemnet in West region. 

6- write a query to get category wise sales of orders that were not returned.
	-> Technology category has highest sale with 763445.93.

7- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items).
	-> Office Supllies has most number of returned orders. Lowest products are Binders and Papers.

8- write a query to find cities where not even a single order was returned.
	->413 cities have not returned even a single product.

9- write a query to find top 3 subcategories by sales of returned orders in east region
	->Phones, Chairs, Machines

10- write a query to find subcategories who never had any return orders in the month of november (irrespective of years).
	->Copiers

11- write a query to find order ids where there is only 1 product bought by the customer.

12- write a query to get number of business days between order_date and ship_date (exclude weekends). Assume that all order date and ship date are on weekdays only
	->Average business day is 2

13- write a query to get number of business days between order_date and ship_date (including weekends).
14- write a query to print 3 columns : category, total_sales and (total sales of returned orders).
15- write a query to print below 3 columns(category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020))
	->sales has increased for all three categories in 2019

16- write a query print top 5 cities in west region by average no of days between order date and ship date.
	->Citrus Heights	7

17- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name).
	->(Technology	Phones	Standard Class)	has highest sales in both east and west region

18- write a query to print below output from orders data. example output(hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region)
19- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.
	->Emily Phan has done most no. of order (17)

20- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
	->Technology	TEC-AC-10003832	75
          Office Supplies  OFF-PA-1000197070
          Furniture	FUR-CH-1000264764

21- write a query to find top 3 and bottom 3 products by sales in each region.

22- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.
	->Bookcases

23- write a query to print top 3 products in each category by year over year sales growth in year 2020.
24- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.
25- write a query to find products for which month over month sales has never declined.
26- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.

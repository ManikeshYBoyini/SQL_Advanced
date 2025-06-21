use market_star_schema_advanced;

/*--------------------------------------------------------
Profits per product category
Profits per product subcategory
Average profit per order
Average profit percentage per order
----------------------------------------------------------*/

-- Profits per product category
SELECT p.Product_Category
	,sum(m.Profit) AS Profits
FROM market_fact_full m
JOIN prod_dimen p ON m.Prod_id = p.Prod_id
GROUP BY p.Product_Category
ORDER BY profits;

-- Profits per product subcategory

SELECT p.Product_Category
	,p.Product_Sub_Category
	,sum(m.Profit) AS Profits
FROM market_fact_full m
JOIN prod_dimen p ON m.Prod_id = p.Prod_id
GROUP BY p.Product_Category
	,p.Product_Sub_Category
ORDER BY profits;


-- exploring orders dimen table
-- trying to check if ord_id and order_number have one to one mapping 
SELECT ord_id
	,order_number
FROM orders_dimen
GROUP BY ord_id
	,order_number
ORDER BY ord_id
	,order_number;
    
-- checking if the count of ord_id and order_number is same
SELECT count(*) AS total_count
	,count(Ord_id) AS ord_id_count
	,count(Order_Number) AS order_number_count
FROM orders_dimen;

-- check if there are two or more order numbers for single ord_id

select Order_Number,count(Ord_id) as count_order_number from orders_dimen
group by ord_id 
having count_order_number>1;


-- Average profit per order

SELECT p.Product_Category
	,sum(m.Profit) AS profits
	,Round(sum(m.Profit) / count(DISTINCT o.Order_Number), 2) AS average_profits_per_order
FROM market_fact_full m
JOIN prod_dimen p ON m.Prod_id = p.Prod_id
JOIN orders_dimen o ON o.ord_id = m.ord_id
group by p.Product_Category;


-- Average profit percentage per order
SELECT p.Product_Category
	,sum(m.Profit) AS profits
    ,count(DISTINCT o.Order_Number) total_orders
	,Round(sum(m.Profit) / count(DISTINCT o.Order_Number), 2) AS average_profits_per_order
    ,round( sum(m.profit)/sum(m.sales),2) as profits_percentage
FROM market_fact_full m
JOIN prod_dimen p ON m.Prod_id = p.Prod_id
JOIN orders_dimen o ON o.ord_id = m.ord_id
group by p.Product_Category;


-- Profitable Customers - II
WITH cust_summary
AS (
	SELECT c.cust_id
		,rank() OVER (
			ORDER BY sum(m.profit) desc
			) AS cust_profit_rank
		,c.Customer_Name
		,round(sum(m.profit), 2) AS profit
		,c.city AS customer_city
		,c.STATE AS customer_state
		,round(sum(m.sales), 2) AS Sales
	FROM market_fact_full m
	JOIN cust_dimen c ON c.cust_id = m.cust_id
	GROUP BY c.cust_id
	)
SELECT *
FROM cust_summary 
    where cust_profit_rank<11;
    
    
-- Customers Without Orders - II

SELECT c.* FROM cust_dimen c left join market_fact_full m on c.cust_id = m.cust_id 
where market_fact_id is null;

-- check the count of cust in both tables

select count(cust_id) from cust_dimen;
select count(distinct cust_id) from market_fact_full;


-- get customers who have more than one order 

SELECT c.* , count(distinct ord_id) as order_count
from cust_dimen c 
left join market_fact_full m 
on c.cust_id = m.cust_id
group by c.cust_id
having count(distinct ord_id)<>1;

-- get customers with same name and city but with different cust ids (fraud detection)

select customer_name, city, count(cust_id)
 from cust_dimen
 group by customer_name, city
 having count(cust_id)>1;
 
 
 WITH cust_details
AS (
	SELECT c.*
		,count(DISTINCT ord_id) AS order_count
	FROM cust_dimen c
	LEFT JOIN market_fact_full m ON c.cust_id = m.cust_id
	GROUP BY c.cust_id
	HAVING count(DISTINCT ord_id) <> 1
	)
	,fraud_cust_list
AS (
	SELECT customer_name
		,city
		,count(cust_id) AS cust_id_count
	FROM cust_dimen
	GROUP BY customer_name
		,city
	HAVING count(cust_id) > 1
	)
SELECT c.*
	,CASE WHEN fc.cust_id_count IS NOT NULL then 'FRAUD' ELSE 'NORMAL' END AS fraud_flag FROM cust_details c LEFT JOIN fraud_cust_list AS fc ON c.customer_name = fc.customer_name
		AND c.city = fc.city;
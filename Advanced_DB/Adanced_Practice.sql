use market_star_schema_advanced;


select c.customer_name, ord_id, round(sales) as sales_value,
	rank() over (order by  sales desc) as sales_rank
 from market_fact_full m 
join cust_dimen c on m.cust_id = c.cust_id
where c.customer_name ='RICK WILSON' ;

-- example of rank 
with sales_customerName as (select c.customer_name, ord_id, round(sales) as sales_value,
	rank() over (order by  sales desc) as sales_rank
 from market_fact_full m 
join cust_dimen c on m.cust_id = c.cust_id
where c.customer_name ='RICK WILSON'
)

select * from  sales_customerName where sales_rank <=10;

-- comparision between rank and dense rank

select customer_name,discount,
rank() over (order by discount) as disc_rank,
dense_rank() over(order by discount) as disc_dense_rank
 from market_fact_full m
join cust_dimen c 
on c.cust_id = m.cust_id
where c.customer_name ='RICK WILSON'
;

-- row_number example  count the number of unique orders for each customer

select c.customer_name,count(distinct ord_id) as order_count,
	rank() over (order by count(distinct ord_id) desc) as count_rank,
    dense_rank() over (order by count(distinct ord_id) desc) as count_dense_rank,
    row_number() over(order by count(distinct ord_id) desc) as row_numb
from market_fact_full m
join cust_dimen c on 
m.cust_id = c.cust_id
group by c.customer_name;

-- partition by example
select ship_mode, month(ship_date) as month_ship_date,count(order_id) order_count,
 rank() over(partition by ship_mode order by count(order_id) desc),
 dense_rank() over(partition by ship_mode order by count(order_id) desc)
from shipping_dimen
group by ship_mode, month_ship_date;


-- named window function examples
select customer_name,discount,
rank() over w as disc_rank,
dense_rank() over w as disc_dense_rank,
row_number() over w as disc_row_num_rank
 from market_fact_full m
join cust_dimen c 
on c.cust_id = m.cust_id
where c.customer_name ='RICK WILSON'
WINDOW w as (partition by customer_name order by discount desc)
;

-- named window function without where condition
select customer_name,discount,
rank() over w as disc_rank,
dense_rank() over w as disc_dense_rank,
row_number() over w as disc_row_num_rank
 from market_fact_full m
join cust_dimen c 
on c.cust_id = m.cust_id
WINDOW w as (partition by customer_name order by discount desc)
;

-- frames examples
with daily_shipping_summary as (
SELECT ship_date, 
		sum(shipping_cost) daily_total
from market_fact_full m
join shipping_dimen s 
on m.ship_id = s.ship_id
group by ship_date)

SELECT *,
		sum(daily_total) over w1 as running_total,
        avg(daily_total) over w2 as running_average
FROM daily_shipping_summary
WINDOW w1 AS (ORDER BY ship_date ROWS unbounded preceding),
		w2 as (ORDER BY ship_date ROWS 6 preceding);
        
        
-- lead function example
WITH cust_order as (
SELECT c.cust_id, c.customer_name,
		o.ord_id,
		o.order_date
        
FROM market_fact_full m
join orders_dimen o 
on m.ord_id = o.ord_id
join cust_dimen c
on m.cust_id=c.cust_id
where customer_name ='RICK WILSON'
group by c.cust_id, c.customer_name,
		o.ord_id,
		o.order_date),
next_order_summary as (
SELECT *,
		LEAD(order_date,1,'2015-01-01') over w1 as next_order_Date
FROM cust_order
WINDOW w1 as (ORDER BY order_date)
)

select *, datediff(next_order_date,order_date) as date_difference from next_order_summary;


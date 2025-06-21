use world;

select * from city;	

# find count of cities in each country
# grouping the data by country code
# count the rows in each group

# group by 
select CountryCode, count(name) as citycount from city
group by CountryCode ;

select CountryCode, count(name) as citycount from city
group by CountryCode order by citycount desc;

# remove  all countrycodes where citycount <250

select CountryCode, count(name) as citycount from city
group by CountryCode having count(name)>250 order by citycount desc;

# diff between having and where
# where is used to filter columns
# having is used to filter aggregated columns

# subquery

# find most populated city from USA 
select * from city where Population=
(
select max(Population) from city where CountryCode = 'USA'
);

#8008278

select * from city where Population = 8008278;

select * from countrylanguage;

# find name of country where hindi is spoken
select Name from country where code
in
(
select countrycode from countrylanguage where language = 'hindi'
);

# if subquery returns single value then use =
# if subquery returns multiple value then use in opertor

# creating tables for joins
# create a new table 
CREATE TABLE customers1 (customer_id INT, firstname VARCHAR(50));

# insert enties in table
INSERT INTO customers1 values(1,'john');
INSERT INTO customers1 values(2,'robert');
INSERT INTO customers1 values(3,'david');
INSERT INTO customers1 values(4,'john');
INSERT INTO customers1 values(5,'betty');

CREATE TABLE orders1 (order_id INT,amount INT, customer INT);

# insert enties in table
INSERT INTO orders1 values(1,200,10);
INSERT INTO orders1 values(2,500,3);
INSERT INTO orders1 values(3,300,6);
INSERT INTO orders1 values(4,800,5);
INSERT INTO orders1 values(5,150,8);
INSERT INTO orders1 values(6,150,9);
INSERT INTO orders1 values(7,300,11);
# inner join
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
inner join orders1
on customers1.customer_id = orders1.customer;

# left join
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
left join orders1
on customers1.customer_id = orders1.customer;

# right join
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
right join orders1
on customers1.customer_id = orders1.customer;

#full outer join
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
left join orders1
on customers1.customer_id = orders1.customer
union all
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
right join orders1
on customers1.customer_id = orders1.customer;


select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
left join orders1
on customers1.customer_id = orders1.customer
union 
select customers1.customer_id,customers1.firstname, orders1.amount
from customers1
right join orders1
on customers1.customer_id = orders1.customer;

select * from orders1;
# rownumber()
select *,row_number() over(order by amount desc) as ranking from orders1;

# rank()
select *,rank() over(order by amount desc) as ranking from orders1;

#dense_ranking
select *,dense_rank() over(order by amount desc) as ranking from orders1;


# view
select * from city where CountryCode = 'IND';

# lets assume i am from maharashtra looking for data of my state

create view mah_cities 
as 
select Name,District from city where District = 'Maharashtra';

select * from mah_cities; # i am going to give it to client
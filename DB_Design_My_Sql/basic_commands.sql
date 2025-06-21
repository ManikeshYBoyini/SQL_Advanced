# create a new table 
CREATE TABLE employee (firstname VARCHAR(50),lastname VARCHAR(50), age INT);

# insert enties in table
INSERT INTO employee values('tom','smith',21);
INSERT INTO employee values('jack','stalon',23);
INSERT INTO employee values('suresh','jain',25);
INSERT INTO employee values('ramesh','patil',36);
INSERT INTO employee values('sayli','shah',20);
INSERT INTO employee values('jay','shah',20);

# check created table (* = all records)
SELECT * FROM employee;

# select single column
SELECT firstname,age from employee;

# delete certain row
delete from employee where age = 23;

# rename table
rename table employee to emp1; 

# truncate table (except schema all entries are getting deleted
truncate emp1;
select * from emp1;

# modify the table
alter table emp1 add weight float;

# drop table
drop table emp1;

--------------------------------------------------------------------

select * from employee;

# aliases 
select firstname as fname from employee;
select lastname as surname, age from employee;

# stats from data
select avg(age) from employee;
select count(firstname) from employee;
select sum(age) from employee;
select sum(age) as total_age from employee;
select max(age) from employee;
select min(age) from employee;

# distinct
select distinct age from employee;
select * from employee;
# filter data based on single condition
select * from employee where age = 20;

# filter data based on multiple condition
# AND , OR
select firstname,lastname from employee where age>22 and age<30;
select age from employee where age>25 or age<26;












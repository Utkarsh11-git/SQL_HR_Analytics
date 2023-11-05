create database hr;
use hr;
-- 1. Display all the records in both the tables
select * from eda_hr;
select * from location;

-- 2. Display any 5 random records
select * from eda_hr order by rand() limit 5;

-- 3. Rename the ID column
alter table eda_hr change column ï»¿id id varchar(10);

-- 4. Find the no of occurrences of each state
select location_state, count(location_state) from eda_hr group by location_state;

-- 5. Find the branch with the top 5 highest average salaries across all departments.
select department,avg(salary) as avg_salary from eda_hr group by department order by avg_salary desc limit 5;

-- 6. Find the sum of all salaries across all departments and locations
select department,location,sum(salary) as total_salary from eda_hr group by department, location 
order by department, location;

-- 7. Display the first name, last name, age, gender of the youngest employee
select first_name,last_name,year(curdate())-year(str_to_date(birthdate,'%m/%d/%Y')) as Age, gender from eda_hr order by Age limit 1;

-- 8. What is the racial breakdown of employees in percentage in the company?
select race,concat(round((count(race)/(select count(race) from eda_hr))*100,2),'%') as percentage from eda_hr group by race;

-- 9. What is the age distribution of employees in the company?

-- Create a new column to calculate Age
alter table eda_hr add column Age float;

-- Calculate the age for each employee
update eda_hr set Age=
year(curdate())-year(str_to_date(birthdate,'%m/%d/%Y'));
-- Distribution using case
select case
when Age>20 and Age<30 then '20-30'
when Age>=30 and Age<40 then '30-40'
when Age>=40 and Age<50 then '40-50'
when Age>=50 then '50+' end as Age_Group, count(*) as count
from eda_hr group by Age_Group order by Age_Group;

-- 10. Write a query to display the last name and the first name separated by a comma
select concat(last_name,', ',first_name) as Full_Name from eda_hr;

-- 11. Find the top 5 employee with the longest tenure
Select first_name,last_name,gender,department,jobtitle,location,hire_date,salary,location_city,location_state, round(datediff(curdate(),str_to_date(hire_date,'%m/%d/%Y'))/365,1) as Tenure from eda_hr order by Tenure desc limit 5;

-- 12. Write a query to display records with first name beginning with 'A'
select * from eda_hr where first_name like 'A%';

-- 13. Find the average no of employees across all states
select location_state, round(avg(Age),2) from eda_hr group by location_state;

-- 14. Find employees whose first name is exactly 5 characters
select * from eda_hr where first_name like '_____';

-- 15. Write a query to get the first 3 characters of the last name
select substring(last_name,1,3) from eda_hr;

-- 16. Write a query to return the month and the count of employees hired
select month(str_to_date(hire_date,'%m/%d/%Y')) as month,count(*) as count from eda_hr 
group by month order by month;

-- 17. Find the no of employees hired in the 1st half of the year with the 2nd.
select SUM(IF(MONTH(str_to_date(hire_date,'%m/%d/%Y')) BETWEEN 1 AND 6, 1, 0))/
(select count(*) from eda_hr) * 100 as 1st_half,
SUM(IF(MONTH(str_to_date(hire_date,'%m/%d/%Y')) BETWEEN 7 AND 12, 1, 0))/
(select count(*) from eda_hr) * 100 as 2nd_half
from eda_hr;

-- 18. Select maximum salary for each department
select department,max(salary) as maximum_salary from eda_hr group by department order by
max(salary);

-- 19. Distribution of job titles
select jobtitle,count(*) as count from eda_hr group by jobtitle order by count(*) desc;

-- 20. Find the first name, department, and job title of employees whose salary is greater than the average salary of employees in the same department.
select e1.first_name,e1.last_name,e1.department,e1.jobtitle,e1.salary from eda_hr as e1 inner join
(select department,avg(salary) as avg_salary from eda_hr group by department) as e2
on e1.department=e2.department where e1.salary>e2.avg_salary;

-- 21. Write a query to display the details of the employees who work in the capital city of their respective states

-- Rename the capital_city column to correct the spelling
alter table location rename column captial_city to capital_city;

select e1.first_name,e1.last_name,l1.capital_city,e1.location_state,e1.salary from eda_hr as e1 inner join location as l1 on e1.location_city=l1.capital_city;

-- 22. Write a query to display the details of those who work in multiple zones
alter table location rename column `ï»¿location_state`to location_state;
select l1.time_zone,count(e.id) as Count from eda_hr as e inner join
(select capital_city,time_zone from location where time_zone like '%,%')
as l1 on e.location_city=l1.capital_city group by l1.time_zone;

-- 23. Write a query to display the states with average salaries that are higher than the average salaries across all states.
select avg(salary),location_state from eda_hr 
group by location_state having avg(salary)>(select avg(salary) from eda_hr);

-- 24. Write a query to rank departments and their average salaries in descending order.
select department,avg(salary) as average_salary,
rank() over (order by avg(salary) desc) as department_rank from eda_hr group by department;

-- 25. Write a query to calculate the average age of employees within each location city and display the location city along with its corresponding average age.
select location_city,avg(age) from eda_hr group by location_city
order by location_city;
-- USING WINDOWS FUNCTION
select distinct location_city,avg(age) over (partition by location_city)
as avg_age from eda_hr;

-- 26 Find the 2nd highest salary
select distinct salary from eda_hr order by salary desc limit 1,1;

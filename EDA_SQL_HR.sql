CREATE database hr;
USE hr;
-- 1. Display all the records in both the tables
SELECT * FROM eda_hr;
SELECT * FROM location;

-- 2. Display any 5 random records
SELECT * FROM eda_hr ORDER BY rand() LIMIT 5;

-- 3. Rename the ID column
ALTER table eda_hr change column ï»¿id id varchar(10);

-- 4. Find the no of occurrences of each state
SELECT location_state, COUNT(location_state) FROM eda_hr GROUP BY location_state;

-- 5. Find the branch WITH the top 5 highest average salaries across all departments.
SELECT department,avg(salary) as avg_salary FROM eda_hr GROUP BY department ORDER BY avg_salary DESC LIMIT 5;

-- 6. Find the sum of all salaries across all departments and locations
SELECT department,location,sum(salary) as total_salary FROM eda_hr GROUP BY department, location 
ORDER BY department, location;

-- 7. Display the first name, last name, age, gender of the youngest employee
SELECT first_name,last_name,year(curdate())-year(str_to_date(birthdate,'%m/%d/%Y')) as Age, gender FROM eda_hr ORDER BY Age LIMIT 1;

-- 8. What is the racial breakdown of employees in percentage in the company?
SELECT race,concat(round((COUNT(race)/(SELECT COUNT(race) FROM eda_hr))*100,2),'%') as percentage FROM eda_hr GROUP BY race;

-- 9. What is the age distribution of employees in the company?

-- Create a new column to calculate Age
ALTER table eda_hr ADD COLUMN Age float;

-- Calculate the age for each employee
UPDATE eda_hr SET Age=
YEAR(curdate())-YEAR(str_to_date(birthdate,'%m/%d/%Y'));
-- Distribution using case
SELECT CASE
WHEN Age>20 and Age<30 THEN '20-30'
WHEN Age>=30 and Age<40 THEN '30-40'
WHEN Age>=40 and Age<50 THEN '40-50'
WHEN Age>=50 THEN '50+' end as Age_Group, COUNT(*) as COUNT
FROM eda_hr GROUP BY Age_Group ORDER BY Age_Group;

-- 10. Write a query to display the last name and the first name separated by a comma
SELECT concat(last_name,', ',first_name) as Full_Name FROM eda_hr;

-- 11. Find the top 5 employee WITH the longest tenure
SELECT first_name,last_name,gender,department,jobtitle,location,hire_date,salary,location_city,location_state, round(datediff(curdate(),str_to_date(hire_date,'%m/%d/%Y'))/365,1) as Tenure FROM eda_hr ORDER BY Tenure DESC LIMIT 5;

-- 12. Write a query to display records WITH first name beginning WITH 'A'
SELECT * FROM eda_hr WHERE first_name like 'A%';

-- 13. Find the average no of employees across all states
SELECT location_state, round(avg(Age),2) FROM eda_hr GROUP BY location_state;

-- 14. Find employees whose first name is exactly 5 characters
SELECT * FROM eda_hr WHERE first_name like '_____';

-- 15. Write a query to get the first 3 characters of the last name
SELECT substring(last_name,1,3) FROM eda_hr;

-- 16. Write a query to return the month and the COUNT of employees hired
SELECT month(str_to_date(hire_date,'%m/%d/%Y')) as month,COUNT(*) as COUNT FROM eda_hr 
GROUP BY month ORDER BY month;

-- 17. Find the no of employees hired in the 1st half of the year WITH the 2nd.
SELECT SUM(IF(MONTH(str_to_date(hire_date,'%m/%d/%Y')) BETWEEN 1 AND 6, 1, 0))/
(SELECT COUNT(*) FROM eda_hr) * 100 as 1st_half,
SUM(IF(MONTH(str_to_date(hire_date,'%m/%d/%Y')) BETWEEN 7 AND 12, 1, 0))/
(SELECT COUNT(*) FROM eda_hr) * 100 as 2nd_half
FROM eda_hr;

-- 18. SELECT maximum salary for each department
SELECT department,max(salary) as maximum_salary FROM eda_hr GROUP BY department ORDER BY
max(salary);

-- 19. Distribution of job titles
SELECT jobtitle,COUNT(*) as COUNT FROM eda_hr GROUP BY jobtitle ORDER BY COUNT(*) DESC;

-- 20. Find the first name, department, and job title of employees whose salary is greater than the average salary of employees in the same department.
SELECT e1.first_name,e1.last_name,e1.department,e1.jobtitle,e1.salary FROM eda_hr as e1 INNER JOIN
(SELECT department,avg(salary) as avg_salary FROM eda_hr GROUP BY department) as e2
on e1.department=e2.department WHERE e1.salary>e2.avg_salary;

-- 21. Write a query to display the details of the employees who work in the capital city of their respective states

-- Rename the capital_city column to correct the spelling
ALTER table location rename column captial_city to capital_city;

SELECT e1.first_name,e1.last_name,l1.capital_city,e1.location_state,e1.salary FROM eda_hr as e1 INNER JOIN location as l1 on e1.location_city=l1.capital_city;

-- 22. Write a query to display the details of those who work in multiple zones
ALTER table location rename column `ï»¿location_state`to location_state;
SELECT l1.time_zone,COUNT(e.id) as COUNT FROM eda_hr as e INNER JOIN
(SELECT capital_city,time_zone FROM location WHERE time_zone like '%,%')
as l1 on e.location_city=l1.capital_city GROUP BY l1.time_zone;

-- 23. Write a query to display the states WITH average salaries that are higher than the average salaries across all states.
SELECT avg(salary),location_state FROM eda_hr 
GROUP BY location_state having avg(salary)>(SELECT avg(salary) FROM eda_hr);

-- 24. Write a query to rank departments and their average salaries in DESCending order.
SELECT department,avg(salary) as average_salary,
dense_rank() OVER (ORDER BY avg(salary) DESC) as department_rank FROM eda_hr GROUP BY department;

-- 25. Write a query to calculate the average age of employees WITHin each location city and display the location city along WITH its corresponding average age.
SELECT location_city,avg(age) FROM eda_hr GROUP BY location_city
ORDER BY location_city;
-- USING WINDOWS FUNCTION
SELECT DISTINCT location_city,avg(age) OVER (partition by location_city)
as avg_age FROM eda_hr;

-- 26 Find the 2nd highest salary
SELECT DISTINCT salary FROM eda_hr ORDER BY salary DESC LIMIT 1,1;

-- 27 Employee WITH the second highest salary department-wise
WITH CTE as
(SELECT first_name,salary,department,dense_rank() OVER(PARTITION BY department ORDER BY salary) as rnk FROM eda_hr)
SELECT * FROM CTE WHERE rnk=2;

-- 28. Common Table Expression (CTE) to calculate gender diversity index
WITH GenderDiversity AS (
    SELECT
        COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male_COUNT,
        COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_COUNT
    FROM eda_hr)
-- Main Query
SELECT
    male_COUNT,
    female_COUNT,
	male_COUNT / (male_COUNT + female_COUNT) AS gender_diversity_index
FROM
    GenderDiversity;

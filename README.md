# Analysis of a HR Database using SQL
The project's goal is to use SQL queries to examine employee data and obtain insights into various areas of the workforce. By leveraging the dataset, the project will address questions related to employee demographics, job roles, salary distribution, and employee tenure. The analysis will provide valuable information to HR and management for workforce planning and decision-making.

### Problem Statement
The HR department want to use SQL to understand different analytical requirements, starting with fundamental data exploration, ensuring data accuracy by altering column types, and finding key metrics such as average salaries across branches, tenure distribution, racial representation, age demographics, and employee recruitment trends. These insights will be fundamental in making informed decisions and designing efficient HR strategies.

### Skills Applied
- Aggregations
- JOINs
- Window Functions
- Data Manipulation
- Data Analysis

### Interesting Queries
-- 7. Display the first name, last name, age, gender of the youngest employee
```sql
SELECT first_name,last_name,year(curdate())-year(str_to_date(birthdate,'%m/%d/%Y')) as Age, gender
FROM eda_hr ORDER BY Age LIMIT 1;
```
-- 9. What is the age distribution of employees in the company?

```sql
UPDATE eda_hr SET Age=
year(curdate())-year(str_to_date(birthdate,'%m/%d/%Y'));
-- Distribution using case
SELECT CASE
when Age>20 and Age<30 then '20-30'
when Age>=30 and Age<40 then '30-40'
when Age>=40 and Age<50 then '40-50'
when Age>=50 then '50+' end as Age_Group, count(*) as count
FROM eda_hr GROUP BY Age_Group ORDER BY Age_Group;
```
-- 11. Find the top 5 employee with the longest tenure
```sql
SELCT first_name,last_name,gender,department,jobtitle,location,hire_date,salary,location_city,location_state,
round(datediff(curdate(),str_to_date(hire_date,'%m/%d/%Y'))/365,1) as Tenure from eda_hr
ORDER BY Tenure DESC LIMIT 5;
```

### Tools and Technologies:
* SQL (Structured Query Language) for data querying and analysis.
* Database management system (MySQL, PostgreSQL) to store and query the dataset.

### Deliverables:
* SQL queries and scripts used for data analysis.
* SQL queries that answer specific HR-related questions.

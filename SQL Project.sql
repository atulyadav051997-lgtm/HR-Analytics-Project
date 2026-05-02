# HR Analytics Project

#1	Total Employee, Active Employees, Attrition Count, Attrition Rate, Average Working Years, Max salary, Min salary, Average Salary, Average Hourly Rate, Average Age (All KPI Cards)

select count(employeeNumber) as Total_Employee, 
sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) as Attrition_count,
count(employeeNumber)- sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) as Active_Employee, 
concat(round(sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)/count(employeeNumber) * 100, 2), '%') as Attrition_Rate,
max(hr2.monthlyIncome) as Max_Salary,
min(hr2.monthlyIncome) as Min_Salary,
round(avg(hr2.monthlyIncome),2) as Average_Salary,
avg(hourlyRate) as Average_HourlyRate,
round(avg(yearsatcompany), 2) as Average_WorkingYears,
round(avg(age), 2) as Average_Age,
(select SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1 where gender = "Female") as "FemaleAttritionCount",
(select SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1 where gender = "Male") as "MaleAttritionCount"
from hr1 inner join hr2
on hr1.employeeNumber= hr2.`employee ID`;


#2 Department wise Attrition count of Employees
SELECT department,
       SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) AS AttritionCount,
       COUNT(*) AS TotalEmployees,
       CONCAT(ROUND((SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)  / COUNT(*)) * 100, 2),'%') AS AttritionRate,
       concat(round(SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)/(select SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1) * 100,2) ,'%') as dept_wise_attrition 
FROM hr1
GROUP BY department
ORDER BY dept_wise_attrition desc;


#3	Attrition rate vs average monthly income
select hr1.department, 
round(avg(hr2.monthlyincome),2) as average_monthly_income, 
concat(round((sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)/(select sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1))*100,2), '%') as Attrition_rate
from hr2 inner join hr1 
on hr1.employeeNumber = hr2.`employee ID` group by hr1.department order by average_monthly_income asc;


#4 Departments with Avg. Performance Rating and Attrition Count
SELECT 
    A.Department,
    ROUND(AVG(B.PerformanceRating), 3) AS Avg_Performance_Rating,
    SUM(CASE
        WHEN attrition = 'yes' THEN 1
        ELSE 0
    END) AS Attrition_Count
from 
`hr1` as A
inner join
`hr2` as B
on A.EmployeeNumber = B.`Employee ID`
group by Department
order by Avg_Performance_Rating desc;


#5	avg monthly income and percentage salary hike by education field 
select hr1.educationfield, 
round(avg(hr2.monthlyincome), 2) as average_monthly_income ,  concat(round(sum(hr2.percentsalaryhike)/(select sum(percentsalaryhike) from hr2) * 100, 2), '%') as percent_salary_hike
 from hr1 inner join hr2  
on hr1.employeeNumber = hr2.`employee ID` group by educationfield
order by average_monthly_income desc;


#6	Gender Wise Average Hourly Rate of Total Employees of Different Job Role
SELECT   jobrole,
round(avg(CASE WHEN gender = 'Female' THEN hourlyrate END), 2) AS avg_hourly_rate_female,
round(avg(CASE WHEN gender = 'Male' THEN hourlyrate END), 2) AS avg_hourly_rate_male
FROM hr1 
GROUP BY jobrole
ORDER BY avg_hourly_rate_female desc;


#7 Attrition by Age Group & Marital Status
select distinct MaritalStatus,  
case
	when Age>40 then '41-60'
	when Age>30 then '31-40'
	else '18-30'
end as Age_of_Emp, count(EmployeeNumber) as AttritionCount from `hr1` where attrition = 'Yes' 
group by MaritalStatus, Age_of_Emp
order by AttritionCount desc;

#8 No. of Employees promoted within initial 10 years vs. attrition rate in various departments
select A.Department as Total_Department, 
case 
when yearssincelastpromotion between 0 and 10 then '0-10'
when yearssincelastpromotion between 11 and 20 then '11-20'
when yearssincelastpromotion between 21 and 30 then '21-30'
else '31-40'
end as Years_Since_Last_Promotion, count(B.`Employee ID`) as Attrition_Count
from 
`hr1` as A
inner join
`hr2` as B
on A.EmployeeNumber = B.`Employee ID` where attrition = 'yes'
Group by Department,Years_Since_Last_Promotion
having Years_Since_Last_Promotion = '0-10'
order by Attrition_Count desc;


#9 Department wise Overtime and Attrition:
select department, 
count(case when overtime = "Yes" then employeeNumber end) as overtime_Yes,
count(case when overtime = "No" then employeeNumber end) as overtime_No,
sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) as Attrition_Count
from hr1 inner join hr2
on hr1.employeeNumber= hr2.`employee ID`
group by department ;


#10 Attrition by Distance
select
case 
when DistanceFromHome <= 15 then 'Near'
when DistanceFromHome <= 25 then 'Far'
else 'Very Far' 
end as Distance, 
count(employeeNumber) as Attrition_Count,
concat(round((sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)/(select sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1) * 100),2),'%') as attrition_rate
from hr1 where attrition = 'yes' group by Distance
order by attrition_count desc;


#11	Business travel wise attrition count and attrition rate
select businesstravel, 
sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) as AttritionCount, 
concat(round((sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END)/(select sum(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) from hr1) * 100),2), '%') 
as attrition_rate 
from hr1 group by businesstravel
order by attrition_rate desc;


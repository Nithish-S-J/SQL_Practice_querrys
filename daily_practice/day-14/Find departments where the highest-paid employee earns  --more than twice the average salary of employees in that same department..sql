--Find departments where the highest-paid employee earns 
--more than twice the average salary of employees in that same department.

with cte1 as
(
select department,
       avg(salary) as avgsalary,
       max(salary) as maxsalary
from employees
group by department
)
select * 
       from cte1
       where maxsalary <2* avgsalary


----Imagine you're an HR analyst at a tech company tasked with analyzing employee salaries. Your manager is keen on understanding the pay distribution 
---and asks you to determine the second highest salary among all employees.

-------It's possible that multiple employees may share the same second highest salary. In case of duplicate, display the salary only once.


select max(salary) as secondhighestsalary
from employee
where salary < (select max(salary)
from employee)

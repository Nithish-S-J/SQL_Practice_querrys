--As a HR Analyst, you're asked to identify all employees who earn more than their direct managers. 
--The result should include the employee's ID and name.


SELECT emp.employee_id,
       emp.name as employee_name
FROM employee as emp
  inner join 
   employee as Mng 
   on 
   emp.manager_id = mng.employee_id
   where emp.salary > mng.salary 

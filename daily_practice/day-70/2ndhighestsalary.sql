WITH cte1 AS
(
    SELECT
        employeeid,
        
        salary,
        DENSE_RANK() OVER(
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)

SELECT
    employeeid,
    
    salary
FROM cte1
WHERE salary_rank = 2;

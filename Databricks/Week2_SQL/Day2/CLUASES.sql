USE function_demo;

SELECT dept, AVG(salary) AS avg_salary
FROM employees
WHERE salary > 30000
GROUP BY dept
HAVING AVG(salary) > 50000
ORDER BY avg_salary DESC
LIMIT 3;
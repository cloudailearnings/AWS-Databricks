
-- =============================================
-- MySQL Functions Complete Script
-- Author: ChatGPT
-- Description: Scalar, Aggregate, Window, String,
-- Numeric, Date, Control, Conversion & NULL functions
-- Compatible: MySQL 8.0+
-- =============================================

-- Create sample database
CREATE DATABASE IF NOT EXISTS function_demo;
USE function_demo;

-- =============================================
-- Sample Table
-- =============================================
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    dept VARCHAR(20),
    salary DECIMAL(10,2),
    join_date DATE,
    bonus DECIMAL(10,2)
);

INSERT INTO employees (emp_name, dept, salary, join_date, bonus) VALUES
('Ravi', 'IT', 60000, '2022-01-10', 5000),
('Kumar', 'IT', 70000, '2021-03-15', NULL),
('Anita', 'HR', 40000, '2023-06-01', 3000),
('Sunita', 'HR', 45000, '2022-09-20', NULL),
('Raj', 'Sales', 50000, '2020-11-11', 2000);

-- =============================================
-- STRING FUNCTIONS
-- =============================================
SELECT UPPER(emp_name) AS upper_name FROM employees;
SELECT LOWER(emp_name) AS lower_name FROM employees;
SELECT LENGTH(emp_name) AS name_length FROM employees;
SELECT CONCAT(emp_name, ' - ', dept) AS emp_details FROM employees;
SELECT SUBSTRING(emp_name, 1, 3) AS short_name FROM employees;
SELECT TRIM('   MySQL   ') AS trimmed_text;

-- =============================================
-- NUMERIC FUNCTIONS
-- =============================================
SELECT ABS(-100);
SELECT ROUND(123.456, 2);
SELECT CEIL(4.2), FLOOR(4.8);
SELECT POWER(2, 3);
SELECT MOD(10, 3);

-- =============================================
-- DATE FUNCTIONS
-- =============================================
SELECT NOW();
SELECT CURRENT_DATE();
SELECT YEAR(join_date), MONTH(join_date), DAY(join_date) FROM employees;
SELECT DATEDIFF(CURRENT_DATE(), join_date) AS days_worked FROM employees;
SELECT DATE_ADD(join_date, INTERVAL 1 YEAR) AS next_year FROM employees;

-- =============================================
-- CONTROL / CONDITIONAL FUNCTIONS
-- =============================================
SELECT emp_name,
IF(salary > 50000, 'High Salary', 'Low Salary') AS salary_status
FROM employees;

SELECT emp_name,
CASE
    WHEN salary >= 70000 THEN 'Excellent'
    WHEN salary >= 50000 THEN 'Good'
    ELSE 'Average'
END AS performance
FROM employees;

-- =============================================
-- NULL HANDLING FUNCTIONS
-- =============================================
SELECT emp_name, IFNULL(bonus, 0) AS bonus_amount FROM employees;
SELECT emp_name, COALESCE(bonus, 0) AS bonus_value FROM employees;

-- =============================================
-- AGGREGATE FUNCTIONS
-- =============================================
SELECT COUNT(*) AS total_employees FROM employees;
SELECT SUM(salary) AS total_salary FROM employees;
SELECT AVG(salary) AS avg_salary FROM employees;
SELECT MIN(salary), MAX(salary) FROM employees;

-- =============================================
-- WINDOW FUNCTIONS (MySQL 8.0+)
-- =============================================
SELECT emp_name, dept, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;

SELECT emp_name, dept, salary,
RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dept_rank
FROM employees;

SELECT emp_name, salary,
SUM(salary) OVER (
    ORDER BY emp_id
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
) AS running_total
FROM employees;

-- =============================================
-- CONVERSION FUNCTIONS
-- =============================================
SELECT CAST('123' AS UNSIGNED);
SELECT CONVERT('2025-02-06', DATE);

-- =============================================
-- SYSTEM FUNCTIONS
-- =============================================
SELECT DATABASE();
SELECT USER();
SELECT VERSION();

-- =============================================
-- END OF SCRIPT
-- =============================================

create schema WF;

USE WF;

CREATE TABLE employees (
    emp_id INT,
    dept VARCHAR(20),
    salary INT
);

INSERT INTO employees VALUES
(1, 'HR', 40000),
(2, 'HR', 50000),
(3, 'IT', 60000),
(4, 'IT', 70000),
(5, 'IT', 80000);

INSERT INTO employees VALUES
(6, 'HR', 40000),
(7, 'HR', 50000),
(8, 'IT', 60000),
(9, 'IT', 90000),
(10, 'IT', 80000);

-- ROE_NUMBER()  Assigns a unique row number.  Used for pagination, top N records

SELECT emp_id, dept, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;

-- RANK()  Same rank for ties, skips numbers.

-- Salary tie → same rank → next rank jumps.

SELECT emp_id, dept, salary,
RANK() OVER (ORDER BY salary DESC) AS rank_sal
FROM employees;

-- DENSE_RANK() Same rank for ties, no gaps.

SELECT emp_id, dept, salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_sal
FROM employees;


-- Partition By (Department Wise Ranking)  Ranking within each department

SELECT emp_id, dept, salary,
RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS dept_rank
FROM employees;

-- Aggregate Window Functions   Use aggregates without GROUP BY.

SELECT emp_id, dept, salary,
SUM(salary) OVER (PARTITION BY dept) AS dept_total_salary
FROM employees;

-- AVG()

SELECT emp_id, salary,
AVG(salary) OVER () AS company_avg_salary
FROM employees;

-- RUNNING TOTAL

SELECT emp_id, salary,
SUM(salary) OVER (ORDER BY emp_id) AS running_total
FROM employees;


-- LAG() & LEAD()  Compare previous or next row.  Useful for trend analysis

-- LAG()

SELECT emp_id, salary,
LAG(salary) OVER (ORDER BY emp_id) AS prev_salary
FROM employees;


-- LEAD()

SELECT emp_id, salary,
LEAD(salary) OVER (ORDER BY emp_id) AS next_salary
FROM employees;


-- FIRST_VALUE() & LAST_VALUE()

SELECT emp_id, dept, salary,
FIRST_VALUE(salary) OVER (PARTITION BY dept ORDER BY salary DESC) AS highest_salary
FROM employees;


-- LAST_VALUE() needs frame specification:
/*
LAST_VALUE(salary) OVER (
    PARTITION BY dept
    ORDER BY salary
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) */

-- Window Frame (ROWS vs RANGE)

-- ROWS  Counts physical rows.  ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
-- RANGE Based on values.  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

























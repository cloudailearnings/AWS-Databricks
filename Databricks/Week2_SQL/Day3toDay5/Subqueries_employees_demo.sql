-- subquery
create database demosqry;

use demosqry;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES
(10, 'HR', 'Bangalore'),
(20, 'IT', 'Hyderabad'),
(30, 'Finance', 'Mumbai'),
(40, 'Sales', 'Delhi');

INSERT INTO employees VALUES
(1, 'Amit', 60000, 20, '2022-01-10'),
(2, 'Neha', 75000, 20, '2021-06-15'),
(3, 'Rahul', 50000, 10, '2023-03-01'),
(4, 'Priya', 90000, 30, '2020-11-20'),
(5, 'Kiran', 45000, 10, '2023-08-12'),
(6, 'Sonal', 80000, 40, '2019-07-25');

-- Simple Subqueries (Single Row)

-- Employees earning more than average salary

SELECT emp_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- Employee(s) with maximum salary

SELECT emp_name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary) FROM employees
);

-- Subquery with IN (Multi-row)

-- Employees working in IT department

SELECT emp_name
FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM departments
    WHERE dept_name = 'IT'
);

-- Employees working in departments located in Bangalore

SELECT emp_name
FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM departments
    WHERE location = 'Bangalore'
);

-- Correlated Subqueries

-- Employees earning more than their department’s average

SELECT emp_name, salary, dept_id
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id
);
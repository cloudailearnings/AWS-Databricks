USE SQRY;

-- INNER JOIN

SELECT p.*, o.*
FROM products p
INNER JOIN orders o
ON p.product_id = o.product_id;

-- LEFT JOIN (LEFT OUTER JOIN)

SELECT p.product_name, o.quantity
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id;

-- RIGHT JOIN (RIGHT OUTER JOIN)

SELECT p.product_name, o.quantity
FROM products p
RIGHT JOIN orders o
ON p.product_id = o.product_id;

-- FULL OUTER JOIN

SELECT p.product_name, o.quantity
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id

UNION

SELECT p.product_name, o.quantity
FROM products p
RIGHT JOIN orders o
ON p.product_id = o.product_id;

-- CROSS JOIN

SELECT p.product_name, o.order_id
FROM products p
CROSS JOIN orders o;

-- NATURAL JOIN

SELECT *
FROM products
NATURAL JOIN orders;

-- SELF JOIN

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,

    CONSTRAINT fk_manager
        FOREIGN KEY (manager_id)
        REFERENCES employees(emp_id)
        ON DELETE SET NULL
);


INSERT INTO employees (emp_name, department, salary, manager_id) VALUES
('Rajesh',  'IT',    90000, NULL),   -- CEO
('Anita',   'IT',    75000, 1),      -- Reports to Rajesh
('Vikram',  'IT',    65000, 1),
('Suresh',  'HR',    70000, NULL),   -- HR Head
('Neha',    'HR',    50000, 4),
('Amit',    'Sales', 60000, NULL),
('Priya',   'Sales', 45000, 6);

-- Employee → Manager Mapping

SELECT
    e.emp_name  AS employee,
    m.emp_name  AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;

-- Employees Who Earn More Than Their Manager

SELECT
    e.emp_name AS employee,
    e.salary   AS employee_salary,
    m.emp_name AS manager,
    m.salary   AS manager_salary
FROM employees e
JOIN employees m	
ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Employees Under the Same Manager

SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    m.emp_name  AS manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.manager_id
AND e1.emp_id <> e2.emp_id
JOIN employees m
ON e1.manager_id = m.emp_id;


CREATE TABLE products_SELF_JOIN (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    -- Self-reference (parent product)
    parent_product_id INT,

    CONSTRAINT fk_parent_product_SELF_JOIN
        FOREIGN KEY (parent_product_id)
        REFERENCES products_SELF_JOIN(product_id)
        ON DELETE SET NULL
);

INSERT INTO products_SELF_JOIN (product_name, category, price, parent_product_id) VALUES
('Laptop Pro',        'Electronics', 85000, NULL),
('Laptop Air',        'Electronics', 65000, NULL),
('Laptop Pro 16GB',   'Electronics', 95000, 1),
('Mouse Wireless',    'Accessories', 1500,  NULL),
('Mouse Wired',       'Accessories', 800,   NULL),
('Mouse Wireless X',  'Accessories', 2000,  4);

-- Products in the Same Category

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.category
FROM products_SELF_JOIN p1
JOIN products_SELF_JOIN p2
ON p1.category = p2.category
AND p1.product_id <> p2.product_id;


DROP TABLE employees;


SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    m.emp_name  AS manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.manager_id
AND e1.emp_id <> e2.emp_id
JOIN employees m
ON e1.manager_id = m.emp_id;

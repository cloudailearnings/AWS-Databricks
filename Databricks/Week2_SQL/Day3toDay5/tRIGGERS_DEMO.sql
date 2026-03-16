create database  triggers;

use triggers;

CREATE TABLE employees_1 (
    employee_id int PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50), 
    hourly_pay DECIMAL(5, 2),
    hire_date DATE
);


-- EXAMPLE 1 --
INSERT INTO employees_1
VALUES (1, "Eugene", "Krabs", 25.50, "2023-01-02");

SELECT * FROM employees;

-- EXAMPLE 2 --
INSERT INTO employees_1
VALUES  (2, "Squidward", "Tentacles", 15.00, "2023-01-03"), 
                (3, "Spongebob", "Squarepants", 12.50, "2023-01-04"), 
                (4, "Patrick", "Star", 12.50, "2023-01-05"), 
                (5, "Sandy", "Cheeks", 17.25, "2023-01-06");
SELECT * FROM employees;

-- EXAMPLE 3 --
INSERT INTO employees_1 (employee_id, first_name, last_name)
VALUES  (6, "Sheldon", "Plankton");
SELECT * FROM employees;

drop table employees;

CREATE TABLE employees_1 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    created_at DATETIME,
    updated_at DATETIME
);

-- for trigger demo

CREATE TABLE employees_audit_1 (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    action_type VARCHAR(20),
    action_time DATETIME
);

INSERT INTO employees_1 (emp_id, emp_name, department, salary, created_at)
VALUES
(101, 'Raj', 'IT', 50000, NOW()),
(102, 'Anita', 'HR', 45000, NOW()),
(103, 'John', 'Finance', 60000, NOW());

INSERT INTO employees_1 (emp_id, emp_name, department, salary, created_at)
VALUES
(104, 'ABC', 'FIN', 100000, NOW());

SELECT * FROM employees_1;

-- BEFORE INSERT Trigger

DELIMITER //
CREATE TRIGGER before_employee_insert_1
BEFORE INSERT ON employees_1
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END //

select * from employees_1;

-- BEFORE UPDATE Trigger  Automatically update updated_at

DELIMITER //
CREATE  TRIGGER before_employee_update_1
BEFORE UPDATE ON employees_1
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END //

UPDATE employees_1
SET salary = 200000
WHERE emp_id = 103;

select * from employees_1;

-- AFTER UPDATE Trigger (Audit Salary Changes)

DELIMITER //
CREATE TRIGGER after_salary_update_2
AFTER UPDATE ON employees_1
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO employees_audit_1 (
            emp_id,
            old_salary,
            new_salary,
            action_type,
            action_time
        )
        VALUES (
            OLD.emp_id,
            OLD.salary,
            NEW.salary,
            'SALARY UPDATE',
            NOW()
        );
    END IF;
END //

UPDATE employees_1
SET salary = 175000
WHERE emp_id = 104;

SELECT * FROM EMPLOYEES_1;

SELECT * FROM employees_audit_1;

SELECT * FROM employees_audit;

-- BEFORE DELETE Trigger

-- Prevent deleting IT employees

DELIMITER //
CREATE TRIGGER before_employee_delete_1
BEFORE DELETE ON employees_1
FOR EACH ROW
BEGIN
    IF OLD.department = 'IT' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'IT employees cannot be deleted';
    END IF;
END //

-- Test DELETE Trigger

DELETE FROM employees_1 WHERE emp_id = 102;

SHOW TRIGGERS LIKE 'employees_1';

SELECT * FROM employees_audit;

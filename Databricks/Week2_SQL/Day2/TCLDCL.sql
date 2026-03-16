create database tcldcl;

use tcldcl;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT
);

DROP TABLE EMPLOYEES;

START TRANSACTION;

INSERT INTO employees VALUES (101, 'Rahul', 50000);
UPDATE employees SET salary = 55000 WHERE emp_id = 101;

COMMIT;

START TRANSACTION;

DELETE FROM employees WHERE emp_id = 101;

ROLLBACK;

select * from employees;

-- SAVEPOINT

START TRANSACTION;

INSERT INTO employees VALUES (102, 'Asha', 45000);
SAVEPOINT sp1;

UPDATE employees SET salary = 48000 WHERE emp_id = 102;

ROLLBACK TO sp1; -- Insert stays, update is undone

COMMIT; 

-- DCL – Data Control Language  DCL controls permissions and access to database objects.

-- GRANT

create user user1 identified by 'pwd';

SELECT user, host FROM mysql.user;

create user user2@localhost identified by 'pwd';

GRANT SELECT, INSERT
ON tcldcl.employees
TO 'user2'@'localhost';

SHOW GRANTS FOR 'user2'@'localhost';

SHOW GRANTS FOR 'user1'@'%';

-- REVOKE

REVOKE INSERT
ON tcldcl.employees
FROM 'user2'@'localhost';


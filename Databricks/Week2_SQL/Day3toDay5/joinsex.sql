create database joins;
use joins;

-- student_table

CREATE TABLE student_table (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 0)
);

INSERT INTO student_table VALUES
(1, 'student1', 18),
(2, 'student2', 17),
(3, 'student3', 18),
(4, 'student4', 17),
(5, 'student5', 19),
(6, 'student6', 18),
(7, 'student7', 17),
(8, 'student8', 18),
(9, 'student9', 18),
(10, 'student10', 17);

-- marks_table

CREATE TABLE marks_table (
    id INT PRIMARY KEY,
    marks INT CHECK (marks BETWEEN 0 AND 100),
    student_rank INT,
    FOREIGN KEY (id) REFERENCES student_table(id)
);

INSERT INTO marks_table VALUES
(1, 89, 6),
(2, 95, 3),
(3, 76, 9),
(4, 80, 8),
(5, 69, 10),
(6, 92, 4),
(7, 90, 5),
(8, 82, 7),
(9, 97, 2),
(10, 98, 1);


select * from student_table ;

select * from marks_table;

SELECT T1.ID,T1.NAME,T2.MARKS,T2.STUDENT_RANK FROM  STUDENT_TABLE T1
INNER JOIN
MARKS_TABLE T2
ON T1.ID=T2.ID;

-- sports_table

CREATE TABLE sports_table (
    id INT PRIMARY KEY,
	SPORTS VARCHAR(50) NOT NULL
);

INSERT INTO sports_table VALUES
(1, 'cricket'),
(3, 'volleyball'),
(5, 'basketball'),
(6, 'cricket'),
(7, 'volleyball'),
(10, 'basketball');

SELECT * FROM SPORTS_TABLE;

SELECT T1.ID,T1.NAME,T2.sports
FROM  STUDENT_TABLE T1
INNER JOIN
SPORTS_TABLE T2
ON T1.ID=T2.ID;

-- ncc_nss_table

CREATE TABLE ncc_nss_table (
    id INT PRIMARY KEY,
    ncc_nss VARCHAR(10) NOT NULL
);

INSERT INTO ncc_nss_table VALUES
(1, 'ncc'),
(2, 'nss'),
(3, 'ncc'),
(6, 'nss'),
(8, 'nss'),
(10, 'ncc');

SELECT * FROM ncc_nss_table;

SELECT * FROM 
STUDENT_TABLE T1 
LEFT JOIN NCC_NSS_TABLE T2
ON T1.ID=T2.ID;

SELECT * FROM 
SPORTS_TABLE T1 
LEFT JOIN NCC_NSS_TABLE T2
ON T1.ID=T2.ID;

-- RIGH JOIN

SELECT * FROM 
SPORTS_TABLE T1 
RIGHT JOIN NCC_NSS_TABLE T2
ON T1.ID=T2.ID;

SELECT * FROM 
SPORTS_TABLE T1 
LEFT JOIN NCC_NSS_TABLE T2
ON T1.ID=T2.ID

UNION

SELECT * FROM 
SPORTS_TABLE T1 
RIGHT JOIN NCC_NSS_TABLE T2
ON T1.ID=T2.ID;

-- SELF JOIN

CREATE TABLE student_MARKS_table (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age BETWEEN 15 AND 25),
    marks INT CHECK (marks BETWEEN 0 AND 100)
);

INSERT INTO student_MARKS_table VALUES
(1, 'student1', 18, 89),
(2, 'student2', 17, 78),
(3, 'student3', 18, 90),
(4, 'student4', 17, 95),
(5, 'student5', 19, 56),
(6, 'student6', 18, 76),
(7, 'student7', 17, 45),
(8, 'student8', 18, 90),
(9, 'student9', 18, 65),
(10, 'student10', 17, 97);

SELECT * FROM STUDENT_MARKS_TABLE T1
INNER JOIN
STUDENT_MARKS_TABLE T2
ON 
T1.MARKS < T2.MARKS;

SELECT T1.ID,COUNT(T1.ID) AS no_of_students
 FROM STUDENT_MARKS_TABLE T1
INNER JOIN
STUDENT_MARKS_TABLE T2
ON 
T1.MARKS < T2.MARKS
group by t1.id
order by t1.id;


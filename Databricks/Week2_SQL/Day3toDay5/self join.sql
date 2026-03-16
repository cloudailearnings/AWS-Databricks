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

SELECT T2.ID,COUNT(T2.ID) AS no_of_students
 FROM STUDENT_MARKS_TABLE T1
INNER JOIN
STUDENT_MARKS_TABLE T2
ON 
T1.MARKS < T2.MARKS
group by t2.id
order by t2.id;


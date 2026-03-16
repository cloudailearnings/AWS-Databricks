CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    marks INT CHECK (marks BETWEEN 0 AND 100)
);

INSERT INTO students VALUES
(1, 'Amit',   'Male',   78),
(2, 'Rahul',  'Male',   65),
(3, 'Kiran',  'Male',   88),
(4, 'Suresh', 'Male',   55),
(5, 'Neha',   'Female', 72),
(6, 'Priya',  'Female', 80),
(7, 'Anita',  'Female', 68),
(8, 'Pooja',  'Female', 74);

-- single row subquery 

-- Find total number of MALE students whose marks are greater than 
-- the AVERAGE marks of FEMALE students

SELECT COUNT(*) AS total_male_students
FROM students
WHERE gender = 'Male'
AND marks > (
    SELECT AVG(marks)
    FROM students
    WHERE gender = 'Female'
);

-- multi row subquery

-- inner query returns more than one row
-- ex:
-- Inner query returns multiple female marks

-- Students who scored same marks as any female student

SELECT student_name,marks
FROM students
WHERE marks IN (
    SELECT marks
    FROM students
    WHERE gender = 'Female'
);

-- any operator

-- Male students scoring more than ANY female student

-- > ANY → greater than at least one female mark

SELECT student_name, marks
FROM students
WHERE gender = 'Male'
AND marks > ANY (
    SELECT marks
    FROM students
    WHERE gender = 'Female'
);


-- > ALL → greater than every female mark

-- Male students scoring more than ALL female students

SELECT student_name, marks
FROM students
WHERE gender = 'Male'
AND marks > ALL (
    SELECT marks
    FROM students
    WHERE gender = 'Female'
);

-- CORRELATED SUBQUERY

-- Students scoring above average of their own gender

-- For each student → compute gender-wise average

SELECT student_name, gender, marks
FROM students s
WHERE marks > (
    SELECT AVG(marks)
    FROM students
    WHERE gender = s.gender
);

-- Highest scorer in each gender

SELECT student_name, gender, marks
FROM students s
WHERE marks = (
    SELECT MAX(marks)
    FROM students
    WHERE gender = s.gender
);


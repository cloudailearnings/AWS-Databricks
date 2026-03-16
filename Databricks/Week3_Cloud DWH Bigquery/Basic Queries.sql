-- 1. View all data

SELECT
  *
FROM
  `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`;

-- 2. Filter employees with salary > 200000
SELECT *
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
WHERE Salary > 200000;

-- 3. Sort employees by salary descending
SELECT *
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
ORDER BY Salary DESC;

-- 4. Aggregation: Average salary per department
SELECT DeptId, AVG(Salary) AS avg_salary
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
GROUP BY DeptId;

-- 5. Count employees per department
SELECT DeptId, COUNT(*) AS emp_count
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
GROUP BY DeptId;

-- 6. Handle NULL salaries
SELECT Empid, EmpName, IFNULL(Salary, 0) AS salary_handled
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`;

-- 7. Find employees with NULL salary
SELECT *
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
WHERE Salary IS NULL;

-- 8. Deduplicate employees based on Empid
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Empid ORDER BY Empid) AS rn
  FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
)
WHERE rn = 1;

-- 9. Window function: Rank employees by salary within department
SELECT Empid, EmpName, DeptId, Salary,
       RANK() OVER (PARTITION BY DeptId ORDER BY Salary DESC) AS dept_salary_rank
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`;


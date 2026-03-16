
-- =====================================================
-- Advanced BigQuery SQL Script
-- Dataset: Replace `dataset` with your dataset name
-- Table  : employees (Empid, EmpName, Salary, DeptId)
-- =====================================================

-- 1. Advanced Deduplication (keep highest salary per Empid)
SELECT * EXCEPT(rn)
FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY Empid
           ORDER BY Salary DESC
         ) AS rn
  FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
)
WHERE rn = 1;

-- -----------------------------------------------------
-- 2. Second Highest Salary per Department
SELECT *
FROM (
  SELECT *,
         DENSE_RANK() OVER (
           PARTITION BY DeptId
           ORDER BY Salary DESC
         ) AS rnk
  FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
)
WHERE rnk = 2;

-- -----------------------------------------------------
-- 3. Running Total of Salary per Department
SELECT Empid, EmpName, DeptId, Salary,
       SUM(Salary) OVER (
         PARTITION BY DeptId
         ORDER BY Salary
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_salary
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`;

-- -----------------------------------------------------
-- 4. Salary Difference from Department Average
SELECT Empid, EmpName, DeptId, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY DeptId) AS diff_from_avg
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`;

-- -----------------------------------------------------
-- 5. Employees earning above department average
SELECT e.*
FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE` e
WHERE Salary >
(
  SELECT AVG(Salary)
  FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
  WHERE DeptId = e.DeptId
);

-- -----------------------------------------------------
-- 6. Pivot: Department-wise total salary
SELECT *
FROM (
  SELECT DeptId, Salary FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
)
PIVOT (
  SUM(Salary) FOR DeptId IN (10, 20, 30)
);

-- -----------------------------------------------------
-- 7. MERGE (UPSERT) from staging table
MERGE `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE` t
USING `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`_stg s ON t.Empid = s.Empid
WHEN MATCHED THEN
  UPDATE SET
    EmpName = s.EmpName,
    Salary = s.Salary,
    DeptId = s.DeptId
WHEN NOT MATCHED THEN
  INSERT (Empid, EmpName, Salary, DeptId)
  VALUES (s.Empid, s.EmpName, s.Salary, s.DeptId);

-- -----------------------------------------------------
-- 8. BigQuery Scripting with Variable
DECLARE dept_id INT64 DEFAULT 30;

EXECUTE IMMEDIATE FORMAT(
  'SELECT * FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE` WHERE DeptId = %d',
  dept_id
);

-- -----------------------------------------------------
-- 9. Transaction Example
BEGIN TRANSACTION;

UPDATE `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
SET Salary = Salary * 1.10
WHERE DeptId = 20;

DELETE FROM `project-717e36f5-e07b-45e0-870.First_Data_Set.TGTEMPLOYEE`
WHERE Salary IS NULL;

COMMIT TRANSACTION;

-- -----------------------------------------------------
-- 10. SCD Type 2 Implementation
MERGE dataset.employee_dim t
USING dataset.employee_stg s
ON t.Empid = s.Empid AND t.is_active = TRUE
WHEN MATCHED AND t.Salary != s.Salary THEN
  UPDATE SET is_active = FALSE, end_date = CURRENT_DATE()
WHEN NOT MATCHED THEN
  INSERT (Empid, EmpName, Salary, DeptId, start_date, is_active)
  VALUES (s.Empid, s.EmpName, s.Salary, s.DeptId, CURRENT_DATE(), TRUE);

-- -----------------------------------------------------
-- 11. Metadata: Table size and row count
SELECT table_name,
       row_count,
       size_bytes / 1024 / 1024 AS size_mb
FROM dataset.INFORMATION_SCHEMA.TABLES
ORDER BY size_bytes DESC;

-- =====================================================
-- End of Advanced BigQuery Script
-- =====================================================

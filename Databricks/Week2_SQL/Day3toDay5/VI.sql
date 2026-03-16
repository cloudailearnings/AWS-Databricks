# CREATE VIEWS
USE WORLD;

# SIMPLE VIEW
CREATE VIEW V_CITY AS    
SELECT ID,NAME,CountryCode,District,Population  
 FROM city;
 
 # to verify data
 
select * from v_city;
 
select count(*) from v_city;
  
select count(*) from city;

 # to drop view
 
 drop view v_city;
 
 # ALTER VIEW statement is used to modify or update the already created VIEW without dropping it.
 
 ALTER VIEW v_city AS    
SELECT NAME,CountryCode,District,Population
FROM city;   

select * from v_city;

# COMPLEX VIEW:

CREATE VIEW EMP_VIEW
AS
SELECT DEPTID,AVG(salary)
FROM employee
GROUP BY DEPTID;

SELECT * FROM EMP_VIEW;

DROP VIEW EMP_VIEW;

#  inline view

SELECT A.name, A.salary
FROM (SELECT name, salary
      FROM employee
      ORDER BY salary DESC) A
WHERE A.SALARY >100;
                        



CREATE schema HR;

use hr;

CREATE TABLE employee_agg(  
    name varchar(45) NOT NULL,    
    occupation varchar(35) NOT NULL,    
    working_date date,  
    working_hours varchar(10)  
);  

INSERT INTO employee_agg VALUES    
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

select * from employee_agg;

# COUNT
SELECT COUNT(name) FROM employee_agg;   
SELECT COUNT(*) FROM employee_agg;   

#SUM
SELECT SUM(working_hours) AS "Total working hours" 
FROM employee_agg;

#AVG
SELECT AVG(working_hours) AS "Average working hours" FROM employee; 


#MIN
SELECT MIN(working_hours) AS Minimum_working_hours FROM employee_agg;    

#MAX
SELECT MAX(working_hours) AS Maximum_working_hours FROM employee_agg;  

#FIRST
SELECT working_date FROM employee_agg LIMIT 1; 
SELECT working_hours FROM employee_agg LIMIT 1;    

select * from    employee_agg;

#LAST
SELECT working_hours FROM employee_agg 
ORDER BY working_hours asc LIMIT 1;    

  
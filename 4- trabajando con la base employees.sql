
### SELECT statement

SELECT 
    first_name, last_name
FROM
    employees;

SELECT * FROM employees;

SELECT dept_no FROM departments;

SELECT * FROM departments;

### WHERE Statement

SELECT * FROM employees WHERE first_name = 'Denis';

SELECT * FROM employees WHERE first_name = 'Elvis';

### AND statement: se tienen que cumplir todas las condiciones

SELECT * FROM employees WHERE first_name = 'Elvis' AND gender = 'M';

SELECT * FROM employees WHERE first_name = 'Kellie' AND gender = 'F';

### OR statement: se cumpla 1 de las condiciones

SELECT * FROM employees WHERE first_name = 'Denis' OR first_name = 'Elvis';

SELECT * FROM employees WHERE first_name = 'Denis' OR first_name = 'Aruna';

### AND y OR en una misma consulta

SELECT * FROM employees WHERE last_name = 'Denis' AND ( gender= 'M' OR gender = 'F');

SELECT * FROM employees WHERE gender = 'F' AND (first_name = 'Denis' OR first_name = 'Aruna');

### IN - NOT IN

SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan');


SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('Cathie' , 'Mark', 'Nathan');
    
SELECT * FROM employees WHERE first_name IN ('Denis', 'Elvis');

SELECT * FROM employees WHERE first_name NOT IN ('John', 'Mark','Jacob');

### LIKE - NOT LIKE

SELECT * FROM employees WHERE first_name LIKE ('Mark%');

SELECT * FROM employees WHERE hire_date LIKE ('%2000%');

SELECT * FROM employees WHERE emp_no LIKE ('%1000');

#### Wild Characters

SELECT * FROM employees WHERE first_name LIKE('%Jack%');

SELECT * FROM employees WHERE first_name NOT LIKE('%Jack%');

#### BETWEEN - AND

SELECT * FROM salaries WHERE salary BETWEEN 66000 AND 70000;

SELECT * FROM salaries WHERE emp_no NOT BETWEEN 10004 AND 10012;

SELECT * FROM departments WHERE dept_no BETWEEN 'd003' ANd 'd006';

#### IS NULL, IS NOT NULL

SELECT * FROM departments WHERE dept_name IS NOT NULL;

SELECT * FROM departments WHERE dept_name IS NULL;

### Others Comparission Operators

SELECT * FROM employees WHERE gender= 'F' AND hire_date >= '2000-01-01' ;

SELECT * FROM salaries WHERE salary > 150000;

#### SELECT DISTINCT

SELECT DISTINCT hire_date FROM employees;

#### agreggate functions

SELECT COUNT(*) FROM salaries WHERE salary >= 100000;

SELECT COUNT(*) FROM dept_manager;


#### ORDER BY

SELECT * FROM employees ORDER BY hire_date DESC;

#### GROUP BY

SELECT 
	first_name, COUNT(first_name)
FROM
	employees
GROUP BY first_name
ORDER BY first_name DESC;

#Alias
SELECT 
	first_name, COUNT(first_name) AS names_count
FROM
	employees
GROUP BY first_name
ORDER BY first_name DESC;

### Excercise: Write a query that obtains two columns. The first column must contain annual salaries higher than 80,000 dollars.
#The second column, renamed to “emps_with_same_salary”, must show the number of employees contracted to that salary. 
#Lastly, sort the output by the first column.

SELECT salary, COUNT(salary) AS emps_with_same_salary
FROM salaries
WHERE salary > 80000
GROUP BY salary
ORDER BY salary ASC;
 
 
 #### HAVING
 
 SELECT * FROM employees
 HAVING hire_date >= '2000-01-01'; #Mismo que WHERE
 
SELECT 
	first_name, COUNT(first_name) AS names_count
FROM
	employees
GROUP BY first_name
HAVING COUNT (first_name)>250
ORDER BY first_name DESC;

#HAVING Excercise
#Select all employees whose average salary is higher than $120,000 per annum.
#Hint: You should obtain 101 records.
#Compare the output you obtained with the output of the following two queries:

SELECT
    *, AVG(salary) #poner * hace que SQL traiga todas las columnas de salaries, no es compatible (error)
FROM
    salaries
WHERE
    salary > 120000
GROUP BY emp_no
ORDER BY emp_no;
 

SELECT
    *, AVG(salary) #poner * hace que SQL traiga todas las columnas de salaries, no es compatible (error)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000;

#Respuesta:

SELECT emp_no,AVG(salary) FROM salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;


#### WHERE VS HAVING

SELECT first_name, COUNT(first_name) AS names_count
FROM employees
WHERE hire_date>'1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY first_name DESC;

#Select the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
#Hint: To solve this exercise, use the “dept_emp” table.

SELECT emp_no 
FROM dept_emp
WHERE
from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date)>1
ORDER BY emp_no; 


#### LIMIT: Select the first 100 rows from the ‘dept_emp’ table. 

SELECT * FROM dept_emp
LIMIT 100;

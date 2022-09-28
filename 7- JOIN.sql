/*
If you currently have the ‘departments_dup’ table set up, use DROP COLUMN to remove the ‘dept_manager’
column from the ‘departments_dup’ table.
Then, use CHANGE COLUMN to change the ‘dept_no’ and ‘dept_name’ columns to NULL.

(If you don’t currently have the ‘departments_dup’ table set up, create it. Let it contain two columns:
dept_no and dept_name. Let the data type of dept_no be CHAR of 4, and the data type of dept_name be VARCHAR 
of 40. Both columns are allowed to have null values. Finally, insert the information contained in ‘departments’
into ‘departments_dup’.)

Then, insert a record whose department name is “Public Relations”.
Delete the record(s) related to department number two.
Insert two new records in the “departments_dup” table. Let their values in the “dept_no” column be “d010” and “d011”.
*/

# if you currently have ‘departments_dup’ set up:

ALTER TABLE departments_dup
DROP COLUMN dept_manager;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

 # if you don’t currently have ‘departments_dup’ set up

DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup
(
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);
INSERT INTO departments_dup
(
    dept_no,
    dept_name
)SELECT
    *
FROM
departments;

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_dup
WHERE dept_no = 'd002'; 

INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

/*
Create and fill in the ‘dept_manager_dup’ table, using the following code:
*/

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );

INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES 
	(999904, '2017-01-01'),
	(999905, '2017-01-01'),
	(999906, '2017-01-01'),
	(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE    dept_no = 'd001';

INSERT INTO departments_dup (dept_name)
VALUES  ('Public Relations');

DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 

######################################JOIN#############################JOIN#########################

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY dept_no; 

/*
Extract a list containing information about all managers’ employee
number, first and last name, department number, and hire date. 
*/

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        INNER JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
ORDER BY emp_no; 

/*
Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees whose last name is Markovitch.
See if the output contains a manager with that name.  
Hint: Create an output containing information corresponding to the following fields: ‘emp_no’, ‘first_name’, ‘last_name’, 
‘dept_no’, ‘from_date’. Order by 'dept_no' descending, and then by 'emp_no'.
*/

SELECT
    e.emp_no,  
    e.first_name,  
    e.last_name,  
    dm.dept_no,  
    dm.from_date  
FROM  
    employees e  
        LEFT JOIN   
		dept_manager dm ON e.emp_no = dm.emp_no  
	WHERE  
    e.last_name = 'Markovitch'  
ORDER BY dm.dept_no DESC, e.emp_no;

/*
Extract a list containing information about all managers’ employee number, first and last name, department number, 
and hire date. Use the old type of join syntax to obtain the result.
*/

#### old JOIN
SELECT 
	e.emp_no, e.first_name, e.last_name, dm.dept_no, hire_date
FROM
	employees e,
    dept_manager dm
WHERE
	e.emp_no = dm.emp_no;
    
#### new Join

SELECT 
	e.emp_no, e.first_name, e.last_name, dm.dept_no, hire_date
FROM
	employees e
JOIN
	dept_manager dm ON e.emp_no = dm.emp_no;
    
####### JOIN + WHERE #######

SELECT 
	e.emp_no, e.first_name, e.last_name, s.salary
FROM
	employees e
JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE s.salary>145000;

### Prevent error code: 1055####
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

/*
Select the first and last name, the hire date, and the job title of all employees 
whose first name is “Margareta” and have the last name “Markovitch”.
*/

SELECT
	e.first_name, e.hire_date, t.title
FROM 
	employees e
JOIN
	titles t ON t.emp_no = e.emp_no
WHERE e.first_name = 'Margareta' and e.last_name = 'Markovitch'
ORDER BY e.emp_no;

####### CROSSS JOIN ##########

SELECT 
	dm.*, d.*
    FROM
    dept_manager dm
		CROSS JOIN
	departments d
ORDER BY dm.emp_no, d.dept_no;

SELECT
dm.*, d.*
    FROM
    dept_manager dm,
	departments d
ORDER BY dm.emp_no, d.dept_no;

SELECT 
	e.*, d.*
    FROM
    dept_manager dm
		CROSS JOIN
	departments d
		JOIN
	employees e ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no, d.dept_no;

/*
Use a CROSS JOIN to return a list with all possible combinations between managers from the dept_manager table and 
department number 9.
*/

SELECT dm.*, d.*
FROM 
	departments d
    CROSS JOIN
    dept_manager dm
WHERE d.dept_no='d009'
ORDER BY d.dept_no;

/*Return a list with the first 10 employees with all the departments they can be assigned to.
Hint: Don’t use LIMIT; use a WHERE clause.*/

SELECT e.*, d.*
FROM
	employees e
    CROSS JOIN
    departments d
		WHERE 
        emp_no < 10011
ORDER BY e.emp_no, d.dept_name;

###### JOIN with agreggate functions #####

##ejercicio: buscando salarios promedio entre hombres y mujeres

SELECT
	e.emp_no, e.gender, AVG(s.salary) as average_salary
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

SELECT
	e.gender, AVG(s.salary) as average_salary
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

##### JOIN para muchas tablas

SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
	employees e
		JOIN
	dept_manager m ON e.emp_no = m.emp_no
		JOIN
	departments d ON m.dept_no = d.dept_no;
    
    ##Podríamos invertir el orden del JOIN y quedaría igual
    #Se puede hacer con RIGHT, LEFT, etc (obviamente acá si cambia el resultado)
    
    /*
    Select all managers’ first and last name, hire date, job title, start date, and department name.
    */
    
SELECT
	e.first_name, e.last_name, e.hire_date, t.title, m.from_date, d.dept_name
FROM
	employees e
		JOIN
	titles t ON t.emp_no = e.emp_no
		JOIN
	dept_manager m ON m.emp_no = t.emp_no
		JOIN
	departments d ON d.dept_no = m.dept_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no ;

/*
Obtendremos el nombre de todos los departamentos y calcuar salario promedio pagado a los gerentes en cada
uno de ellos, para aquellos que tienen un sueldo mayor a 60000.
*/

SELECT 
	d.dept_name, AVG(salary) as average_salary
FROM 
	departments d
		JOIN
    dept_manager m ON d.dept_no = m.dept_no
		JOIN
	salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING average_salary > 60000
ORDER BY AVG(salary) DESC; #AVG(salary) podría haber puesto average_salary


/*
How many male and how many female managers do we have in the ‘employees’ database?
*/

SELECT
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

##### UNION vs UNION ALL

SELECT
	e.emp_no,
    e.first_name,
    e.last_name
    NULL AS dept_no,
    NULL AS from_date
FROM
	employees_dup e
WHERE
	e.emp_no = 10001
UNION ALL SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
	dept_manager m;


/*
Go forward to the solution and execute the query. What do you think is the meaning of the minus sign before subset A 
in the last row (ORDER BY -a.emp_no DESC)? 
*/

SELECT
    *
FROM
    (SELECT
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) as a
ORDER BY -a.emp_no DESC;



##### SUBQUERIES #####

SELECT * FROM dept_manager;

/* obteniendo la cantidad de empleados que son gerentes
	-La consulta externa es todo el código hasta el operador IN
    -La subquerie es la que está después del IN
    
    */

SELECT
	e.first_name, e.last_name
FROM
	employees e 
WHERE
	e.emp_no IN (SELECT
		dm.emp_no
	FROM 
		dept_manager dm);

/*
Extract the information about all department managers who were hired between the 1st of January 1990 
and the 1st of January 1995.
*/

SELECT
	*
FROM
	dept_manager
WHERE
	emp_no IN (SELECT
		emp_no
	FROM 
		employees
        WHERE 
			hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
### Exists not exists

SELECT
	e.first_name, e.last_name
FROM
	employees e
WHERE 
	EXISTS( SELECT 
		*
	FROM
		dept_manager dm
	WHERE
		dm.emp_no = e.emp_no)
ORDER BY emp_no; # el order by va en la consulta externa

/*
Select the entire information for all employees whose job title is “Assistant Engineer”. 
Hint: To solve this exercise, use the 'employees' table.
*/

SELECT
    *
FROM
    employees e
WHERE
    EXISTS( SELECT
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');
                
/*
Asign employee number 110022 as a manager to all employees from 100001 to 100020, and employee number
110039 as a manager to all employees from 100021 to 100040
*/

#from 100001 to 100020 = subset A
#from 100021 to 100040 = subset B

SELECT A.* FROM 
(SELECT
	e.emp_no as employee_ID,
    MIN(de.dept_no) as department_code,
	(SELECT 
		emp_no
		FROM
		dept_manager
		WHERE
		emp_no = 1100022) as manager_ID
FROM 
	employees e
    JOIN
    dept_emp de ON e.emp_no = de.emp_no
    WHERE e.emp_no <=10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) as A
UNION SELECT 
	B.* FROM 
(SELECT
	e.emp_no as employee_ID,
    MIN(de.dept_no) as department_code,
	(SELECT 
		emp_no
		FROM
		dept_manager
		WHERE
		emp_no = 1100039) as manager_ID
FROM 
	employees e
    JOIN
    dept_emp de ON e.emp_no = de.emp_no
    WHERE e.emp_no <=10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no LIMIT 20) as B;

/*
Starting your code with “DROP TABLE”, create a table called “emp_manager” (emp_no – integer of 11, not null; dept_no – 
CHAR of 4, null; manager_no – integer of 11, not null). 
*/
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
   emp_no INT(11) NOT NULL,
   dept_no CHAR(4) NULL,
   manager_no INT(11) NOT NULL
);

/*
Fill emp_manager with data about employees, the number of the department they are working in, and their managers.

Your query skeleton must be:

Insert INTO emp_manager SELECT

U.*

FROM

                 (A)

UNION (B) UNION (C) UNION (D) AS U;

A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM). 
In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020 (this must 
be subset A), and employee number 110039 as a manager to all employees from 10021 to 10040 (this must be subset B).

Use the structure of subset A to create subset C, where you must assign employee number 110039 as a manager 
to employee 110022.

Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 as a manager 
to employee 110039.

Your output must contain 42 rows.
Good luck!
*/

INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;
    
    /*
    From the emp_manager table, extract the record data only of those employees who are managers as well. 
    Hay dos formas de hacerlo:
    */
    
SELECT DISTINCT
	e1.*
FROM
	emp_manager e1
    JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;
    
#La segunda forma (más sofisticada)

SELECT
	e1.*
FROM
	emp_manager e1
    JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE 
e2.emp_no IN(SELECT 
				manager_no
			FROM
				emp_manager);



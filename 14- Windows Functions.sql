USE employees;

SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER() AS row_num
FROM 
	salaries;
    
    
SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER(PARTITION BY emp_no) AS row_num #todos los asociados al mismo emp_no pertenecen a 1 partición
FROM 
	salaries;
    


SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM 
	salaries;

/*
Exercise #1 :
Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database 
(regardless of their department).
Let the numbering disregard the department the managers have worked in. Also, let it start from the value of 1. Assign that 
value to the manager with the lowest employee number.

Exercise #2:
Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. 
Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).
*/

SELECT
	emp_no,
    dept_no,
    ROW_NUMBER() OVER(ORDER BY emp_no DESC) AS row_num
FROM
	dept_manager;
    
SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER() AS row_num1,
    ROW_NUMBER() OVER(PARTITION BY emp_no) AS row_num2,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num3,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num4
FROM
	salaries
ORDER BY emp_no, salary;


#### A Note on Using Several Window Functions - Exercise

/*Exercise #1:

Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the 
"employees" database.
Use window functions to add the following two columns to the final output:
	- a column containing the row number of each row from the obtained dataset, starting from 1.
	- a column containing the sequential row numbers associated to the rows for each manager, where their highest salary has 
	  been given a number equal to the number of rows in the given partition, and their lowest - the number 1.
Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number 
columns, and then by the salary values for each partition in ascending order.

Exercise #2:
Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the 
"employees" database.
Use window functions to add the following two columns to the final output:
	- a column containing the row numbers associated to each manager, where their highest salary has been given a number 
      equal to the number of rows in the given partition, and their lowest - the number 1.
	- a column containing the row numbers associated to each manager, where their highest salary has been given the number 
      of 1, and the lowest - a value equal to the number of rows in the given partition.
Let your output be ordered by the salary values associated to each manager in descending order.
Hint: Please note that you don't need to use an ORDER BY clause in your SELECT statement to retrieve the desired output. 
*/

### Ejercicio 1

SELECT
	dm.emp_no,
    salary,
    ROW_NUMBER() OVER () AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2
FROM
dept_manager dm
    JOIN 
salaries s ON dm.emp_no = s.emp_no
ORDER BY row_num1, emp_no, salary ASC;


### Ejercicio 2

SELECT
	dm.emp_no,
    salary,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   
FROM
	dept_manager dm
		JOIN 
    salaries s ON dm.emp_no = s.emp_no;


######### WINDOW FUNCTION SYNTAX

SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM 
	salaries
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);


#### MySQL Window Functions Syntax - Exercise

/*Exercise #1:

Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first 
names and ordering each partition by their employee number in ascending order.
NB! While writing the desired query, do *not* use an ORDER BY clause in the relevant SELECT statement. At the same time, 
do use a WINDOW clause to provide the required window specification.
*/

SELECT
	emp_no,
	first_name,
	ROW_NUMBER() OVER w AS row_num
FROM
	employees
	WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);
    
########## PARTITION BY vs GROUP BY

/* dos formas de llegar a lo mismo */

#1
SELECT 
	a.emp_no,
    MAX(salary) AS max_salary 
FROM(
	SELECT
		emp_no,
        salary,
        ROW_NUMBER() OVER w AS row_num
	FROM
		salaries
	WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC)) a
GROUP BY emp_no;

#2

SELECT 
	a.emp_no,
    MAX(salary) AS max_salary 
FROM(
	SELECT
		emp_no,
        salary,
        ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
	FROM
		salaries) a
GROUP BY emp_no;

#3

SELECT 
	a.emp_no,
    a.salary AS max_salary 
FROM(
	SELECT
		emp_no,
        salary,
        ROW_NUMBER() OVER w AS row_num
	FROM
		salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC)) a
WHERE a.row_num = 1; #Recupera el salario del empleado clasificado como 1
					 #Si lo cambio por un 2 obtengo el segundo salario mas alto del empleado
                     #Si lo cambio por un 3 obtengo el tercer salario mas alto del empleado
                     #...


##### The PARTITION BY Clause VS the GROUP BY Clause - Exercise

/*Exercise #1:

Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery 
containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.
Also, to obtain the desired result set, refer only to data from the “salaries” table.

Exercise #2:

Again, find out the lowest salary value each employee has ever signed a contract for. Once again, to obtain the desired output, 
use a subquery containing a window function. This time, however, introduce the window specification in the field list of the 
given subquery.
To obtain the desired result set, refer only to data from the “salaries” table.

Exercise #3:

Once again, find out the lowest salary value each employee has ever signed a contract for. This time, to obtain the desired 
output, avoid using a window function. Just use an aggregate function and a subquery.
To obtain the desired result set, refer only to data from the “salaries” table.

Exercise #4:

Once more, find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a 
subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. 
Moreover, obtain the output without using a GROUP BY clause in the outer query.
To obtain the desired result set, refer only to data from the “salaries” table.

Exercise #5:

Find out the second-lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a 
subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. 
Moreover, obtain the desired result set without using a GROUP BY clause in the outer query.
To obtain the desired result set, refer only to data from the “salaries” table.
*/

#Excercise 1

SELECT 
	a.emp_no,
	MIN(salary) AS min_salary FROM (
	SELECT
		emp_no, 
        salary, 
        ROW_NUMBER() OVER w AS row_num
	FROM
		salaries
	WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;

#Excercise 2

SELECT 
	a.emp_no,
	MIN(salary) AS min_salary FROM (
	SELECT
		emp_no,
        salary, 
        ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary) AS row_num
	FROM
		salaries) a
GROUP BY emp_no;

#Excercise 3

SELECT
    a.emp_no, 
    MIN(salary) AS min_salary
FROM
    (SELECT
        emp_no, salary
    FROM
		salaries) a
GROUP BY emp_no; 

#Excercise 4

SELECT 
	a.emp_no,
	a.salary as min_salary FROM (
	SELECT
		emp_no, 
        salary, 
        ROW_NUMBER() OVER w AS row_num
	FROM
		salaries
		WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=1;

#Excercise 5

SELECT 
	a.emp_no,
	a.salary as min_salary FROM (
	SELECT
		emp_no, 
        salary, 
        ROW_NUMBER() OVER w AS row_num
	FROM
		salaries
		WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=2;



########## The MySQL RANK() and DENSE_RANK() Window Functions ######

SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM
	salaries
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);
#El empleado 10001 tiene 18 registros vamos a verlo unicamente a el

SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM
	salaries
WHERE emp_no = 10001
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);
#los 18 registros son totalmente diferentes

/* 
El siguiente código mostrará los números de los empleados que han firmado más de un contrato de un determinado
valor salarial
*/
SELECT
	emp_no,
    (COUNT(salary) - COUNT(DISTINCT salary)) AS diff #diferencia entre el número de contratos que han firmado y el número
													 #de valores salariales únicos asociados a estos contratos
FROM
	salaries
GROUP BY 
	emp_no
HAVING
	diff > 0 
ORDER BY emp_no;

/* la salida nos muestra 205 filas, lo que muestra que a lo largo de su vida profesional en la empresa, 205 personas han
firmado más de un contrato del mismo valor 
*/

SELECT
	*
FROM
	salaries
WHERE emp_no = 11839; #este empleado tiene más registros que el anterior

#probamos las ventanas para este empleado
SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM
	salaries
WHERE emp_no = 11839
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);

#Utilizamos RANK() para unir aquellos valores que son iguales y que aparecen en distintos registros
SELECT 
	emp_no,
    salary,
    RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 11839
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);
#vemos que nos registra dos valores con rango 3 y al siguiente salta al rango 5.alter

#DENSE_RANK() asignara el valor del ranking en si mismo.
SELECT 
	emp_no,
    salary,
    DENSE_RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 11839
WINDOW w AS(PARTITION BY emp_no ORDER BY salary DESC);


######## The MySQL RANK() and DENSE_RANK() Window Functions - Exercise ########
/*
Exercise #1:
Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
Order and display the obtained salary values from highest to lowest.

Exercise #2:
Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in 
the company.

Exercise #3:
Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a 
contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear 
the same rank and that gaps in the obtained ranks for subsequent rows are allowed.

Exercise #4:
Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a 
contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear 
the same rank and that gaps in the obtained ranks for subsequent rows are not allowed.
*/


#Solution 1:

SELECT
	emp_no,
	salary,
	ROW_NUMBER() OVER w AS row_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#Solution 2:

SELECT
    dm.emp_no, 
    (COUNT(salary)) AS no_of_salary_contracts
FROM
    dept_manager dm
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no;

#Solution 3:

SELECT
	emp_no,
	salary,
	RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#Solution 4:

SELECT
	emp_no,
	salary,
	DENSE_RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

/*
Create a query that will complete all the following subtasks at once:
	- obtain data only about the managers from the "employees" database.
    - Partition the relevant information by the department where the managers have worked in
    - Arrange the partitions by the manager's salary contract values in descending order 
    - Rank the managers according to their salaries in a certain department (where you prefer to not lose track of the number of
      salary contracts signed within each department)
	- Display the start and end dates of each salary contract (call the relevant fields fro salary_from_date and
      salary_to_date, respectively)
	- Display the first and last date in which an employee has been a manager, according to the data provided in the 
      dept_manager table (call the relevant fields dept_manager_from_date and dept_manager_to_date, respectively)
*/

USE employees;

SELECT
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    RANK() OVER w AS department_salary_ranking,
    s.salary,
    s.from_date AS salary_from_date,
    s.to_date AS salary_to_date,
    dm.from_date AS dept_manager_from_date,
    dm.to_date AS dept_manager_to_date
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
		AND s.from_date BETWEEN dm.from_date AND dm.to_date
        AND s.to_date BETWEEN dm.from_date AND dm.to_date
			#garantizan que las fechas de inicio y finalizacion de un contrato salarial deben estar 
            #comprendidas entre los primeros y los últimos días en los que el empleado en gestión ha sido gerente
		JOIN
	departments d ON dm.dept_no = d.dept_no
WINDOW w AS (PARTITION BY dm.dept_no ORDER BY s.salary DESC);

##### Working with MySQL Ranking Window Functions and Joins Together - Exercise ####

/*
Exercise #1:
Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 
and 10600 inclusive. Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks 
obtained for their subsequent rows.
Use a join on the “employees” and “salaries” tables to obtain the desired result.

Exercise #2:
Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:
	- contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
	- contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company 
	  for the first time.
In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for 
their subsequent rows.
Use a join on the “employees” and “salaries” tables to obtain the desired result.
*/

#Solution 1:

SELECT
    e.emp_no,
    RANK() OVER w as employee_salary_ranking,
    s.salary
FROM
	employees e
		JOIN
    salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);


#Solution 2:

SELECT
    e.emp_no,
    DENSE_RANK() OVER w as employee_salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date,
    (YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM
	employees e
		JOIN
    salaries s ON s.emp_no = e.emp_no
    AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

######## LAG() and LEAD() ########

/* 
Write a query extracting the following information for you:
	- The salary values from all contracts that employee 10001 had ever signed while working for the company (in ascending order)
    - A column showing the previous salary value from our ordered list
    - A column displaying the difference between the current and previous salary of given record from the list.
    - A column displaying the difference between the next and current salary of given record from the list.
Remember:
	- we will not order the salaries chhronologically by the dates when the perspective contracts were signed
    - by saying "previous" or "next" salary, we only refer to their relevant values contained in the "salary" field
*/

USE employees;

SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
    LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
WHERE emp_no = 10001
WINDOW w AS (ORDER BY salary);
    

###### The LAG() and LEAD() Value Window Functions - Exercise #######

/*Exercise #1:
Write a query that can extract the following information from the "employees" database:
	- the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive
	- a column showing the previous salary from the given ordered list
	- a column showing the subsequent salary from the given ordered list
	- a column displaying the difference between the current salary of a certain employee and their previous salary
	- a column displaying the difference between the next salary of a certain employee and their current salary
Limit the output to salary values higher than $80,000 only.
Also, to obtain a meaningful result, partition the data by employee number.

Exercise #2:
The MySQL LAG() and LEAD() value window functions can have a second argument, designating how many rows/steps back (for LAG()) 
or forth (for LEAD()) we'd like to refer to with respect to a given record.
With that in mind, create a query whose result set contains data arranged by the salary values associated to each employee 
number (in ascending order). Let the output contain the following six columns:
	- the employee number
	- the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
	- the employee's previous salary
	- the employee's contract salary value preceding their previous salary
	- the employee's next salary
	- the employee's contract salary value subsequent to their next salary
Restrict the output to the first 1000 records you can obtain.
*/

###### Solution 1:

SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
	LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
    WHERE salary > 80000 AND emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

####### Solution 2:

SELECT
emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
	LAG(salary, 2) OVER w AS 1_before_previous_salary,
	LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
	salaries
	WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

/*
Create a MySQL query that will extract the following information about all currently employed workers
registered in dept_emp table:
	- their employee number
    - the department they are working in
    - the salary they are currently being paid (=the salary value specified in their latest contract)
    - the all time average salary paid in the department the employee is currently working in (= use a window
      function to create a field named average_salary_per_department)
*/
USE employees;

SELECT
	s1.emp_no, 
    s.salary,
    s.from_date,
    s.to_date
FROM
	salaries s
		JOIN
	(SELECT 
		emp_no,
		MAX(from_date) AS from_date
	FROM
		salaries 
	GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE 
	s.to_date > SYSDATE()
	AND s.from_date = s1.from_date;
    

####### MySQL Aggregate Functions in the Context of Window Functions - Part I-Exercise ######

/*
Exercise #1:
Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, and 
end dates of the first ever contracts that each employee signed for the company.
To obtain the desired output, refer to the data stored in the "salaries" table.
*/

#Solution 1:

SELECT
    s1.emp_no, 
    s.salary, 
    s.from_date, 
    s.to_date
FROM
    salaries s
        JOIN
    (SELECT
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;
    

#######  MySQL Aggregate Functions in the Context of Window Functions - Part II-Exercise  ########

/*
Exercise #1:
Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 
2002 (as registered in the "dept_emp" table).
Create a MySQL query that will extract the following information about these employees:
	- Their employee number
	- The salary values of the latest contracts they have signed during the suggested time period
	- The department they have been working in (as specified in the latest contract they've signed during the suggested time 
      period)
	- Use a window function to create a fourth field containing the average salary paid in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".
Note1: This exercise is not related neither to the query you created nor to the output you obtained while solving the exercises after the previous lecture.
Note2: Now we are asking you to practically create the same query as the one we worked on during the video lecture; the only difference being to refer to contracts that have been valid within the period between the 1st of January 2000 and the 1st of January 2002.
Note3: We invite you solve this task after assuming that the "to_date" values stored in the "salaries" and "dept_emp" tables are greater than the "from_date" values stored in these same tables. If you doubt that, you could include a couple of lines in your code to ensure that this is the case anyway!
Hint: If you've worked correctly, you should obtain an output containing 200 rows.
*/

##Solution 1:

SELECT
    de2.emp_no, 
    d.dept_name, 
    s2.salary, 
    AVG(s2.salary) OVER w AS average_salary_per_department
FROM
    (SELECT
		de.emp_no, 
        de.dept_no, 
        de.from_date, 
        de.to_date
	 FROM
		dept_emp de
			JOIN
		(SELECT
			emp_no, 
            MAX(from_date) AS from_date
		  FROM
			dept_emp
		  GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
		  WHERE
		  de.to_date < '2002-01-01'
		  AND de.from_date > '2000-01-01'
		  AND de.from_date = de1.from_date) de2
				JOIN
		 (SELECT
			s1.emp_no, 
            s.salary, 
            s.from_date, 
            s.to_date
		  FROM
			salaries s
				JOIN
			(SELECT
				emp_no, 
                MAX(from_date) AS from_date
			 FROM
				salaries
			 GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
			 WHERE
				s.to_date < '2002-01-01'
				AND s.from_date > '2000-01-01'
				AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
					JOIN
				departments d ON d.dept_no = de2.dept_no
				GROUP BY de2.emp_no, d.dept_name
				WINDOW w AS (PARTITION BY de2.dept_no)
				ORDER BY de2.emp_no, salary;


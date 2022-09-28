
##### COUNT() #####

/*
How many departments are there in the “employees” database? 
Use the ‘dept_emp’ table to answer the question.
*/

SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

##### SUM() #####

SELECT SUM(salary) FROM salaries;

/*
What is the total amount of money spent on salaries for all 
contracts starting after the 1st of January 1997?
*/

SELECT SUM(salary) FROM salaries WHERE from_date > '1997-07-01';

##### MIN and MAX ######

SELECT MAX(salary) FROM salaries;
SELECT MIN(salary) FROM salaries;

/*
1. Which is the lowest employee number in the database?
2. Which is the highest employee number in the database?
*/

SELECT MIN(emp_no) FROM employees;
SELECT MAX(emp_no) FROM employees;


#### AVG() ######
/*
What is the average annual salary paid to employees who started after the 1st of January 1997?
*/

SELECT AVG(salary) FROM salaries WHERE from_date > '1997-01-01';

###### ROUND() #######
/*
Round the average amount of money spent on salaries for all contracts that started after the
1st of January 1997 to a precision of cents.
*/

SELECT ROUND(AVG(salary),2) FROM salaries WHERE from_date > '1997-01-01';

##### IFNULL() ######

SELECT dept_no, IFNULL(dept_name,'Department no provided') as dept_name FROM departments;

###### COALESCE() #######

SELECT
dept_no,
dept_name,
COALESCE(dept_manager, dept_name, 'N/A') as dept_manager FROM departments ORDER BY dept_no ASC;

/*
Select the department number and name from the
‘departments_dup’ table and add a third column where you name the
department number (‘dept_no’) as ‘dept_info’. If ‘dept_no’ does not 
have a value, use ‘dept_name’.
*/

SELECT
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

/*
Modify the code obtained from the previous exercise in the following 
way. Apply the IFNULL() function to the values from the first and 
second column, so that ‘N/A’ is displayed whenever a department 
number has no value, and ‘Department name not provided’ is shown 
if there is no value for ‘dept_name’.
*/

SELECT
    IFNULL(dept_no, 'N/A') as dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;


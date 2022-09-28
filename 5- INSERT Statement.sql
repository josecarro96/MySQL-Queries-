SELECT * FROM employees ORDER BY emp_no DESC LIMIT 10;

INSERT INTO employees 
(
	emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) VALUES
(
	999901,
    '1986-04-21',
    'John',
    'Smith',
    'M',
    '2011-01-01'
);

/*
Select ten records from the “titles” table to get a better idea about its content.

Then, in the same table, insert information about employee number 999903. State that he/she is a “Senior Engineer”, who has 
started working in this position on October 1st, 1997.

At the end, sort the records from the “titles” table in descending order to check if you have successfully inserted the new 
record.

Hint: To solve this exercise, you’ll need to insert data in only 3 columns!

Don’t forget, we assume that, apart from the code related to the exercises, you always execute all code provided in the lectures.
This is particularly important for this exercise. If you have not run the code from the previous lecture, called 
‘The INSERT Statement – Part II’, where you have to insert information about employee 999903, you might have trouble solving this exercise!

Code:

INSERT INTO employees

VALUES

(

    999903,

    '1977-09-14',

    'Johnathan',

    'Creek',

    'M',

    '1999-01-01'

);        */   

INSERT INTO employees
(
		emp_no,
        birth_date,
        first_name,
        last_name,
		gender,
        hire_date
)
VALUES

(

    999903,

    '1977-09-14',

    'Johnathan',

    'Creek',

    'M',

    '1999-01-01'

);

SELECT * FROM titles LIMIT 10;

INSERT INTO titles 
(
	emp_no,
    title,
    from_date
) VALUES
(
	9999903,
    'Senior Engineer',
    '1997-10-01'
);

SELECT * FROM titles ORDER BY emp_no DESC;

/* 
Insert information about the individual with employee number 999903 into the “dept_emp” table. 
He/She is working for department number 5, and has started work on  October 1st, 1997; her/his contract is for an indefinite
period of time.

Hint: Use the date ‘9999-01-01’ to designate the contract is for an indefinite period.
*/

INSERT INTO dept_emp
(
	emp_no,
	dept_no,
	from_date,
	to_date
) 
VALUES
(
	999903,
    'd005',
    '1997-10-01',
    '9999-01-01'
    );
    
    
    #### INSERT INTO SELECT
    
CREATE TABLE departments_duo
(
	dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR (40) NOT NULL
);

INSERT INTO departments_duo
(
	dept_no,
    dept_name
)
SELECT 
*
FROM
departments;

SELECT * FROM departments_duo
ORDER BY dept_no;

/*
Create a new department called “Business Analysis”. Register it under number ‘d010’.

Hint: To solve this exercise, use the “departments” table.
*/

INSERT INTO departments
VALUES
(
'd010',
'Business Analysis'
);

#### UDATE Statement

SELECT * FROM eployees WHERE emp_no = 999901; 


UPDATE employees
SET
	first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE
	emp_no = 999901;

/*
Change the “Business Analysis” department name to “Data Analysis”.

Hint: To solve this exercise, use the “departments” table.
*/
UPDATE departments
SET
	dept_name = 'Data Analysis'
WHERE
dept_no = 'd010';


###### DELETE Statement ######

DELETE FROM employees WHERE emp_no = 999901;

/*
Remove the department number 10 record from the “departments” table.
*/

DELETE FROM departments WHERE dept_no = 'd010';


/*
We like to visualize only de period encompassing the last ontract of each employee
*/

CREATE OR REPLACE VIEW v_dept_empt_latest_date AS 
SELECT emp_no, MAX(from_date) as from_date, MAX(to_date) as to_date
FROM dept_emp
GROUP BY emp_no;

/*
Create a view that will extract the average salary of all managers registered in the database. 
Round this value to the nearest cent.

If you have worked correctly, after executing the view from the “Schemas” section in Workbench, 
you should obtain the value of 66924.27.
*/

CREATE OR REPLACE VIEW v_manager_avg_salary AS
    SELECT
        ROUND(AVG(salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager m ON s.emp_no = m.emp_no;

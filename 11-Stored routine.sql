USE employees;

/*
elaboraremos un procedimiento no parametrizado que siempre que se aplique devolverá las 
primeras 1000 filas de la tabla
*/

USE employees;
DROP PROCEDURE IF EXISTS select_employees; #Al ser no parametrizado no son necesarios los paréntesis

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
	SELECT * FROM employees 
    LIMIT 1000;
END $$

DELIMITER ;


### como imbocar el procedimiento

CALL employees.select_employees();

CALL select_employees();

#la tercera forma es usarlo directamente desde la consola de Workbench

/*
Create a procedure that will provide the average salary of all employees.

Then, call the procedure.
*/

DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
	SELECT AVG(salary) FROM salaries
    ORDER BY emp_no;
END $$

DELIMITER ;

CALL avg_salary()

DROP PROCEDURE select_employees;

DELIMITER $$
USE employees$$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER) #es muy importante el IN para que devuelva resulados correctos
												 #p_empp_no es el nombre de la variable de entrada (input)
                                                 #INTEGER es el tipo de dato de la variable de entrada
BEGIN
	SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date 
    FROM employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
    WHERE
		e.emp_no = p_emp_no;
END $$

DELIMITER ;


DELIMITER $$
USE employees$$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER) #es muy importante el IN para que devuelva resulados correctos
												 #p_empp_no es el nombre de la variable de entrada (input)
                                                 #INTEGER es el tipo de dato de la variable de entrada
BEGIN
	SELECT e.first_name, e.last_name, AVG(s.salary)
    FROM employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
    WHERE
		e.emp_no = p_emp_no;
END $$

DELIMITER ;

###Stored Procedures with Output Parameter

DELIMITER $$
USE employees$$
CREATE PROCEDURE emp_avg_salary_out(IN p_emp_no INTEGER, out p_avg_salary DECIMAL (10,2))
BEGIN
	SELECT 
		AVG(s.salary)
	INTO p_avg_salary 
    FROM employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
    WHERE
		e.emp_no = p_emp_no;
END $$

DELIMITER ;

/*Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual,
and returns their employee number.
*/

DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255),
							p_last_name VARCHAR(255), 
							out p_emp_no INTEGER)
BEGIN
	SELECT 
		e.emp_no 
	INTO p_emp_no 
    FROM employees e
		WHERE
		e.first_name = p_first_name
        AND e.last_name = p_last_name;
END $$

DELIMITER ;


###### variables #####
/*
El proceso es:
	1) crear una variable, 
	2) extraer extraer un valor que asignara a la variable recién creada, 
	3) debemos pedirle al software que muestre el resultado del procedimiento seleccionando la variable
*/
SET @v_avg_salary = 0;
CALL employees.emp_avg_salary_out(11300, #input value
									@v_avg_salary);   #Lugar donde se va a almacenar el output
SELECT @v_avg_salary;


/*
Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.
Finally, select the obtained output.
*/

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', #input value
									@v_emp_no);   #Lugar donde se va a almacenar el output
SELECT @v_emp_no;

###### User-Defined Functions in MySQL:

USE employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC #Para eliminar el error (1418) podíamos utilizar: DETERMINISTIC, NO SQL, READS SQL DATA
BEGIN
DECLARE v_avg_salary DECIMAL (10,2);  #Es V_avg.. porque es una variable, DECIMAL (10,2) debe coincidir con el anteriormente 
									  #puesto en RETURNS
                                      #DECLARE se puede utilizar solo con variables locales
SELECT 
	AVG(s.salary)
INTO v_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE  #Establece la conexión entre el p_emp_no designado manualmente por el usuario y 
	   #la columna de número de empleado de la tabla del empleado
	e.emp_no = p_emp_no;
RETURN v_avg_salary; #devuelve el valor del salario promedio
END$$

#ejecutando 
SELECT f_emp_avg_salary (11300);

/*
Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary 
from the newest contract of that employee.

Hint: In the BEGIN-END block of this program, you need to declare and use two variables – v_max_from_date that will be of the 
DATE type, and v_salary, that will be of the DECIMAL (10,2) type.

Finally, select this function.
*/

DELIMITER $$
CREATE FUNCTION f_emp_info (p_first_name VARCHAR(255), 
							p_last_name VARCHAR(255)
                            ) RETURNS DECIMAL(10,2)
DETERMINISTIC #Para eliminar el error (1418) podíamos utilizar: DETERMINISTIC, NO SQL, READS SQL DATA
BEGIN
DECLARE v_max_from_date DATE;
DECLARE v_salary DECIMAL(10,2);
SELECT 
	MAX(from_date)
INTO v_max_from_date FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE  #Establece la conexión entre el p_emp_no designado manualmente por el usuario y 
	   #la columna de número de empleado de la tabla del empleado
	e.first_name = p_first_name
    AND e.last_name = p_last_name;
SELECT
	s.salary
    INTO v_salary FROM
    employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
    WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;
                       RETURN v_salary;
END$$
DELIMITER ;

#resultados
SELECT EMP_INFO('Aruna', 'Journel');

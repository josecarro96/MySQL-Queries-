/*
Create a visualization that provides a breakdown between the male and female employees working in the company 
each year, starting from 1990

Answer: el gráfico de torta no sirve, porque como pide dividirlo por años serían muchas, es más práctico hacer
Un gráfico de barras con proporciones entre hombres y mujeres por año.
*/

SELECT
	YEAR(d.from_date) as calendar_year, #YEAR() obtiene el año de determinada fecha
    e.gender,
    COUNT(e.emp_no) as num_of_employees
FROM
	t_employees e
    JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calendar_year, e.gender
HAVING calendar_year >= 1990;

#Recordar que es condicionado al año > 1990    
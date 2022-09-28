#Ejercicio 1: Creating a table

CREATE TABLE sales
(
	pourchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL,
    costumer_id INT,
    item_code VARCHAR(10) NOT NULL
);

CREATE TABLE customers
(
	costumer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_adress VARCHAR(255),
    number_of_complaints INT
);

SELECT * FROM sales;

SELECT * FROM sales.sales;


DROP TABLE sales; #elimina la tabla sales
DROP TABLE customers; #elimino la tabla costumers para reescribirla

CREATE TABLE customers
(
	customer_id INT,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email_adress VARCHAR(255),
	number_of_complaints INT,
PRIMARY KEY (customer_id)
);

CREATE TABLE items
(
	item_code VARCHAR(255),
    item VARCHAR(255),
    unit_price NUMERIC(10,2),
    company_id VARCHAR(255),
PRIMARY KEY (item_code)    
);

CREATE TABLE companies
(
	company_id VARCHAR(255),
    company_name VARCHAR(255),
    headquarters_phone_number INT(12),
PRIMARY KEY (company_id)    
);

CREATE TABLE sales
(sales
	pourchase_number INT AUTO_INCREMENT,
    date_of_purchase DATE,
    customer_id INT,
    item_code VARCHAR(10) NOT NULL,
PRIMARY KEY (pourchase_number),
FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE sales;
DROP TABLE customers;
DROP TABLE items;
DROP TABLE companies;

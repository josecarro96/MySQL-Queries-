CREATE TABLE customers
(
	customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_adress VARCHAR(255),
    number_of_complaints INT,
PRIMARY KEY (customer_id)
);
ALTER TABLE customers
ADD UNIQUE KEY (email_adress);

ALTER TABLE customers
DROP INDEX email_adress;

DROP TABLE Customers;

CREATE TABLE customers (

    customer_id INT AUTO_INCREMENT,

    first_name VARCHAR(255),

    last_name VARCHAR(255),

    email_address VARCHAR(255),

    number_of_complaints INT,

PRIMARY KEY (customer_id)

);

ALTER TABLE customers
ADD COLUMN gender ENUM('M', 'F') AFTER last_name;

 

INSERT INTO customers (first_name, last_name, gender, email_address, number_of_complaints)
VALUES ('John', 'Mackinley', 'M', 'john.mckinley@365careers.com', 0);

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0; #Para poner valor como defecto 0

INSERT INTO customers (first_name, last_name, gender)
VALUES ('Peter', 'Figaro', 'M'); #no puse number_of_complaints, pero debería agregar un cero por defecto

SELECT * FROM customers;

ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;

CREATE TABLE companies
(
    company_id VARCHAR(255),
    company_name VARCHAR(255) DEFAULT 'X',
    headquarters_phone_number VARCHAR(255),
PRIMARY KEY (company_id),
UNIQUE KEY (headquarters_phone_number)
);

DROP TABLE customers;

ALTER TABLE companies
MODIFY headquarters_phone_number VARCHAR(255) NULL;

ALTER TABLE companies
CHANGE COLUMN headquarters_phone_number headquarters_phone_number VARCHAR(255) NOT NULL;

DROP TABLE companies;
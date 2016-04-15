CREATE DATABASE sales;
GO

USE sales;
GO

CREATE TABLE customers (
   id int primary key identity,
   name varchar(64), 
   email varchar(64)
);

CREATE TABLE employees (
   id int primary key identity, 
   name varchar(64)
);

CREATE TABLE orders (
   id int primary key identity, 
   created_at datetime, 
   employee_id int references employees(id), 
   customer_id int references customers(id)
);

CREATE TABLE products (
   id int primary key identity, 
   name varchar(64), 
   price decimal(8, 2),
   made_in varchar(64)
);

CREATE TABLE ordered_products (
   order_id int references orders(id), 
   product_id int references products(id), 
   number int,
   primary key (order_id, product_id)
);
GO

INSERT INTO customers VALUES ('Customer One', 'c1@fmi.uni-sofia.bg');
INSERT INTO customers VALUES ('Customer Two', 'c2@fmi.uni-sofia.bg');
INSERT INTO customers VALUES ('Customer Three', 'c3@fmi.uni-sofia.bg');
INSERT INTO customers VALUES ('Customer Four', 'c4@fmi.uni-sofia.bg');
INSERT INTO customers VALUES ('Customer Five', 'c5@fmi.uni-sofia.bg');

INSERT INTO employees VALUES ('Employee One');
INSERT INTO employees VALUES ('Employee Two');
INSERT INTO employees VALUES ('Employee Three');
INSERT INTO employees VALUES ('Employee Four');
INSERT INTO employees VALUES ('Employee Five');

INSERT INTO products VALUES ('Shoes', 76.68, 'France');
INSERT INTO products VALUES ('Skirt', 95.00, 'Germany');
INSERT INTO products VALUES ('Jacket', 120.55, 'Italy');
INSERT INTO products VALUES ('Hat', 20.05, 'Russia');
INSERT INTO products VALUES ('Suit', 230.35, 'Spain');
INSERT INTO products VALUES ('Jeans', 64.83, 'France');
INSERT INTO products VALUES ('Boots', 110.15, 'Italy');
INSERT INTO products VALUES ('Shirt', 42.14, 'France');

INSERT INTO orders VALUES ('07/03/2015 11:30:00', 1, 1);
INSERT INTO orders VALUES ('08/02/2016 17:30:00', 1, 2);
INSERT INTO orders VALUES ('07/04/2016 12:00:00', 1, 3);
INSERT INTO orders VALUES ('11/03/2015 13:20:00', 1, 4);
INSERT INTO orders VALUES ('08/02/2016 15:30:00', 2, 1);
INSERT INTO orders VALUES ('09/11/2015 17:30:00', 3, 2);

INSERT INTO ordered_products VALUES (1, 1, 2); 
INSERT INTO ordered_products VALUES (1, 2, 2); 
INSERT INTO ordered_products VALUES (2, 3, 2); 
INSERT INTO ordered_products VALUES (3, 4, 2); 
INSERT INTO ordered_products VALUES (3, 5, 2); 
INSERT INTO ordered_products VALUES (3, 6, 2); 
INSERT INTO ordered_products VALUES (4, 6, 2); 
INSERT INTO ordered_products VALUES (4, 8, 2); 
INSERT INTO ordered_products VALUES (5, 1, 2); 
INSERT INTO ordered_products VALUES (5, 8, 2); 
INSERT INTO ordered_products VALUES (5, 2, 2); 
INSERT INTO ordered_products VALUES (6, 7, 2); 
INSERT INTO ordered_products VALUES (6, 1, 2); 
INSERT INTO ordered_products VALUES (6, 2, 2); 
INSERT INTO ordered_products VALUES (6, 5, 2); 

-- 1. Да се извлече таблица с 2 колони - име на служител и продукт, който е продал

SELECT employees.name, products.name
FROM employees, products, orders, ordered_products
WHERE orders.employee_id = employees.id
	AND orders.id = ordered_products.order_id
	AND ordered_products.product_id = products.id

SELECT employees.name, products.name
FROM employees
	JOIN orders ON orders.employee_id = employee_id
	JOIN ordered_products ON orders.id = ordered_products.order_id
	JOIN products ON ordered_products.product_id = product_id
WHERE products.name = 'Jeans'

SELECT e.name, p.name
FROM employees e
	JOIN orders o ON o.employee_id = employee_id
	JOIN ordered_products op ON o.id = op.order_id
	JOIN products p ON op.product_id = product_id
WHERE p.name = 'Jeans'

-- 2. Имена на служители, които са работили с "Customer Two"

SELECT e.name, c.name, e.id, c.id
FROM orders o	
	JOIN customers c
		ON o.customer_id = c.id 
	JOIN employees e
		ON o.employee_id = e.id
WHERE c.name = 'Customer Two'

SELECT e.name, c.name, e.id, c.id
FROM employees e
	JOIN orders o	
		ON o.employee_id = e.id
	JOIN customers c
		ON o.customer_id = c.id 
WHERE c.name = 'Customer Two'

-- 3. Имена на служителите които са продали продукти на обща стойност на 600

SELECT e.id, SUM(p.price * op.number) as total
FROM employees e
	JOIN orders o ON o.employee_id = e.id
	JOIN ordered_products op ON o.id = op.order_id
	JOIN products p ON op.product_id = p.id
GROUP BY e.id
HAVING SUM(e.id) > 7

-- 4.
CREATE TABLE Seat (id int, isFree int);
INSERT INTO Seat VALUES(1, 0);
INSERT INTO Seat VALUES(2, 0);
INSERT INTO Seat VALUES(3, 1);
INSERT INTO Seat VALUES(4, 1);
INSERT INTO Seat VALUES(5, 0);
INSERT INTO Seat VALUES(6, 1);
INSERT INTO Seat VALUES(7, 1);
INSERT INTO Seat VALUES(8, 0);

/*
From | To
-----+------
2    | 3
5    | 7
*/

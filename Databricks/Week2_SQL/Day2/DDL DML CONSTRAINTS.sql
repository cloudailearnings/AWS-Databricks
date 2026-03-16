-- =========================================
-- Database: ecommerce
-- =========================================
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- =========================================
-- Table: products
-- =========================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT,
    product_code VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,

    -- Keys
    CONSTRAINT pk_products PRIMARY KEY (product_id),          -- Primary Key
    CONSTRAINT uq_product_code UNIQUE (product_code)          -- Unique / Alternate Key
);

-- =========================================
-- Table: orders
-- =========================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,

    -- Keys
    CONSTRAINT pk_orders PRIMARY KEY (order_id),               -- Primary Key
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id)      -- Foreign Key
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================
-- Sample Data: products
-- =========================================
INSERT INTO products (product_code, product_name, price, stock_quantity) VALUES
('P1001', 'Laptop', 75000.00, 10),
('P1002', 'Mouse', 500.00, 100),
('P1003', 'Keyboard', 1200.00, 50);

-- =========================================
-- Sample Data: orders
-- =========================================
INSERT INTO orders (product_id, order_date, quantity, total_amount) VALUES
(1, '2025-02-01', 1, 75000.00),
(2, '2025-02-02', 2, 1000.00),
(3, '2025-02-03', 1, 1200.00);

-- ON DELETE RESTRICT

DELETE FROM products WHERE product_id = 1;

-- ON UPDATE CASCADE

UPDATE products SET product_id = 10 WHERE product_id = 1;

select * from products;

select * from orders;

drop table products;

drop table orders;

-- composite key

-- One order can have multiple products -> order_id not unique by itself
-- Same product can appear in different orders -> product_id not unique by itself

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);

-- Child Table with Composite Primary Key

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    -- Composite Primary Key
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),

    -- Foreign Keys
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_oi_product FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
);

INSERT INTO orders VALUES (1, '2025-02-01');
INSERT INTO products VALUES (101, 'Laptop'), (102, 'Mouse');

INSERT INTO order_items VALUES
(1, 101, 1, 75000),
(1, 102, 2, 1000);

INSERT INTO order_items VALUES (1, 101, 1, 75000);
 
-- alternate key

CREATE TABLE products1 (
    product_id INT AUTO_INCREMENT PRIMARY KEY,   -- Primary Key

    product_code VARCHAR(20) NOT NULL,            -- Alternate Key
    product_name VARCHAR(100) NOT NULL,            -- Secondary Key
    category VARCHAR(50),
    price DECIMAL(10,2),

    CONSTRAINT uq_product_code UNIQUE (product_code)
);


drop table products;

drop table orders;

drop table order_items;

drop table products1;


-- other constraints

/*CHECK*/
 CREATE TABLE PERSONSS(ID VARCHAR(2)  PRIMARY KEY,NAME VARCHAR(20) NOT NULL,AGE INT CHECK (Age>=18));
 DESC PERSON;
 INSERT INTO PERSONSS(ID,NAME) VALUES('','ABC');
  
 INSERT INTO PERSON VALUES(4,'Robert',17),(5,'Joseph',18),(3,'Peter',20);
 
 SELECT * FROM PERSON;
 
 DESC PERSON;

DROP TABLE PERSON;

/*UNIQUE*/

CREATE TABLE SHIRTBRANDS(ID INT,BRANDNAME varchar(40) UNIQUE, SIZE INT);

SELECT * FROM SHIRTBRANDS;

INSERT INTO SHIRTBRANDS(ID,SIZE) VALUES(20,38),(40,40);

SELECT * FROM SHIRTBRANDS;

INSERT INTO SHIRTBRANDS VALUES(1,'Pantaloons',38);

DROP TABLE SHIRTBRANDS;

/* DEAFULT*/
CREATE TABLE PERSON12(ID int NOT NULL,NAME VARCHAR(20) NOT NULL,AGE INT,
CITY VARCHAR(20) UNIQUE DEFAULT 'ABC' );

 INSERT INTO PERSON1 VALUES(4,'Robert',17,'PUNE'),(5,'Joseph',19,'CHENNAI'),(3,'Peter',20,'KERALA');
 INSERT INTO PERSON12(ID,NAME,AGE) VALUES(7,'Robert',28),(8,'Joseph',19),(9,'Peter',20);
 
 SELECT * FROM PERSON1;
 
 DROP TABLE PERSON1;
 
 
 /* ENUM */

create table SHIRTS(ID INT primary KEY auto_increment, NAME VARCHAR(20) NOT NULL,
SIZE ENUM('small','medium','large','x-large'));

insert INTO SHIRTS(ID,NAME,SIZE) VALUES(10,'t-shirt','medium'),(20,'casual-shirt','small'),
(30,'formal','ABC');

select * from shirts;


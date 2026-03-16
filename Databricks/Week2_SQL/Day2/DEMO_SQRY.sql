USE SQRY;

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

INSERT INTO products (product_code, product_name, price, stock_quantity) VALUES
('P1001', 'Laptop', 75000.00, 10),
('P1002', 'Mouse', 500.00, 100),
('P1003', 'Keyboard', 1200.00, 50);

INSERT INTO orders (product_id, order_date, quantity, total_amount) VALUES
(1, '2025-02-01', 1, 75000.00),
(2, '2025-02-02', 2, 1000.00),
(3, '2025-02-03', 1, 1200.00);

SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM orders
);

-- Subquery with Comparison Operators

-- Product with highest price

SELECT product_name, price
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);

-- Subquery in SELECT clause (Scalar Subquery) -- Subquery returns one value per row

-- Show total orders count per product

SELECT
    product_name,
    (SELECT COUNT(*)
     FROM orders
     WHERE orders.product_id = products.product_id) AS order_count
FROM products;

-- Subquery in FROM clause (Derived Table)

-- Products with total sales

SELECT p.product_name, s.total_sales
FROM products p
JOIN (
    SELECT product_id, SUM(total_amount) AS total_sales
    FROM orders
    GROUP BY product_id
) s
ON p.product_id = s.product_id;

-- Correlated Subquery

-- Products ordered more than average quantity

SELECT DISTINCT product_id
FROM orders o
WHERE quantity > (
    SELECT AVG(quantity)
    FROM orders
    WHERE product_id = o.product_id
);

-- Subqueries with EXISTS

-- Products that have at least one order

SELECT product_name
FROM products p
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_id = p.product_id
);

-- Nested Subqueries

SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM orders
    WHERE total_amount > (
        SELECT AVG(total_amount)
        FROM orders
    )
);



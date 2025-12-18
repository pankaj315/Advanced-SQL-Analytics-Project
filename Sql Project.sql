-- 1) Advanced Queriying

-- 1. Write a query to find the top 5 customers with the highest total order amount.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date, order_amount)

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_amount) AS total_amount
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name
ORDER BY total_amount DESC
LIMIT 5;


-- 2. Retrieve the names of customers who have placed orders in the past 30 days.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date)

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_date >= CURRENT_DATE() - INTERVAL 30 DAY;


-- 3. Find the products that have been ordered at least three times.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, quantity)

SELECT 
    p.product_id,
    p.product_name,
    COUNT(oi.order_id) AS order_count
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
GROUP BY 
    p.product_id,
    p.product_name
HAVING COUNT(oi.order_id) >= 3;


-- 4. Retrieve the order details for orders placed by customers from a specific city.
-- Dataset: Customers (customer_id, customer_name, city), Orders (order_id, customer_id, order_date), 
-- Order_Details (order_id, product_id, quantity)

SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    od.product_id,
    o.order_date,
    od.quantity
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
WHERE c.city = 'city_name';


-- 5. Write a query to find the customers who have placed orders for products with a price greater than $100.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date), 
-- Products (product_id, product_name, price), Order_Details (order_id, product_id, quantity)

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN products p 
    ON od.product_id = p.product_id
WHERE p.price > 100;


-- 6. Get the average order amount for each customer.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date, order_amount)

SELECT 
    c.customer_id,
    c.customer_name,
    AVG(o.order_amount) AS avg_amount
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name;


-- 7. Find the products that have never been ordered.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, quantity)

SELECT 
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- 8. Retrieve the names of customers who have placed orders on weekends (Saturday or Sunday).
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date)

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE DAYOFWEEK(o.order_date) IN (1, 7);


-- 9. Get the total order amount for each month.
-- Dataset: Orders (order_id, order_date, order_amount)

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month_of_year,
    SUM(order_amount) AS total_amount
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month_of_year;


-- 10. Find the customers who have placed orders for more than two different products.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date),
-- Order_Items (order_id, product_id, quantity)

SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT oi.product_id) AS product_count
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT oi.product_id) > 2;


-----------------------------------------------------------------------------------------------------------------------


-- 2) Joins

-- 1. Retrieve the order details along with the customer name and product name for each order.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date), 
-- Order_Items (order_id, product_id, quantity), Products (product_id, product_name, supplier_id)

SELECT 
    c.customer_name,
    o.order_id,
    p.product_name,
    o.order_date,
    oi.quantity
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id;


-- 2. Find the products and their corresponding suppliers' names.
-- Dataset: Products (product_id, product_name, supplier_id), Suppliers (supplier_id, supplier_name)

SELECT 
    p.product_name,
    s.supplier_name
FROM 
    products p
    JOIN suppliers s ON p.supplier_id = s.supplier_id;


-- 3. Get a list of customers who have never placed an order.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id)

SELECT 
    c.customer_id,
    c.customer_name
FROM 
    customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL;


-- 4. Retrieve the names of customers along with the total quantity of products they ordered.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id), Order_Items (order_id, product_id, quantity)

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity) AS total_quantity
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id,
    c.customer_name;


-- 5. Find the products that have been ordered by customers from a specific country.
-- Dataset: Products (product_id, product_name), Orders (order_id, customer_id), 
-- Order_Items (order_id, product_id, quantity), Customers (customer_id, country)

SELECT 
    c.customer_id,
    p.product_id,
    p.product_name
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
WHERE 
    c.country = "country_name";


-- 6. Get the total order amount for each customer, including those who have not placed any orders.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_amount)

SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(o.order_amount), 0) AS total_order_amount
FROM 
    customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name;


-- 7. Retrieve the order details for orders placed by customers with a specific occupation.
-- Dataset: Customers (customer_id, customer_name, occupation), Orders (order_id, customer_id, order_date),
-- Order_Items (order_id, product_id, quantity)

SELECT 
    o.order_id,
    oi.product_id,
    oi.quantity,
    o.order_date
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE 
    c.occupation = "occupation";


-- 8. Find the customers who have placed orders for products with a price higher than the average price of all products.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date)
-- Products (product_id, product_name, price), Order_Items (order_id, product_id, quantity)

SELECT 
    c.customer_id,
    c.customer_name
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
WHERE 
    p.price > (SELECT AVG(price) FROM products);


-- 9. Retrieve the names of customers along with the total number of orders they have placed.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id)

SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name;


-- 10. Get a list of products and the total quantity ordered for each product.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, quantity)

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_ordered
FROM 
    products p
    JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id,
    p.product_name;
    

-----------------------------------------------------------------------------------------------------------------


-- 3) Advanced filtering and sorting

-- 1. Retrieve all customers with names starting with 'A' and ending with 'n'.
-- Dataset: Customers (customer_id, customer_name)

SELECT 
    customer_id,
    customer_name
FROM 
    customers
WHERE 
    customer_name LIKE 'A%n';


-- 2. Find the products with names containing at least one digit.
-- Dataset: Products (product_id, product_name)

SELECT 
    product_id,
    product_name
FROM 
    products
WHERE 
    product_name REGEXP '[0-9]';


-- 3. Get the list of employees sorted by their salary in ascending order. NULL values should appear at the end.
-- Dataset: Employees (employee_id, employee_name, salary)

SELECT 
    employee_id,
    employee_name,
    salary
FROM 
    employees
ORDER BY 
    salary IS NULL,
    salary ASC;


-- 4. Retrieve the customers whose names contain exactly five characters.
-- Dataset: Customers (customer_id, customer_name)

SELECT 
    customer_id,
    customer_name
FROM 
    customers
WHERE 
    customer_name LIKE '_____';


-- 5. Find the products with names starting with 'S' and ending with 'e'.
-- Dataset: Products (product_id, product_name)

SELECT 
    product_id,
    product_name
FROM 
    products
WHERE 
    product_name LIKE 'S%e';


-- 6. Get the list of employees sorted by their last name and then by their first name.
-- Dataset: Employees (employee_id, first_name, last_name, salary)

SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM 
    employees
ORDER BY 
    last_name,
    first_name;


-- 7. Retrieve the orders placed on a specific date and sort them by the customer name alphabetically.
-- Dataset: Orders (order_id, order_date, customer_id), Customers (customer_id, customer_name)

SELECT 
    c.customer_name,
    o.order_id,
    o.order_date
FROM 
    orders o
    JOIN customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_date = 'specific_date'
ORDER BY 
    c.customer_name;


-- 8. Find the products with names containing exactly three letters.
-- Dataset: Products (product_id, product_name)

SELECT 
    product_id,
    product_name
FROM 
    products
WHERE 
    product_name LIKE '___';


-- 9. Get the list of employees sorted by their salary in descending order. NULL values should appear at the beginning.
-- Dataset: Employees (employee_id, employee_name, salary)

SELECT 
    employee_id,
    employee_name,
    salary
FROM 
    employees
ORDER BY 
    salary IS NOT NULL,
    salary DESC;


-- 10. Retrieve the customers whose names contain a space character.
-- Dataset: Customers (customer_id, customer_name)

SELECT 
    customer_id,
    customer_name
FROM 
    customers
WHERE 
    customer_name LIKE '% %';


------------------------------------------------------------------------------------------------------------------


-- 4) Aggregations and Groupings

-- 1. Calculate the total quantity and total amount for each order.
-- Dataset: Orders (order_id, order_date), Order_Items (order_id, product_id, quantity, amount)

SELECT 
    o.order_id,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.amount) AS total_amount
FROM 
    orders o
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id;


-- 2. Find the average age and the number of employees for each job title.
-- Dataset: Employees (employee_id, employee_name, age, job_title)

SELECT 
    job_title,
    AVG(age) AS avg_age,
    COUNT(DISTINCT employee_id) AS employee_count
FROM 
    employees
GROUP BY 
    job_title;


-- 3. Get the total number of products in each category.
-- Dataset: Products (product_id, product_name, category_id), Categories (category_id, category_name)

SELECT 
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM 
    categories c
    LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY 
    c.category_id,
    c.category_name;


-- 4. Calculate the average rating and the number of reviews for each product.
-- Dataset: Products (product_id, product_name), Reviews (product_id, rating)

SELECT 
    p.product_id,
    p.product_name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.rating) AS reviews_count
FROM 
    products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY 
    p.product_id,
    p.product_name;


-- 5. Find the customers with the highest and lowest total order amounts.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_amount)

WITH totals AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.order_amount) AS total_amount
    FROM 
        customers c
        JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id,
        c.customer_name
),
ranked AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY total_amount ASC) AS low_rank,
        RANK() OVER (ORDER BY total_amount DESC) AS high_rank
    FROM 
        totals
)
SELECT 
    customer_id,
    customer_name,
    total_amount
FROM 
    ranked
WHERE 
    low_rank = 1 OR high_rank = 1;


-- 6. Get the maximum and minimum ages for each department.
-- Dataset: Employees (employee_id, employee_name, age, department)

SELECT 
    department,
    MIN(age) AS min_age,
    MAX(age) AS max_age
FROM 
    employees
GROUP BY 
    department;


-- 7. Calculate the total sales amount and the number of orders for each month.
-- Dataset: Orders (order_id, order_date, order_amount)

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month_in_year,
    SUM(order_amount) AS total_amount,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 
    month_in_year;


-- 8. Find the average price and the number of products for each supplier.
-- Dataset: Products (product_id, product_name, price, supplier_id), Suppliers (supplier_id, supplier_name)

SELECT 
    s.supplier_id,
    s.supplier_name,
    AVG(p.price) AS avg_price,
    COUNT(p.product_id) AS products_count
FROM 
    products p
    JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY 
    s.supplier_id,
    s.supplier_name;


-- 9. Get the maximum and minimum prices for each product category.
-- Dataset: Products (product_id, product_name, price, category_id), Categories (category_id, category_name)

SELECT 
    c.category_id,
    c.category_name,
    MAX(p.price) AS max_price,
    MIN(p.price) AS min_price
FROM 
    products p
    JOIN categories c ON p.category_id = c.category_id
GROUP BY 
    c.category_id,
    c.category_name;


-- 10. Calculate the average rating and the number of reviews for each product category.
-- Dataset: Products (product_id, product_name, category_id), Reviews (product_id, rating)

SELECT 
    p.category_id,
    AVG(r.rating) AS avg_rating,
    COUNT(r.rating) AS reviews_count
FROM 
    products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY 
    p.category_id;
    
    
--------------------------------------------------------------------------------------------------------------------


-- 5) Advanced Data Manipulation

-- 1. Increase the salary of all employees by 10%.
-- Dataset: Employees (employee_id, employee_name, salary)

UPDATE 
    employees 
SET 
    salary = salary * 1.10;


-- 2. Delete all orders older than 1 year and their associated order items.
-- Dataset: Orders (order_id, order_date), Order_Items (order_id, product_id, quantity)

DELETE oi
FROM 
    order_items oi
    JOIN orders o ON oi.order_id = o.order_id
WHERE 
    o.order_date < DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);


-- 3. Insert a new category and update all products of a specific category to the new category in a single transaction.
-- Dataset: Categories (category_id, category_name), Products (product_id, product_name, category_id)

START TRANSACTION;

INSERT INTO 
    categories (category_id, category_name)
VALUES 
    (101, 'category_name');

UPDATE 
    products 
SET 
    category_id = 101 
WHERE 
    category_id = 1;

COMMIT;


-- 4. Update the discount percentage for all products in a specific price range.
-- Dataset: Products (product_id, product_name, price, discount_percentage)

UPDATE 
    products 
SET 
    discount_percentage = 20 
WHERE 
    price BETWEEN 100 AND 200;


-- 5. Delete all reviews with a rating lower than 3.
-- Dataset: Reviews (product_id, rating, review_text)

DELETE FROM 
    reviews 
WHERE 
    rating < 3;


-- 6. Insert a new customer along with their orders and order items in a single transaction.
-- Dataset: Customers, Orders, Order_Items

START TRANSACTION;

INSERT INTO 
    Customers (customer_id, customer_name) 
VALUES 
    (501, 'New Customer');

INSERT INTO 
    Orders (order_id, customer_id, order_date) 
VALUES 
    (9001, 501, CURDATE());

INSERT INTO 
    Order_Items (order_id, product_id, quantity) 
VALUES 
    (9001, 101, 2),
    (9001, 205, 1);

COMMIT;


-- 7. Increase the salary of all employees in a specific department by 15%.
-- Dataset: Employees (employee_id, employee_name, salary, department)

UPDATE 
    employees 
SET 
    salary = salary * 1.15 
WHERE 
    department = 'department_name';


-- 8. Delete all products that have not been ordered.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, quantity)

DELETE p
FROM 
    products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.product_id IS NULL;


-- 9. Insert a new supplier and their products, ensuring all records are inserted or none at all (transaction).
-- Dataset: Suppliers (supplier_id, supplier_name), Products (product_id, product_name, supplier_id)

START TRANSACTION;

INSERT INTO 
    Suppliers (supplier_id, supplier_name) 
VALUES 
    (3001, 'New Supplier');

INSERT INTO 
    Products (product_id, product_name, supplier_id) 
VALUES 
    (8001, 'Product A', 3001),
    (8002, 'Product B', 3001),
    (8003, 'Product C', 3001);

COMMIT;


-- 10. Update the order dates for all orders placed on weekends to the following Monday.
-- Dataset: Orders (order_id, order_date)

UPDATE 
    Orders 
SET 
    order_date = 
        CASE
            WHEN DAYOFWEEK(order_date) = 7 THEN DATE_ADD(order_date, INTERVAL 2 DAY)
            WHEN DAYOFWEEK(order_date) = 1 THEN DATE_ADD(order_date, INTERVAL 1 DAY)
        END
WHERE 
    DAYOFWEEK(order_date) IN (1, 7);
    

------------------------------------------------------------------------------------------------------------------


-- 6) Advanced Database Concepts

-- 1. Create a view to display the total sales amount for each product.
-- Dataset: Products(product_id, product_name), Order_Items(order_id, product_id, quantity, amount)

CREATE VIEW total_sales AS
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.amount) AS total_amount
FROM 
    products p
    JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id,
    p.product_name;


-- 2. Create a view to display average rating + number of reviews per product.
-- Dataset: Products(product_id, product_name), Reviews(product_id, rating)

CREATE VIEW product_review_summary AS
SELECT 
    p.product_id,
    p.product_name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.rating) AS review_count
FROM 
    products p
    JOIN reviews r ON p.product_id = r.product_id
GROUP BY 
    p.product_id,
    p.product_name;


-- 3. Create view to display average salary for each department.
-- Dataset: Employees(employee_id, employee_name, salary, department)

CREATE VIEW department_sal_avg AS
SELECT 
    department,
    AVG(salary) AS avg_salary
FROM 
    employees
GROUP BY 
    department;


-- 4. Create a view to display the total order amount for each customer.
-- Dataset: Customers(customer_id, customer_name), Orders(order_id, customer_id, order_amount)

CREATE VIEW customer_total_order AS
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_amount) AS total_order_amount
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name;
    
    
-----------------------------------------------------------------------------------------------------------------------


-- 7) Advanced SQL Functions

-- 1. Retrieve the top 3 customers based on their total order amounts, and 
-- calculate the percentage of each customer's order amount compared to the total.
-- Dataset: Customers(customer_id, customer_name), Orders(order_id, customer_id, order_amount)

WITH customer_total AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.order_amount) AS total_amount
    FROM 
        customers c
        JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id,
        c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    total_amount,
    ROUND((total_amount / SUM(total_amount) OVER()) * 100, 2) AS percentage_contribution
FROM 
    customer_total 
ORDER BY 
    total_amount DESC 
LIMIT 3;


-- 2. Create a stored procedure to update the salary of an employee and log the change in a separate table
-- Dataset: Employees(employee_id, employee_name, salary), Salary_Log(log_id, employee_id, old_salary, new_salary, modified_date)

DELIMITER $$

CREATE PROCEDURE update_salary(
    IN p_employee_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN 
    DECLARE p_old_salary DECIMAL(10,2);
    
    SELECT 
        salary 
    INTO 
        p_old_salary 
    FROM 
        employees 
    WHERE 
        employee_id = p_employee_id;
    
    UPDATE 
        employees 
    SET 
        salary = p_new_salary 
    WHERE 
        employee_id = p_employee_id;
    
    INSERT INTO 
        salary_log(employee_id, old_salary, new_salary, modified_date) 
    VALUES 
        (p_employee_id, p_old_salary, p_new_salary, NOW());
END $$

DELIMITER ;


-- 3. Calculate the average rating for each product and assign a rank based on the rating using a window function.
-- Dataset: Products(product_id, product_name), Ratings(product_id, rating)

WITH rating_avg AS (
    SELECT 
        p.product_id,
        p.product_name,
        AVG(r.rating) AS avg_rating 
    FROM 
        products p
        JOIN ratings r ON p.product_id = r.product_id
    GROUP BY 
        p.product_id,
        p.product_name
)
SELECT 
    product_id,
    product_name,
    avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank 
FROM 
    rating_avg;


-- 4. Implement a stored procedure to insert a new order along with its order items into the database.
-- Dataset: Orders(order_id, order_date), Order_Items(order_id, product_id, quantity, amount)

DELIMITER $$

CREATE PROCEDURE new_order_items(
    IN p_order_id INT,
    IN p_order_date DATE,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_amount INT
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO 
        orders(order_id, order_date) 
    VALUES 
        (p_order_id, p_order_date);
    
    INSERT INTO 
        order_items(order_id, product_id, quantity, amount) 
    VALUES 
        (p_order_id, p_product_id, p_quantity, p_amount);
    
    COMMIT;
END $$

DELIMITER ;


-- 5. Retrieve the top 5 products based on the cumulative sales amount using a window function.
-- Dataset: Products(product_id, product_name), Order_Items(order_id, product_id, quantity, amount)

WITH product_totals AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(oi.amount) AS total_sales 
    FROM 
        products p
        JOIN order_items oi ON p.product_id = oi.product_id 
    GROUP BY 
        p.product_id,
        p.product_name
),
cumulative_sales AS (
    SELECT 
        product_id,
        product_name,
        total_sales,
        SUM(total_sales) OVER (
            ORDER BY total_sales DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_amount 
    FROM 
        product_totals
)
SELECT 
    product_id,
    product_name,
    total_sales,
    cumulative_amount 
FROM 
    cumulative_sales 
ORDER BY 
    total_sales DESC 
LIMIT 5;


-- 6. Create a stored procedure to calculate the total order amount for a specific customer and return the result.
-- Dataset: Customers(customer_id, customer_name), Orders(order_id, customer_id, order_amount)

DELIMITER $$

CREATE PROCEDURE total_order(
    IN p_customer_id INT,
    OUT p_total_amount DECIMAL(10,2)
)
BEGIN
    SELECT 
        SUM(order_amount) 
    INTO 
        p_total_amount 
    FROM 
        Orders 
    WHERE 
        customer_id = p_customer_id;
END $$

DELIMITER ;


-- 7. Calculate the average rating for each product category and assign a rank based on the rating using a window function.
-- Dataset: Products(product_id, product_name, category_id), Ratings(product_id, rating), Categories(category_id, category_name)

SELECT 
    c.category_id,
    c.category_name,
    AVG(r.rating) AS avg_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rating_rank 
FROM 
    categories c
    JOIN products p ON c.category_id = p.category_id 
    JOIN ratings r ON p.product_id = r.product_id
GROUP BY 
    c.category_id,
    c.category_name 
ORDER BY 
    rating_rank DESC;


-- 8. Implement a stored procedure to delete a customer and all associated orders and order items from the database.
-- Dataset: Customers(customer_id, customer_name), Orders(order_id, customer_id), Order_Items(order_id, product_id, quantity)

DELIMITER $$

CREATE PROCEDURE delete_customer(
    IN p_customer_id INT
)
BEGIN
    START TRANSACTION;
    
    DELETE oi 
    FROM 
        order_items oi
        JOIN orders o ON oi.order_id = o.order_id 
    WHERE 
        o.customer_id = p_customer_id;
    
    DELETE FROM 
        orders 
    WHERE 
        customer_id = p_customer_id;
    
    DELETE FROM 
        customers 
    WHERE 
        customer_id = p_customer_id;
    
    COMMIT;
END $$

DELIMITER ;


-- 9. Retrieve the top 3 employees based on their total sales amounts using a window function.
-- Dataset: Employees(employee_id, employee_name), Orders(order_id, employee_id, order_amount)

WITH order_details AS (
    SELECT 
        e.employee_id,
        e.employee_name,
        SUM(o.order_amount) AS total_sales 
    FROM 
        employees e
        JOIN orders o ON e.employee_id = o.employee_id 
    GROUP BY 
        e.employee_id,
        e.employee_name
),
employee_rank AS (
    SELECT 
        employee_id,
        employee_name,
        total_sales,
        DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_rank 
    FROM 
        order_details
)
SELECT 
    sales_rank,
    employee_id,
    employee_name,
    total_sales 
FROM 
    employee_rank 
WHERE 
    sales_rank <= 3;


-- 10. Create a stored procedure to update the quantity in stock for a specific product and log the change in a separate table.
-- Dataset: Products(product_id, product_name, quantity_in_stock),
-- Stock_Log(log_id, product_id, old_quantity, new_quantity, modified_date)

DELIMITER $$

CREATE PROCEDURE update_stock(
    IN p_product_id INT,
    IN p_new_quantity INT
)
BEGIN
    DECLARE p_old_quantity INT;
    
    SELECT 
        quantity_in_stock 
    INTO 
        p_old_quantity 
    FROM 
        products 
    WHERE 
        product_id = p_product_id;
    
    UPDATE 
        products 
    SET 
        quantity_in_stock = p_new_quantity 
    WHERE 
        product_id = p_product_id;
    
    INSERT INTO 
        stock_log(product_id, old_quantity, new_quantity, modified_date)
    VALUES 
        (p_product_id, p_old_quantity, p_new_quantity, NOW());
END $$

DELIMITER ;


-- --------------------------------------------------------------------------------------------------------


-- 8) SQL Performance Optimization

-- 1. Optimize a query that retrieves customer details along with their total order amounts for a specific date range.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date, order_amount)

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_amount) AS total_amount
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    c.customer_id,
    c.customer_name;


-- 2. Identify and eliminate unnecessary joins in a query that retrieves product details and their corresponding categories.
-- Dataset: Products (product_id, product_name, category_id), Categories (category_id, category_name)

SELECT 
    p.product_id,
    p.product_name,
    c.category_name
FROM 
    products p
    JOIN categories c ON p.category_id = c.category_id;


-- 3. Rewrite a subquery as a join in a query that retrieves the order details along with the customer names for all orders.
-- Dataset: Orders (order_id, customer_id, order_date), Customers (customer_id, customer_name)

SELECT 
    o.order_id,
    o.order_date,
    c.customer_name
FROM 
    orders o
    JOIN customers c ON o.customer_id = c.customer_id;


-- 4. Identify and eliminate redundant joins in a query that retrieves employee details along with their department information.
-- Dataset: Employees (employee_id, employee_name, department_id), Departments (department_id, department_name)

SELECT 
    e.employee_id,
    e.employee_name,
    d.department_id,
    d.department_name
FROM 
    employees e
    JOIN departments d ON e.department_id = d.department_id;


-- 5. Rewrite a subquery as a join in a query that retrieves the names of customers who have placed at least two orders.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id)

SELECT 
    c.customer_id,
    c.customer_name
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name
HAVING 
    COUNT(o.order_id) >= 2;


-- 6. Identify and eliminate unnecessary joins in a query that retrieves product details and their corresponding suppliers' names.
-- Dataset: Products (product_id, product_name, supplier_id), Suppliers (supplier_id, supplier_name)

SELECT 
    p.product_id,
    p.product_name,
    s.supplier_name
FROM 
    products p
    JOIN suppliers s ON p.supplier_id = s.supplier_id;


-- 7. Rewrite a subquery as a join in a query that retrieves the names of customers who have placed orders in the past 30 days.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_date)

SELECT 
    DISTINCT c.customer_name
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_date >= CURDATE() - INTERVAL 30 DAY;
    
    
------------------------------------------------------------------------------------------------------------


-- 9) Advanced SQL Techniques

-- 1. Use a common table expression to calculate the running total of order amounts for each customer.
-- Dataset: Customers (customer_id, customer_name), Orders (order_id, customer_id, order_amount)

WITH customer_order_amount AS (
    SELECT 
        c.customer_id,
        o.order_amount,
        SUM(o.order_amount) OVER (
            PARTITION BY c.customer_id 
            ORDER BY o.order_id 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total
    FROM 
        customers c
        JOIN orders o ON c.customer_id = o.customer_id
)
SELECT 
    customer_id,
    running_total
FROM 
    customer_order_amount
ORDER BY 
    customer_id;


-- 2. Apply window functions to calculate the average rating and the maximum rating for each product.
-- Dataset: Products (product_id, product_name), Ratings (product_id, rating)

SELECT 
    p.product_id,
    p.product_name,
    AVG(r.rating) OVER (PARTITION BY p.product_id) AS avg_rating,
    MAX(r.rating) OVER (PARTITION BY p.product_id) AS max_rating
FROM 
    products p
    JOIN ratings r ON p.product_id = r.product_id;


-- 3. Use a common table expression to calculate the cumulative sum of quantities for each product.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, quantity)

WITH cumulative_quantities AS (
    SELECT 
        p.product_id,
        p.product_name,
        oi.quantity,
        SUM(oi.quantity) OVER (
            PARTITION BY p.product_id 
            ORDER BY oi.order_id 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_sum
    FROM 
        products p
        JOIN order_items oi ON p.product_id = oi.product_id
)
SELECT 
    product_id,
    product_name,
    quantity,
    cumulative_sum
FROM 
    cumulative_quantities;


-- 4. Apply window functions to calculate the minimum and maximum order amounts for each month.
-- Dataset: Orders (order_id, order_date, order_amount)

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    MIN(order_amount) OVER (
        PARTITION BY YEAR(order_date), MONTH(order_date)
    ) AS min_order,
    MAX(order_amount) OVER (
        PARTITION BY YEAR(order_date), MONTH(order_date)
    ) AS max_order
FROM 
    orders;


-- 5. Use a common table expression to calculate the average rating and the number of reviews for each product.
-- Dataset: Products (product_id, product_name), Reviews (product_id, rating)

WITH product_reviews AS (
    SELECT 
        p.product_id,
        p.product_name,
        AVG(r.rating) AS avg_rating,
        COUNT(r.rating) AS review_count
    FROM 
        products p
        JOIN reviews r ON p.product_id = r.product_id
    GROUP BY 
        p.product_id,
        p.product_name
)
SELECT 
    product_id,
    product_name,
    avg_rating,
    review_count
FROM 
    product_reviews;


-- 6. Apply window functions to calculate the rank and dense rank of sales amounts for each product.
-- Dataset: Products (product_id, product_name), Order_Items (order_id, product_id, amount)

WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(oi.amount) AS total_sales
    FROM 
        products p
        JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.product_id,
        p.product_name
)
SELECT 
    product_id,
    product_name,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_dense_rank
FROM 
    product_sales;








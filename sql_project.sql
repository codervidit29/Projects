-- =======================================================
-- 1. Employee Information Analysis (SQL)
-- =======================================================

-- Create the employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    role VARCHAR(50)
);

-- Insert example data into employees table
INSERT INTO employees (emp_id, name, dept_id, salary, role) 
VALUES 
    (1, 'Alice', 101, 50000, 'Developer'),
    (2, 'Bob', 102, 60000, 'Manager'),
    (3, 'Charlie', 101, 45000, 'Tester');

-- Create the archived_employees table
CREATE TABLE archived_employees (
    emp_id INT,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    role VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to archive deleted records
CREATE TRIGGER archive_employee 
AFTER DELETE ON employees
FOR EACH ROW
INSERT INTO archived_employees (emp_id, name, dept_id, salary, role)
VALUES (OLD.emp_id, OLD.name, OLD.dept_id, OLD.salary, OLD.role);

-- Delete an employee and check archiving
DELETE FROM employees WHERE emp_id = 2;
SELECT * FROM archived_employees;

-- Stored Procedure to fetch employee details
DELIMITER $$
CREATE PROCEDURE GetEmployeeDetails(IN emp_id INT)
BEGIN
    SELECT * FROM employees WHERE emp_id = emp_id;
END$$
DELIMITER ;

-- Calling the stored procedure for employee with emp_id = 1
CALL GetEmployeeDetails(1);

-- Index for optimization
CREATE INDEX idx_dept_id ON employees(dept_id);

-- Query using the optimized index
SELECT * FROM employees WHERE dept_id = 101;

-- =======================================================
-- 2. Sales Insights and Reporting System (SQL)
-- =======================================================

-- Create sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity INT,
    total_amount DECIMAL(10, 2)
);

-- Insert example data into sales table
INSERT INTO sales (sale_id, product_id, sale_date, quantity, total_amount)
VALUES 
    (1, 101, '2025-01-01', 10, 1000),
    (2, 102, '2025-01-02', 5, 500),
    (3, 101, '2025-02-01', 7, 700);

-- Stored Procedure for monthly sales report
DELIMITER $$
CREATE PROCEDURE MonthlySalesReport(IN month INT, IN year INT)
BEGIN
    SELECT 
        MONTH(sale_date) AS Month, 
        YEAR(sale_date) AS Year, 
        SUM(total_amount) AS TotalSales
    FROM sales
    WHERE MONTH(sale_date) = month AND YEAR(sale_date) = year
    GROUP BY MONTH(sale_date), YEAR(sale_date);
END$$
DELIMITER ;

-- Calling the monthly sales report for January 2025
CALL MonthlySalesReport(1, 2025);

-- Create a sales log table to track changes
CREATE TABLE sales_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    action VARCHAR(10),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log changes in sales table
CREATE TRIGGER log_sales_changes
AFTER UPDATE ON sales
FOR EACH ROW
INSERT INTO sales_log (sale_id, action) VALUES (NEW.sale_id, 'UPDATE');

-- Update a sale and check the log
UPDATE sales SET total_amount = 1200 WHERE sale_id = 1;
SELECT * FROM sales_log;

-- =======================================================
-- 3. Inventory Management System (SQL)
-- =======================================================

-- Create inventory table
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    supplier_id INT,
    stock_level INT,
    reorder_point INT
);

-- Insert example data into inventory table
INSERT INTO inventory (product_id, product_name, supplier_id, stock_level, reorder_point)
VALUES 
    (1, 'Laptop', 201, 20, 10),
    (2, 'Mouse', 202, 5, 10),
    (3, 'Keyboard', 203, 15, 5);

-- Query to find products that need to be reordered
SELECT product_name, stock_level
FROM inventory
WHERE stock_level < reorder_point;

-- Create a view to get active inventory
CREATE VIEW active_inventory AS
SELECT product_id, product_name, stock_level
FROM inventory
WHERE stock_level > 0;

-- Query using the active_inventory view
SELECT * FROM active_inventory;

-- =======================================================
-- 4. Electronic Store Monthly Sales Analysis (Python & SQL)
-- =======================================================

-- Query to analyze total sales and quantity by product
SELECT 
    product_id, 
    SUM(quantity) AS total_quantity,
    SUM(total_amount) AS total_sales
FROM sales
GROUP BY product_id;

-- Example result:
-- product_id | total_quantity | total_sales
--   101      |       17       |    1700
--   102      |        5       |     500

-- Python Code for visualization (Use Python environment like Jupyter)
import pandas as pd
import matplotlib.pyplot as plt

# Mock Data for Product Sales
data = {'product_id': [101, 102],
        'total_sales': [1700, 500]}
df = pd.DataFrame(data)

# Bar plot visualization for product sales
plt.bar(df['product_id'], df['total_sales'])
plt.title('Total Sales by Product ID')
plt.xlabel('Product ID')
plt.ylabel('Total Sales')
plt.show();

-- =======================================================
-- 5. Customer Feedback Analysis (SQL)
-- =======================================================

-- Create customer feedback table
CREATE TABLE customer_feedback (
    feedback_id INT PRIMARY KEY,
    customer_id INT,
    feedback_text TEXT,
    feedback_date DATE
);

-- Insert example data into feedback table
INSERT INTO customer_feedback (feedback_id, customer_id, feedback_text, feedback_date)
VALUES 
    (1, 101, 'Excellent product quality!', '2025-01-01'),
    (2, 102, 'Bad customer service!', '2025-01-02'),
    (3, 103, 'Average experience.', '2025-01-03');

-- Categorize feedback based on keywords
SELECT 
    feedback_id,
    CASE
        WHEN feedback_text LIKE '%excellent%' THEN 'Positive'
        WHEN feedback_text LIKE '%bad%' THEN 'Negative'
        ELSE 'Neutral'
    END AS feedback_category
FROM customer_feedback;

-- Example result:
-- feedback_id | feedback_category
--     1       |     Positive
--     2       |     Negative
--     3       |     Neutral

-- =======================================================
-- 6. E-Commerce Sales Dashboard (Power BI & SQL)
-- =======================================================

-- Create sales table for e-commerce data
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    region VARCHAR(50),
    total_amount DECIMAL(10, 2)
);

-- Insert example data into sales table
INSERT INTO sales (sale_id, product_id, sale_date, region, total_amount)
VALUES 
    (1, 101, '2025-01-01', 'North', 1000),
    (2, 102, '2025-01-02', 'South', 500),
    (3, 101, '2025-02-01', 'North', 700);

-- Query to summarize total sales by region
SELECT 
    region,
    SUM(total_amount) AS total_sales
FROM sales
GROUP BY region;

-- Example result:
-- region | total_sales
-- North  |    1700
-- South  |     500


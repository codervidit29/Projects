-- Transaction Block
START TRANSACTION;

-- Creating the EmployeesInformation Table
CREATE TABLE EmployeesInformation (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    `role` VARCHAR(50) -- Escaped the `role` keyword
);

SAVEPOINT savepoint1;

-- Inserting records into EmployeesInformation
INSERT INTO EmployeesInformation (emp_id, name, dept_id, salary, `role`)
VALUES
(1, 'Alice Johnson', 101, 75000.00, 'Software Engineer'),
(2, 'Bob Smith', 102, 62000.00, 'Data Analyst'),
(3, 'Carol White', 103, 80000.00, 'Product Manager'),
(4, 'David Brown', 101, 72000.00, 'UI/UX Designer'),
(5, 'Eve Davis', 102, 68000.00, 'Data Scientist'),
(6, 'Frank Harris', 104, 85000.00, 'Marketing Director'),
(7, 'Grace Wilson', 105, 70000.00, 'Sales Manager'),
(8, 'Henry Clark', 106, 65000.00, 'HR Specialist'),
(9, 'Ivy Lewis', 103, 77000.00, 'Business Analyst'),
(10, 'Jack Robinson', 104, 72000.00, 'Operations Manager');

SAVEPOINT savepoint2;

-- Viewing records from EmployeesInformation
SELECT * FROM EmployeesInformation;

-- Stored Procedure
DELIMITER //

CREATE PROCEDURE GetEmployeeByTheirID(IN empId INT) -- Corrected procedure name
BEGIN 
    SELECT * FROM EmployeesInformation WHERE emp_id = empId;
END //

DELIMITER ;

SAVEPOINT savepoint3;

-- Calling the Stored Procedure
CALL GetEmployeeByTheirID(6);

-- Creating a View
CREATE VIEW GetEmployees AS 
   SELECT emp_id, name, dept_id, salary
   FROM EmployeesInformation
   WHERE salary > 50000;

SAVEPOINT savepoint4;

-- Viewing the records from the created View
SELECT * FROM GetEmployees;

-- Creating a deleted_records table for the Trigger
CREATE TABLE deleted_records(
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    `role` VARCHAR(50) -- Escaped `role`
);

DELIMITER //

-- Creating a Trigger to insert deleted records
CREATE TRIGGER after_employee_delete
AFTER DELETE ON EmployeesInformation
FOR EACH ROW
BEGIN
    INSERT INTO deleted_records (emp_id, name, dept_id, salary, `role`)
    VALUES (OLD.emp_id, OLD.name, OLD.dept_id, OLD.salary, OLD.`role`);
END //

DELIMITER ;

SAVEPOINT savepoint6;

-- Deleting a record and activating the trigger
DELETE FROM EmployeesInformation WHERE emp_id = 9;

-- Viewing the deleted records
SELECT * FROM deleted_records;

-- Showing all the triggers
SHOW TRIGGERS;

-- Commit the transaction at the end
COMMIT;

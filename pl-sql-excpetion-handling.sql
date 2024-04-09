-- Drop the EMPLOYEES table
DROP TABLE EMPLOYEES;

-- Drop the insert_employee procedure
DROP PROCEDURE insert_employee;

-- Create the EMPLOYEES table
CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID   NUMBER PRIMARY KEY,
    NAME          VARCHAR2(100),
    AGE           NUMBER,
    DEPARTMENT    VARCHAR2(100)
);


-- Procedure to insert a new employee into the EMPLOYEES table
CREATE OR REPLACE PROCEDURE insert_employee(
    p_employee_id   IN    EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_name          IN    EMPLOYEES.NAME%TYPE,
    p_age           IN    EMPLOYEES.AGE%TYPE,
    p_department    IN    EMPLOYEES.DEPARTMENT%TYPE
)
IS
BEGIN
    -- Attempt to insert the new employee record
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, NAME, AGE, DEPARTMENT)
    VALUES (p_employee_id, p_name, p_age, p_department);

    -- Commit the transaction if the insertion is successful
    COMMIT;
    
    -- Output success message
    DBMS_OUTPUT.PUT_LINE('Employee inserted successfully.');
EXCEPTION
    -- Catch exception if the insertion fails due to duplicate employee ID
    WHEN DUP_VAL_ON_INDEX THEN
        -- Output error message
        DBMS_OUTPUT.PUT_LINE('Error: Duplicate employee ID. Please choose a different ID.');

    -- Catch exception if any other error occurs
    WHEN OTHERS THEN
        -- Output generic error message
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred. Please contact the system administrator.');
END insert_employee;
/


-- Enable server output
SET SERVEROUTPUT ON;

-- Call the insert_employee procedure with sample values
BEGIN
    insert_employee(1, 'John Doe', 30, 'IT');
    insert_employee(2, 'Jane Smith', 25, 'HR');
    insert_employee(3, 'Michael Johnson', 35, 'Finance');
    insert_employee(4, 'Emily Davis', 28, 'Marketing');
    insert_employee(5, 'David Brown', 32, 'Operations');
EXCEPTION
    -- Catch any unhandled exceptions
    WHEN OTHERS THEN
        -- Output the error message
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


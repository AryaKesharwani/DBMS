-- 1.  Consider the insurance database given below. 
-- PERSON(driver_id, name, address) CAR(regno, model,year ) ACCIDENT(report_number,accd_date,location) OWNS(driver_id,regno) PARTICIPATED(driver_id,regno,report_number,damage_amount) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation.
-- ii. Update the damage amount for the car with specific regno in the accident with report number 12 to 25000. 
-- iii. Add a new accident to the database. 
-- iv. Find the total number of people who owned cars that were involved in accidents in the year 2008. 
-- v. Write a PL/SQL to find and display the sum of first n natural numbers. 


CREATE TABLE PERSON (
    driver_id INT PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

CREATE TABLE CAR (
    regno INT PRIMARY KEY,
    model VARCHAR(50),
    year INT
);

CREATE TABLE ACCIDENT (
    report_number INT PRIMARY KEY,
    accd_date DATE,
    location VARCHAR(100)
);

CREATE TABLE OWNS (
    driver_id INT,
    regno INT,
    PRIMARY KEY (driver_id, regno),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno)
);

CREATE TABLE PARTICIPATED (
    driver_id INT,
    regno INT,
    report_number INT,
    damage_amount INT,
    PRIMARY KEY (driver_id, regno, report_number),
    FOREIGN KEY (driver_id, regno) REFERENCES OWNS(driver_id, regno),
    FOREIGN KEY (report_number) REFERENCES ACCIDENT(report_number)
);

-- Inserting sample data for each relation
INSERT INTO PERSON VALUES (1, 'John Doe', '123 Main St');
INSERT INTO PERSON VALUES (2, 'Jane Smith', '456 Elm St');
INSERT INTO PERSON VALUES (3, 'Alice Johnson', '789 Oak St');
INSERT INTO PERSON VALUES (4, 'Bob Williams', '101 Pine St');
INSERT INTO PERSON VALUES (5, 'Emily Brown', '202 Cedar St');

INSERT INTO CAR VALUES (101, 'Toyota Camry', 2008);
INSERT INTO CAR VALUES (102, 'Honda Accord', 2010);
INSERT INTO CAR VALUES (103, 'Ford Focus', 2008);
INSERT INTO CAR VALUES (104, 'Chevrolet Malibu', 2012);
INSERT INTO CAR VALUES (105, 'Nissan Altima', 2015);

INSERT INTO ACCIDENT VALUES (11, '2024-04-20', 'Intersection A');
INSERT INTO ACCIDENT VALUES (12, '2024-04-21', 'Highway B');
INSERT INTO ACCIDENT VALUES (13, '2024-04-22', 'Street C');
INSERT INTO ACCIDENT VALUES (14, '2024-04-23', 'Road D');
INSERT INTO ACCIDENT VALUES (15, '2024-04-24', 'Avenue E');

INSERT INTO OWNS VALUES (1, 101);
INSERT INTO OWNS VALUES (2, 102);
INSERT INTO OWNS VALUES (3, 103);
INSERT INTO OWNS VALUES (4, 104);
INSERT INTO OWNS VALUES (5, 105);

INSERT INTO PARTICIPATED VALUES (1, 101, 11, 5000);
INSERT INTO PARTICIPATED VALUES (2, 102, 12, 7500);
INSERT INTO PARTICIPATED VALUES (3, 103, 13, 10000);
INSERT INTO PARTICIPATED VALUES (4, 104, 14, 12500);
INSERT INTO PARTICIPATED VALUES (5, 105, 15, 15000);

-- ii. Update the damage amount for the car with specific regno in the accident with report number 12 to 25000.
UPDATE PARTICIPATED
SET damage_amount = 25000
WHERE regno = 102 AND report_number = 12;

-- iii. Add a new accident to the database.
INSERT INTO ACCIDENT VALUES (16, '2024-04-25', 'Street F');

-- iv. Find the total number of people who owned cars that were involved in accidents in the year 2008.
SELECT COUNT(DISTINCT driver_id) AS total_owners_involved
FROM OWNS
JOIN PARTICIPATED ON OWNS.driver_id = PARTICIPATED.driver_id
JOIN ACCIDENT ON PARTICIPATED.report_number = ACCIDENT.report_number
JOIN CAR ON OWNS.regno = CAR.regno
WHERE CAR.year = 2008;

-- v. Write a PL/SQL to find and display the sum of first n natural numbers.
CREATE OR REPLACE PROCEDURE sum_of_natural_numbers(n IN INT)
IS
    total_sum INT := 0;
BEGIN
    FOR i IN 1..n LOOP
        total_sum := total_sum + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Sum of first ' || n || ' natural numbers is: ' || total_sum);
END;
/



-- 2. Consider the following employee and department tables. 
-- EMPLOYEE(empno, ename, designation, manager, hiredate, salary, commission,  deptno) 
-- DEPARTMENT(deptno, dname, location) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. List the names of employees whose name contain substring ‘LA’. 
-- iii. List the details of employees of salary are greater than or equal to the average salary of 
-- employee table. 
-- iv. Create a view which consists of details of all ‘SALESMAN’.  
-- v. Write a PL/SQL to display the empno,job,salary of all employees in employee table.


CREATE TABLE EMPLOYEE (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    designation VARCHAR(50),
    manager INT,
    hiredate DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    location VARCHAR(100)
);

-- Inserting sample data for each relation
INSERT INTO EMPLOYEE VALUES (1, 'John Lang', 'Manager', NULL, '2020-01-01', 5000.00, 1000.00, 1);
INSERT INTO EMPLOYEE VALUES (2, 'Alice Lane', 'Salesman', 1, '2020-02-01', 3000.00, 500.00, 1);
INSERT INTO EMPLOYEE VALUES (3, 'Bob Clark', 'Clerk', 1, '2020-03-01', 2000.00, NULL, 2);
INSERT INTO EMPLOYEE VALUES (4, 'Jane Anderson', 'Manager', NULL, '2020-04-01', 5500.00, 1200.00, 2);
INSERT INTO EMPLOYEE VALUES (5, 'David Larson', 'Salesman', 4, '2020-05-01', 3200.00, 600.00, 2);

INSERT INTO DEPARTMENT VALUES (1, 'Sales', 'New York');
INSERT INTO DEPARTMENT VALUES (2, 'Finance', 'Los Angeles');

-- ii. List the names of employees whose name contain substring ‘LA’.
SELECT ename
FROM EMPLOYEE
WHERE ename LIKE '%LA%';

-- iii. List the details of employees of salary are greater than or equal to the average salary of employee table.
SELECT *
FROM EMPLOYEE
WHERE salary >= (SELECT AVG(salary) FROM EMPLOYEE);

-- iv. Create a view which consists of details of all ‘SALESMAN’.
CREATE VIEW SALESMAN_VIEW AS
SELECT *
FROM EMPLOYEE
WHERE designation = 'Salesman';

-- v. Write a PL/SQL to display the empno, job, salary of all employees in employee table.
CREATE OR REPLACE PROCEDURE display_employee_details
IS
BEGIN
    FOR emp_rec IN (SELECT empno, designation, salary FROM EMPLOYEE) LOOP
        DBMS_OUTPUT.PUT_LINE('Empno: ' || emp_rec.empno || ', Job: ' || emp_rec.designation || ', Salary: ' || emp_rec.salary);
    END LOOP;
END;
/


-- 3.Consider the following tables. 
-- SAILOR(sid, sname, rating, age) 
-- BOATS(bid, bname, colour) 
-- RESERVES(sid, bid, day) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. List the sailors in the descending order of their rating.
-- iii. List the sailors whose youngest sailor for each rating and who can vote. 
-- iv. List the sailors who have reserved for both ‘RED’ and ‘GREEN’ boats. 
-- v. Write a PL/SQL to find the factorial of a number. 

CREATE TABLE SAILOR (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    rating INT,
    age INT
);

CREATE TABLE BOATS (
    bid INT PRIMARY KEY,
    bname VARCHAR(50),
    colour VARCHAR(50)
);

CREATE TABLE RESERVES (
    sid INT,
    bid INT,
    day DATE,
    PRIMARY KEY (sid, bid),
    FOREIGN KEY (sid) REFERENCES SAILOR(sid),
    FOREIGN KEY (bid) REFERENCES BOATS(bid)
);

-- Inserting sample data for each relation
INSERT INTO SAILOR VALUES (1, 'John', 8, 30);
INSERT INTO SAILOR VALUES (2, 'Alice', 7, 25);
INSERT INTO SAILOR VALUES (3, 'Bob', 6, 35);
INSERT INTO SAILOR VALUES (4, 'Jane', 8, 28);
INSERT INTO SAILOR VALUES (5, 'David', 7, 32);

INSERT INTO BOATS VALUES (101, 'Sailboat A', 'Red');
INSERT INTO BOATS VALUES (102, 'Sailboat B', 'Green');
INSERT INTO BOATS VALUES (103, 'Sailboat C', 'Blue');
INSERT INTO BOATS VALUES (104, 'Sailboat D', 'Red');
INSERT INTO BOATS VALUES (105, 'Sailboat E', 'Green');

INSERT INTO RESERVES VALUES (1, 101, '2024-04-20');
INSERT INTO RESERVES VALUES (2, 102, '2024-04-21');
INSERT INTO RESERVES VALUES (3, 103, '2024-04-22');
INSERT INTO RESERVES VALUES (4, 104, '2024-04-23');
INSERT INTO RESERVES VALUES (5, 105, '2024-04-24');

-- ii. List the sailors in the descending order of their rating.
SELECT *
FROM SAILOR
ORDER BY rating DESC;

-- iii. List the sailors whose youngest sailor for each rating and who can vote.
SELECT *
FROM SAILOR s1
WHERE s1.age = (SELECT MIN(age) FROM SAILOR s2 WHERE s2.rating = s1.rating)
AND s1.age >= 18;

-- iv. List the sailors who have reserved for both ‘RED’ and ‘GREEN’ boats.
SELECT sid, sname
FROM SAILOR
WHERE sid IN (
    SELECT r1.sid
    FROM RESERVES r1
    JOIN BOATS b1 ON r1.bid = b1.bid
    WHERE b1.colour = 'Red'
)
AND sid IN (
    SELECT r2.sid
    FROM RESERVES r2
    JOIN BOATS b2 ON r2.bid = b2.bid
    WHERE b2.colour = 'Green'
);

-- v. Write a PL/SQL to find the factorial of a number.
CREATE OR REPLACE FUNCTION factorial(n IN INT)
RETURN INT
IS
    result INT := 1;
BEGIN
    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    RETURN result;
END;
/


-- 4. Consider the following relations for order processing database application in a company. 
-- CUSTOMER(custno, cname, city) ORDER(orderno, odate, custno, ord_amt ) ORDER_ITEM(orderno, itemno, quantity) ITEM(itemno, unitprice) SHIPMENT(orderno, warehouseno, ship_date) WAREHOUSE(warehouseno, city) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. Produce a listing: custname , No_of_orders , Avg_order_amount , where the middle column is the total number of orders by the customer and the last column is the average order amount for that customer. 
-- iii. List the orderno for orders that were shipped from all the warehouses that the company has in a specific city. 
-- iv. Demonstrate the deletion of an item from the ITEM table and demonstrate a method of handling the rows in the ORDER_ITEM table that contains this particular item.  
-- v. Write a PL/SQL to generate Fibonacci series. 

CREATE TABLE CUSTOMER (
    custno INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(100)
);

CREATE TABLE ORDER (
    orderno INT PRIMARY KEY,
    odate DATE,
    custno INT,
    ord_amt DECIMAL(10, 2),
    FOREIGN KEY (custno) REFERENCES CUSTOMER(custno)
);

CREATE TABLE ORDER_ITEM (
    orderno INT,
    itemno INT,
    quantity INT,
    PRIMARY KEY (orderno, itemno),
    FOREIGN KEY (orderno) REFERENCES ORDER(orderno)
);

CREATE TABLE ITEM (
    itemno INT PRIMARY KEY,
    unitprice DECIMAL(10, 2)
);

CREATE TABLE SHIPMENT (
    orderno INT,
    warehouseno INT,
    ship_date DATE,
    PRIMARY KEY (orderno),
    FOREIGN KEY (orderno) REFERENCES ORDER(orderno)
);

CREATE TABLE WAREHOUSE (
    warehouseno INT PRIMARY KEY,
    city VARCHAR(100)
);

-- Inserting sample data for each relation
INSERT INTO CUSTOMER VALUES (1, 'ABC Company', 'New York');
INSERT INTO CUSTOMER VALUES (2, 'XYZ Inc', 'Los Angeles');
INSERT INTO CUSTOMER VALUES (3, 'DEF Corporation', 'Chicago');
INSERT INTO CUSTOMER VALUES (4, 'GHI Enterprises', 'Houston');
INSERT INTO CUSTOMER VALUES (5, 'LMN Ltd', 'San Francisco');

INSERT INTO ORDER VALUES (101, '2024-04-20', 1, 5000.00);
INSERT INTO ORDER VALUES (102, '2024-04-21', 2, 7500.00);
INSERT INTO ORDER VALUES (103, '2024-04-22', 3, 10000.00);
INSERT INTO ORDER VALUES (104, '2024-04-23', 4, 12500.00);
INSERT INTO ORDER VALUES (105, '2024-04-24', 5, 15000.00);

INSERT INTO ORDER_ITEM VALUES (101, 1, 10);
INSERT INTO ORDER_ITEM VALUES (102, 2, 20);
INSERT INTO ORDER_ITEM VALUES (103, 3, 30);
INSERT INTO ORDER_ITEM VALUES (104, 4, 40);
INSERT INTO ORDER_ITEM VALUES (105, 5, 50);

INSERT INTO ITEM VALUES (1, 100.00);
INSERT INTO ITEM VALUES (2, 200.00);
INSERT INTO ITEM VALUES (3, 300.00);
INSERT INTO ITEM VALUES (4, 400.00);
INSERT INTO ITEM VALUES (5, 500.00);

INSERT INTO SHIPMENT VALUES (101, 1, '2024-04-21');
INSERT INTO SHIPMENT VALUES (102, 2, '2024-04-22');
INSERT INTO SHIPMENT VALUES (103, 3, '2024-04-23');
INSERT INTO SHIPMENT VALUES (104, 4, '2024-04-24');
INSERT INTO SHIPMENT VALUES (105, 5, '2024-04-25');

INSERT INTO WAREHOUSE VALUES (1, 'New York');
INSERT INTO WAREHOUSE VALUES (2, 'Los Angeles');
INSERT INTO WAREHOUSE VALUES (3, 'Chicago');
INSERT INTO WAREHOUSE VALUES (4, 'Houston');
INSERT INTO WAREHOUSE VALUES (5, 'San Francisco');

-- ii. Produce a listing: custname, No_of_orders, Avg_order_amount, where the middle column is the total number of orders by the customer and the last column is the average order amount for that customer.
SELECT c.cname,
       COUNT(o.orderno) AS No_of_orders,
       AVG(o.ord_amt) AS Avg_order_amount
FROM CUSTOMER c
JOIN ORDER o ON c.custno = o.custno
GROUP BY c.cname;

-- iii. List the orderno for orders that were shipped from all the warehouses that the company has in a specific city.
SELECT orderno
FROM SHIPMENT s
WHERE NOT EXISTS (
    SELECT w.warehouseno
    FROM WAREHOUSE w
    WHERE w.city = 'New York'
    AND NOT EXISTS (
        SELECT *
        FROM SHIPMENT s2
        WHERE s.orderno = s2.orderno
        AND s2.warehouseno = w.warehouseno
    )
);

-- iv. Demonstrate the deletion of an item from the ITEM table and demonstrate a method of handling the rows in the ORDER_ITEM table that contains this particular item.
-- Deleting item with itemno = 3 from ITEM table
DELETE FROM ITEM WHERE itemno = 3;

-- Handling rows in ORDER_ITEM table for deleted item
DELETE FROM ORDER_ITEM WHERE itemno = 3;

-- v. Write a PL/SQL to generate Fibonacci series.
CREATE OR REPLACE FUNCTION fibonacci_series(n IN INT)
RETURN INT
IS
    a INT := 0;
    b INT := 1;
    result INT;
BEGIN
    FOR i IN 1..n LOOP
        result := a;
        a := b;
        b := result + a;
        DBMS_OUTPUT.PUT_LINE(result);
    END LOOP;
    RETURN result;
END;
/


-- 5. Consider the following database of student enrollment in courses and books adopted for that course. 
-- STUDENT(regno, name, major, bdate) COURSE(courseno, cname, dept) ENROLL(regno, courseno, sem, marks) BOOK_ADOPTION(courseno, sem, book_isbn) TEXT(book_isbn,book_title,publisher, author) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation.
-- ii. Add a new text book to the database and make this book to be adopted by some department. 
-- iii. Produce a list of text books ( includes courseno , book_isbn , book_title ) in the alphabetical order for courses offered by the 'CS' department that use more than two books. 
-- iv. List any department that has all its books published by a specific publisher. 
-- v. Write a PL/SQL to find topper among ‘n’ students. 

CREATE TABLE STUDENT (
    regno INT PRIMARY KEY,
    name VARCHAR(50),
    major VARCHAR(50),
    bdate DATE
);

CREATE TABLE COURSE (
    courseno INT PRIMARY KEY,
    cname VARCHAR(50),
    dept VARCHAR(50)
);

CREATE TABLE ENROLL (
    regno INT,
    courseno INT,
    sem INT,
    marks INT,
    PRIMARY KEY (regno, courseno, sem),
    FOREIGN KEY (regno) REFERENCES STUDENT(regno),
    FOREIGN KEY (courseno) REFERENCES COURSE(courseno)
);

CREATE TABLE BOOK_ADOPTION (
    courseno INT,
    sem INT,
    book_isbn VARCHAR(50),
    PRIMARY KEY (courseno, sem, book_isbn),
    FOREIGN KEY (courseno) REFERENCES COURSE(courseno),
    FOREIGN KEY (book_isbn) REFERENCES TEXT(book_isbn)
);

CREATE TABLE TEXT (
    book_isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(100),
    publisher VARCHAR(50),
    author VARCHAR(50)
);

-- Inserting sample data for each relation
INSERT INTO STUDENT VALUES (1, 'John Doe', 'Computer Science', '2000-01-01');
INSERT INTO STUDENT VALUES (2, 'Jane Smith', 'Electrical Engineering', '2000-02-02');
INSERT INTO STUDENT VALUES (3, 'Alice Johnson', 'Mechanical Engineering', '2000-03-03');
INSERT INTO STUDENT VALUES (4, 'Bob Williams', 'Computer Science', '2000-04-04');
INSERT INTO STUDENT VALUES (5, 'Emily Brown', 'Civil Engineering', '2000-05-05');

INSERT INTO COURSE VALUES (101, 'Introduction to Programming', 'CS');
INSERT INTO COURSE VALUES (102, 'Database Management', 'CS');
INSERT INTO COURSE VALUES (103, 'Digital Circuits', 'EE');
INSERT INTO COURSE VALUES (104, 'Fluid Mechanics', 'ME');
INSERT INTO COURSE VALUES (105, 'Structural Analysis', 'CE');

INSERT INTO ENROLL VALUES (1, 101, 1, 80);
INSERT INTO ENROLL VALUES (2, 102, 1, 75);
INSERT INTO ENROLL VALUES (3, 103, 1, 85);
INSERT INTO ENROLL VALUES (4, 104, 1, 90);
INSERT INTO ENROLL VALUES (5, 105, 1, 95);

INSERT INTO BOOK_ADOPTION VALUES (101, 1, 'ISBN001', 'CS');
INSERT INTO BOOK_ADOPTION VALUES (102, 1, 'ISBN002', 'CS');
INSERT INTO BOOK_ADOPTION VALUES (103, 1, 'ISBN003', 'EE');
INSERT INTO BOOK_ADOPTION VALUES (104, 1, 'ISBN004', 'ME');
INSERT INTO BOOK_ADOPTION VALUES (105, 1, 'ISBN005', 'CE');

INSERT INTO TEXT VALUES ('ISBN001', 'Introduction to Programming', 'Publisher A', 'Author X');
INSERT INTO TEXT VALUES ('ISBN002', 'Database Management', 'Publisher B', 'Author Y');
INSERT INTO TEXT VALUES ('ISBN003', 'Digital Circuits', 'Publisher C', 'Author Z');
INSERT INTO TEXT VALUES ('ISBN004', 'Fluid Mechanics', 'Publisher D', 'Author P');
INSERT INTO TEXT VALUES ('ISBN005', 'Structural Analysis', 'Publisher E', 'Author Q');

-- ii. Add a new text book to the database and make this book to be adopted by some department.
INSERT INTO TEXT VALUES ('ISBN006', 'New Book', 'Publisher F', 'Author R');
INSERT INTO BOOK_ADOPTION VALUES (101, 2, 'ISBN006');

-- iii. Produce a list of text books ( includes courseno, book_isbn, book_title ) in the alphabetical order for courses offered by the 'CS' department that use more than two books.
SELECT BA.courseno, BA.book_isbn, T.book_title
FROM BOOK_ADOPTION BA
JOIN TEXT T ON BA.book_isbn = T.book_isbn
JOIN COURSE C ON BA.courseno = C.courseno
WHERE C.dept = 'CS'
GROUP BY BA.courseno
HAVING COUNT(*) > 2
ORDER BY T.book_title;

-- iv. List any department that has all its books published by a specific publisher.
SELECT C.dept
FROM COURSE C
WHERE NOT EXISTS (
    SELECT *
    FROM BOOK_ADOPTION BA
    JOIN TEXT T ON BA.book_isbn = T.book_isbn
    WHERE BA.courseno = C.courseno
    AND T.publisher <> 'Publisher A'
);

-- v. Write a PL/SQL to find topper among ‘n’ students.
CREATE OR REPLACE PROCEDURE find_topper(n IN INT)
IS
BEGIN
    FOR rec IN (
        SELECT regno, name, MAX(marks) AS max_marks
        FROM ENROLL
        GROUP BY regno, name
        ORDER BY max_marks DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Reg No: ' || rec.regno || ', Name: ' || rec.name || ', Marks: ' || rec.max_marks);
        n := n - 1;
        IF n = 0 THEN
            EXIT;
        END IF;
    END LOOP;
END;
/




-- 6. The following are maintained by a book dealer. 
-- AUTHOR(author_id, name, city, country) PUBLISHER(publisher_id, name, city, country) CATALOG(book_id, title, author_id, publisher_id , category_id, year, price) CATEGORY(category_id, description) ORDER_DETAILS(order_no, book_id, quantity) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. Give the details of the authors who have 2 or more books in the catalog and the price of the books is greater than the average price of the books in the catalog and the year of publication is after 2000. 
-- iii. Find the author of the book that has maximum sales.
-- iv. Demonstrate how you increase the price of books published by a specific publisher by 10%. 
-- v. Write a PL/SQL to find total marks for n students. 

CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE PUBLISHER (
    publisher_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE CATALOG (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    publisher_id INT,
    category_id INT,
    year INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id)
);

CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    description VARCHAR(100)
);

CREATE TABLE ORDER_DETAILS (
    order_no INT,
    book_id INT,
    quantity INT,
    PRIMARY KEY (order_no, book_id),
    FOREIGN KEY (book_id) REFERENCES CATALOG(book_id)
);

-- Inserting sample data for each relation
INSERT INTO AUTHOR VALUES (1, 'Author X', 'City X', 'Country X');
INSERT INTO AUTHOR VALUES (2, 'Author Y', 'City Y', 'Country Y');
INSERT INTO AUTHOR VALUES (3, 'Author Z', 'City Z', 'Country Z');
INSERT INTO AUTHOR VALUES (4, 'Author P', 'City P', 'Country P');
INSERT INTO AUTHOR VALUES (5, 'Author Q', 'City Q', 'Country Q');

INSERT INTO PUBLISHER VALUES (101, 'Publisher A', 'City A', 'Country A');
INSERT INTO PUBLISHER VALUES (102, 'Publisher B', 'City B', 'Country B');
INSERT INTO PUBLISHER VALUES (103, 'Publisher C', 'City C', 'Country C');
INSERT INTO PUBLISHER VALUES (104, 'Publisher D', 'City D', 'Country D');
INSERT INTO PUBLISHER VALUES (105, 'Publisher E', 'City E', 'Country E');

INSERT INTO CATEGORY VALUES (201, 'Category 1');
INSERT INTO CATEGORY VALUES (202, 'Category 2');
INSERT INTO CATEGORY VALUES (203, 'Category 3');
INSERT INTO CATEGORY VALUES (204, 'Category 4');
INSERT INTO CATEGORY VALUES (205, 'Category 5');

INSERT INTO CATALOG VALUES (1001, 'Book 1', 1, 101, 201, 2005, 25.00);
INSERT INTO CATALOG VALUES (1002, 'Book 2', 2, 102, 202, 2006, 30.00);
INSERT INTO CATALOG VALUES (1003, 'Book 3', 3, 103, 203, 2007, 35.00);
INSERT INTO CATALOG VALUES (1004, 'Book 4', 4, 104, 204, 2008, 40.00);
INSERT INTO CATALOG VALUES (1005, 'Book 5', 5, 105, 205, 2009, 45.00);

INSERT INTO ORDER_DETAILS VALUES (2001, 1001, 10);
INSERT INTO ORDER_DETAILS VALUES (2002, 1002, 20);
INSERT INTO ORDER_DETAILS VALUES (2003, 1003, 30);
INSERT INTO ORDER_DETAILS VALUES (2004, 1004, 40);
INSERT INTO ORDER_DETAILS VALUES (2005, 1005, 50);

-- ii. Give the details of the authors who have 2 or more books in the catalog and the price of the books is greater than the average price of the books in the catalog and the year of publication is after 2000.
SELECT A.name, COUNT(*) AS book_count
FROM AUTHOR A
JOIN CATALOG C ON A.author_id = C.author_id
WHERE C.price > (SELECT AVG(price) FROM CATALOG)
AND C.year > 2000
GROUP BY A.name
HAVING COUNT(*) >= 2;

-- iii. Find the author of the book that has maximum sales.
SELECT A.name AS author, SUM(OD.quantity) AS total_sales
FROM AUTHOR A
JOIN CATALOG C ON A.author_id = C.author_id
JOIN ORDER_DETAILS OD ON C.book_id = OD.book_id
GROUP BY A.name
ORDER BY total_sales DESC
FETCH FIRST ROW ONLY;

-- iv. Demonstrate how you increase the price of books published by a specific publisher by 10%.
UPDATE CATALOG
SET price = price * 1.1
WHERE publisher_id = (SELECT publisher_id FROM PUBLISHER WHERE name = 'Publisher A');

-- v. Write a PL/SQL to find total marks for n students.
CREATE OR REPLACE PROCEDURE find_total_marks(n IN INT)
IS
    total_marks INT := 0;
BEGIN
    FOR rec IN (SELECT marks FROM ENROLL FETCH FIRST n ROWS ONLY) LOOP
        total_marks := total_marks + rec.marks;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total marks for ' || n || ' students: ' || total_marks);
END;
/



-- 7. Consider the following database for a banking enterprise. 
-- CUSTOMER_FIXED_DEPOSIT(cust_id, last_name,mid_name,first_name, 
-- fixed_deposit_no, amount, rate_of_interest) 
-- CUSTOMER_LOAN(loan_no, cust_id, amount) 
-- CUSTOMER_DETAILS(cust_id, acc_type ) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. List customer names of all customer who have taken a loan > 3,00,000.iii. List customer names of all customer who have the same account type as customer ‘jones simon’. 
-- iv. List customer names of all customer who do not have a fixed deposit.
-- v. Write a PL/SQL to find factorial of n number. 


CREATE TABLE CUSTOMER_FIXED_DEPOSIT (
    cust_id INT,
    last_name VARCHAR(50),
    mid_name VARCHAR(50),
    first_name VARCHAR(50),
    fixed_deposit_no INT,
    amount DECIMAL(10, 2),
    rate_of_interest DECIMAL(5, 2),
    PRIMARY KEY (cust_id, fixed_deposit_no)
);

CREATE TABLE CUSTOMER_LOAN (
    loan_no INT PRIMARY KEY,
    cust_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (cust_id) REFERENCES CUSTOMER_FIXED_DEPOSIT(cust_id)
);

CREATE TABLE CUSTOMER_DETAILS (
    cust_id INT PRIMARY KEY,
    acc_type VARCHAR(50)
);

-- Inserting sample data for each relation
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (1, 'Doe', NULL, 'John', 101, 50000.00, 5.0);
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (2, 'Smith', NULL, 'Jane', 102, 75000.00, 6.0);
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (3, 'Johnson', NULL, 'Alice', 103, 100000.00, 7.0);
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (4, 'Williams', NULL, 'Bob', 104, 125000.00, 8.0);
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (5, 'Brown', NULL, 'Emily', 105, 150000.00, 9.0);

INSERT INTO CUSTOMER_LOAN VALUES (201, 1, 300000.00);
INSERT INTO CUSTOMER_LOAN VALUES (202, 2, 400000.00);
INSERT INTO CUSTOMER_LOAN VALUES (203, 3, 500000.00);
INSERT INTO CUSTOMER_LOAN VALUES (204, 4, 600000.00);
INSERT INTO CUSTOMER_LOAN VALUES (205, 5, 700000.00);

INSERT INTO CUSTOMER_DETAILS VALUES (1, 'Savings');
INSERT INTO CUSTOMER_DETAILS VALUES (2, 'Current');
INSERT INTO CUSTOMER_DETAILS VALUES (3, 'Savings');
INSERT INTO CUSTOMER_DETAILS VALUES (4, 'Current');
INSERT INTO CUSTOMER_DETAILS VALUES (5, 'Savings');

-- ii. List customer names of all customer who have taken a loan > 3,00,000.
SELECT last_name, mid_name, first_name
FROM CUSTOMER_FIXED_DEPOSIT
WHERE cust_id IN (SELECT cust_id FROM CUSTOMER_LOAN WHERE amount > 300000.00);

-- iii. List customer names of all customer who have the same account type as customer ‘Jones Simon’.
SELECT last_name, mid_name, first_name
FROM CUSTOMER_FIXED_DEPOSIT CFD
JOIN CUSTOMER_DETAILS CD ON CFD.cust_id = CD.cust_id
WHERE CD.acc_type = (SELECT acc_type FROM CUSTOMER_DETAILS WHERE last_name = 'Jones' AND first_name = 'Simon');

-- iv. List customer names of all customer who do not have a fixed deposit.
SELECT last_name, mid_name, first_name
FROM CUSTOMER_FIXED_DEPOSIT
WHERE cust_id NOT IN (SELECT cust_id FROM CUSTOMER_DETAILS);

-- v. Write a PL/SQL to find factorial of n number.
CREATE OR REPLACE FUNCTION factorial(n IN INT)
RETURN INT
IS
    result INT := 1;
BEGIN
    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    RETURN result;
END;
/



-- 8. Consider the following databases. 
-- CUSTOMER(custno, custname, city, phone) 
-- ITEM(itemno, itemname, itemprice, quantity) 
-- INVOICE(invno, invdate, custno) 
-- INVITEM(invno, itemno, quantity) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. Display all item name along with the quantity sold. 
-- iii. Display item name and price as single column like “<item> price is <price>”  
-- iv. Display invoices, customer name and item names together (use join). 
-- v. Write a PL/SQL to calculate and print employee pay slip using procedure. 


CREATE TABLE CUSTOMER (
    custno INT PRIMARY KEY,
    custname VARCHAR(50),
    city VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE ITEM (
    itemno INT PRIMARY KEY,
    itemname VARCHAR(100),
    itemprice DECIMAL(10, 2),
    quantity INT
);

CREATE TABLE INVOICE (
    invno INT PRIMARY KEY,
    invdate DATE,
    custno INT,
    FOREIGN KEY (custno) REFERENCES CUSTOMER(custno)
);

CREATE TABLE INVITEM (
    invno INT,
    itemno INT,
    quantity INT,
    PRIMARY KEY (invno, itemno),
    FOREIGN KEY (invno) REFERENCES INVOICE(invno),
    FOREIGN KEY (itemno) REFERENCES ITEM(itemno)
);

-- Inserting sample data for each relation
INSERT INTO CUSTOMER VALUES (1, 'ABC Company', 'New York', '123-456-7890');
INSERT INTO CUSTOMER VALUES (2, 'XYZ Inc', 'Los Angeles', '987-654-3210');
INSERT INTO CUSTOMER VALUES (3, 'DEF Corporation', 'Chicago', '555-555-5555');
INSERT INTO CUSTOMER VALUES (4, 'GHI Enterprises', 'Houston', '111-222-3333');
INSERT INTO CUSTOMER VALUES (5, 'LMN Ltd', 'San Francisco', '444-444-4444');

INSERT INTO ITEM VALUES (101, 'Item 1', 10.00, 100);
INSERT INTO ITEM VALUES (102, 'Item 2', 20.00, 200);
INSERT INTO ITEM VALUES (103, 'Item 3', 30.00, 300);
INSERT INTO ITEM VALUES (104, 'Item 4', 40.00, 400);
INSERT INTO ITEM VALUES (105, 'Item 5', 50.00, 500);

INSERT INTO INVOICE VALUES (1001, '2024-04-20', 1);
INSERT INTO INVOICE VALUES (1002, '2024-04-21', 2);
INSERT INTO INVOICE VALUES (1003, '2024-04-22', 3);
INSERT INTO INVOICE VALUES (1004, '2024-04-23', 4);
INSERT INTO INVOICE VALUES (1005, '2024-04-24', 5);

INSERT INTO INVITEM VALUES (1001, 101, 10);
INSERT INTO INVITEM VALUES (1002, 102, 20);
INSERT INTO INVITEM VALUES (1003, 103, 30);
INSERT INTO INVITEM VALUES (1004, 104, 40);
INSERT INTO INVITEM VALUES (1005, 105, 50);

-- ii. Display all item name along with the quantity sold.
SELECT I.itemname, SUM(II.quantity) AS total_quantity_sold
FROM ITEM I
JOIN INVITEM II ON I.itemno = II.itemno
GROUP BY I.itemname;

-- iii. Display item name and price as single column like “<item> price is <price>”
SELECT itemname || ' price is ' || itemprice AS item_details
FROM ITEM;

-- iv. Display invoices, customer name and item names together (use join).
SELECT I.invno, C.custname, GROUP_CONCAT(I.itemname) AS item_names
FROM INVOICE I
JOIN CUSTOMER C ON I.custno = C.custno
JOIN INVITEM II ON I.invno = II.invno
JOIN ITEM IT ON II.itemno = IT.itemno
GROUP BY I.invno, C.custname;

-- v. Write a PL/SQL to calculate and print employee pay slip using procedure.
CREATE OR REPLACE PROCEDURE calculate_pay_slip(empno IN INT)
IS
    emp_name VARCHAR(100);
    emp_salary DECIMAL(10, 2);
BEGIN
    SELECT ename, salary INTO emp_name, emp_salary FROM EMPLOYEE WHERE empno = empno;
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_name);
    DBMS_OUTPUT.PUT_LINE('Employee Salary: ' || emp_salary);
    -- Additional calculations can be performed here for deductions, bonuses, etc.
END;
/


-- 9. Consider the following database for a banking enterprise. 
-- BRANCH(branch_name, branch_city, assets) ACCOUNT(accno, branch_name, balance) DEPOSITOR(customer_name, accno) CUSTOMER(customer_name, customer_street, customer_city) LOAN(loan_number, branch_name, amount) BORROWER( customer_name, loan_number) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. Display all the customers who were depositor and borrower. 
-- iii. Display all the customer name who are only depositor.  
-- iv. Display all branch name whose assets are greater than assets of branches located in “Coimbatore” city. 
-- v.Write a PL/SQL to handle user defined exception. 

CREATE TABLE BRANCH (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(100),
    assets DECIMAL(10, 2)
);

CREATE TABLE ACCOUNT (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance DECIMAL(10, 2),
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name)
);

CREATE TABLE DEPOSITOR (
    customer_name VARCHAR(100),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (accno) REFERENCES ACCOUNT(accno)
);

CREATE TABLE CUSTOMER (
    customer_name VARCHAR(100) PRIMARY KEY,
    customer_street VARCHAR(100),
    customer_city VARCHAR(100)
);

CREATE TABLE LOAN (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(10, 2),
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name)
);

CREATE TABLE BORROWER (
    customer_name VARCHAR(100),
    loan_number INT,
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES CUSTOMER(customer_name),
    FOREIGN KEY (loan_number) REFERENCES LOAN(loan_number)
);

-- Inserting sample data for each relation
INSERT INTO BRANCH VALUES ('Branch A', 'New York', 1000000.00);
INSERT INTO BRANCH VALUES ('Branch B', 'Los Angeles', 1500000.00);
INSERT INTO BRANCH VALUES ('Branch C', 'Chicago', 2000000.00);
INSERT INTO BRANCH VALUES ('Branch D', 'Houston', 2500000.00);
INSERT INTO BRANCH VALUES ('Branch E', 'San Francisco', 3000000.00);

INSERT INTO ACCOUNT VALUES (101, 'Branch A', 50000.00);
INSERT INTO ACCOUNT VALUES (102, 'Branch B', 75000.00);
INSERT INTO ACCOUNT VALUES (103, 'Branch C', 100000.00);
INSERT INTO ACCOUNT VALUES (104, 'Branch D', 125000.00);
INSERT INTO ACCOUNT VALUES (105, 'Branch E', 150000.00);

INSERT INTO DEPOSITOR VALUES ('John Doe', 101);
INSERT INTO DEPOSITOR VALUES ('Jane Smith', 102);
INSERT INTO DEPOSITOR VALUES ('Alice Johnson', 103);
INSERT INTO DEPOSITOR VALUES ('Bob Williams', 104);
INSERT INTO DEPOSITOR VALUES ('Emily Brown', 105);

INSERT INTO CUSTOMER VALUES ('John Doe', '123 Main St', 'New York');
INSERT INTO CUSTOMER VALUES ('Jane Smith', '456 Elm St', 'Los Angeles');
INSERT INTO CUSTOMER VALUES ('Alice Johnson', '789 Oak St', 'Chicago');
INSERT INTO CUSTOMER VALUES ('Bob Williams', '101 Pine St', 'Houston');
INSERT INTO CUSTOMER VALUES ('Emily Brown', '202 Maple St', 'San Francisco');

INSERT INTO LOAN VALUES (201, 'Branch A', 300000.00);
INSERT INTO LOAN VALUES (202, 'Branch B', 400000.00);
INSERT INTO LOAN VALUES (203, 'Branch C', 500000.00);
INSERT INTO LOAN VALUES (204, 'Branch D', 600000.00);
INSERT INTO LOAN VALUES (205, 'Branch E', 700000.00);

INSERT INTO BORROWER VALUES ('John Doe', 201);
INSERT INTO BORROWER VALUES ('Jane Smith', 202);
INSERT INTO BORROWER VALUES ('Alice Johnson', 203);
INSERT INTO BORROWER VALUES ('Bob Williams', 204);
INSERT INTO BORROWER VALUES ('Emily Brown', 205);

-- ii. Display all the customers who were depositor and borrower.
SELECT DISTINCT CD.customer_name
FROM DEPOSITOR D
JOIN BORROWER B ON D.customer_name = B.customer_name
JOIN CUSTOMER CD ON D.customer_name = CD.customer_name;

-- iii. Display all the customer name who are only depositor.
SELECT D.customer_name
FROM DEPOSITOR D
WHERE NOT EXISTS (
    SELECT *
    FROM BORROWER B
    WHERE D.customer_name = B.customer_name
);

-- iv. Display all branch name whose assets are greater than assets of branches located in “Coimbatore” city.
SELECT branch_name
FROM BRANCH
WHERE assets > ALL (
    SELECT assets
    FROM BRANCH
    WHERE branch_city = 'Coimbatore'
);

-- v. Write a PL/SQL to handle user defined exception.
CREATE OR REPLACE PROCEDURE factorial(n IN INT)
IS
    result INT := 1;
BEGIN
    IF n < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Factorial is not defined for negative numbers');
    END IF;

    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Factorial of ' || n || ' is ' || result);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


-- 10. Consider the employee databases. 
-- EMPLOYEE(empname, street, city) 
-- WORKS(empname, companyname, salary) 
-- COMPANY(companyname, city) 
-- Manages(empname, managername) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. Find the names of all employees work for ‘First bank corporation’. 
-- iii. Find the names,street addresses and cities of residence of all employees who work for ‘First bank corporation’ and earn more than 200000 per annum. 
-- iv. Find the names of all employees in this database who live in the same city as the companies for which they work. 
-- v.Write a PL/SQL to calculate Electricity bill using function.

CREATE TABLE EMPLOYEE (
    empname VARCHAR(50) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE WORKS (
    empname VARCHAR(50),
    companyname VARCHAR(50),
    salary DECIMAL(10, 2),
    PRIMARY KEY (empname, companyname),
    FOREIGN KEY (empname) REFERENCES EMPLOYEE(empname)
);

CREATE TABLE COMPANY (
    companyname VARCHAR(50) PRIMARY KEY,
    city VARCHAR(100)
);

CREATE TABLE MANAGES (
    empname VARCHAR(50),
    managername VARCHAR(50),
    PRIMARY KEY (empname),
    FOREIGN KEY (empname) REFERENCES EMPLOYEE(empname)
);

-- Inserting sample data for each relation
INSERT INTO EMPLOYEE VALUES ('John Doe', '123 Main St', 'New York');
INSERT INTO EMPLOYEE VALUES ('Jane Smith', '456 Elm St', 'Los Angeles');
INSERT INTO EMPLOYEE VALUES ('Alice Johnson', '789 Oak St', 'Chicago');
INSERT INTO EMPLOYEE VALUES ('Bob Williams', '101 Pine St', 'Houston');
INSERT INTO EMPLOYEE VALUES ('Emily Brown', '202 Maple St', 'San Francisco');

INSERT INTO WORKS VALUES ('John Doe', 'First Bank Corporation', 250000.00);
INSERT INTO WORKS VALUES ('Jane Smith', 'First Bank Corporation', 220000.00);
INSERT INTO WORKS VALUES ('Alice Johnson', 'Second Bank Inc', 260000.00);
INSERT INTO WORKS VALUES ('Bob Williams', 'Third Bank Ltd', 210000.00);
INSERT INTO WORKS VALUES ('Emily Brown', 'Fourth Bank Co', 270000.00);

INSERT INTO COMPANY VALUES ('First Bank Corporation', 'New York');
INSERT INTO COMPANY VALUES ('Second Bank Inc', 'Los Angeles');
INSERT INTO COMPANY VALUES ('Third Bank Ltd', 'Chicago');
INSERT INTO COMPANY VALUES ('Fourth Bank Co', 'Houston');
INSERT INTO COMPANY VALUES ('Fifth Bank LLC', 'San Francisco');

INSERT INTO MANAGES VALUES ('John Doe', 'Jane Smith');
INSERT INTO MANAGES VALUES ('Jane Smith', 'Alice Johnson');
INSERT INTO MANAGES VALUES ('Alice Johnson', 'Bob Williams');
INSERT INTO MANAGES VALUES ('Bob Williams', 'Emily Brown');
INSERT INTO MANAGES VALUES ('Emily Brown', NULL);

-- ii. Find the names of all employees work for ‘First bank corporation’.
SELECT empname
FROM WORKS
WHERE companyname = 'First Bank Corporation';

-- iii. Find the names, street addresses, and cities of residence of all employees who work for ‘First bank corporation’ and earn more than 200000 per annum.
SELECT E.empname, E.street, E.city
FROM EMPLOYEE E
JOIN WORKS W ON E.empname = W.empname
WHERE W.companyname = 'First Bank Corporation' AND W.salary > 200000.00;

-- iv. Find the names of all employees in this database who live in the same city as the companies for which they work.
SELECT E.empname
FROM EMPLOYEE E
JOIN WORKS W ON E.empname = W.empname
JOIN COMPANY C ON W.companyname = C.companyname
WHERE E.city = C.city;

-- v. Write a PL/SQL to calculate Electricity bill using function.
CREATE OR REPLACE FUNCTION calculate_electricity_bill(units IN INT)
RETURN DECIMAL
IS
    rate_per_unit DECIMAL := 10.00; -- Assuming rate per unit is $10
    total_bill DECIMAL;
BEGIN
    total_bill := units * rate_per_unit;
    RETURN total_bill;
END;
/


-- 11. Consider the following employee and department tables. 
-- EMPLOYEE(empno, ename, designation, manager, hiredate, salary, commission, deptno) 
-- DEPARTMENT(deptno, dname, location) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and Enter at least five tuples for each relation. 
-- ii. List the employees who annual salary is between 22000 and 25000 
-- iii. List the employees names along with their manager names. 
-- iv. List the dept who employees maximum no of ‘CLERK’s. 
-- v.  Write a trigger to ensure that salary of an employee is always greater than the commission. 


CREATE TABLE EMPLOYEE (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    designation VARCHAR(50),
    manager INT,
    hiredate DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (manager) REFERENCES EMPLOYEE(empno),
    FOREIGN KEY (deptno) REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    location VARCHAR(100)
);

-- Inserting sample data for each relation
INSERT INTO EMPLOYEE VALUES (1, 'John Doe', 'Manager', NULL, '2022-01-01', 25000.00, NULL, 10);
INSERT INTO EMPLOYEE VALUES (2, 'Jane Smith', 'Clerk', 1, '2022-02-01', 22000.00, NULL, 20);
INSERT INTO EMPLOYEE VALUES (3, 'Alice Johnson', 'Analyst', 1, '2022-03-01', 23000.00, NULL, 10);
INSERT INTO EMPLOYEE VALUES (4, 'Bob Williams', 'Clerk', 2, '2022-04-01', 24000.00, NULL, 20);
INSERT INTO EMPLOYEE VALUES (5, 'Emily Brown', 'Manager', NULL, '2022-05-01', 26000.00, NULL, 30);

INSERT INTO DEPARTMENT VALUES (10, 'Sales', 'New York');
INSERT INTO DEPARTMENT VALUES (20, 'Finance', 'Los Angeles');
INSERT INTO DEPARTMENT VALUES (30, 'HR', 'Chicago');
INSERT INTO DEPARTMENT VALUES (40, 'IT', 'Houston');
INSERT INTO DEPARTMENT VALUES (50, 'Marketing', 'San Francisco');

-- ii. List the employees who annual salary is between 22000 and 25000.
SELECT *
FROM EMPLOYEE
WHERE salary * 12 BETWEEN 22000 AND 25000;

-- iii. List the employees names along with their manager names.
SELECT E1.ename AS employee_name, E2.ename AS manager_name
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON E1.manager = E2.empno;

-- iv. List the dept who employees maximum no of ‘CLERK’s.
SELECT D.dname
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.deptno = E.deptno
WHERE E.designation = 'Clerk'
GROUP BY D.dname
ORDER BY COUNT(*) DESC
FETCH FIRST ROW ONLY;

-- v. Write a trigger to ensure that salary of an employee is always greater than the commission.
CREATE OR REPLACE TRIGGER check_salary_commission
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF :NEW.commission IS NOT NULL AND :NEW.salary <= :NEW.commission THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary must be greater than commission');
    END IF;
END;
/



-- 12. Consider the following company database. 
-- EMPLOYEE(eno, name, dob, doj, designation, basicpay, deptno) 
-- DEPARTMENT(deptno, name) 
-- PROJECT(projno, name, deptno) 
-- WORKSFOR(eno, projno, hours) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. List the department number and the number of employees in each department. 
-- iii. List the details of employees who have worked in more than three projects on a day.  
-- iv. Develop a view that will keep track of the department number, the number of employees 
-- in the department and the total basic pay expenditure for each department. 
-- v. Write a PL/SQL to check whether the given number is Armstrong number or not. 


CREATE TABLE EMPLOYEE (
    eno INT PRIMARY KEY,
    name VARCHAR(50),
    dob DATE,
    doj DATE,
    designation VARCHAR(50),
    basicpay DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE PROJECT (
    projno INT PRIMARY KEY,
    name VARCHAR(50),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE WORKSFOR (
    eno INT,
    projno INT,
    hours INT,
    PRIMARY KEY (eno, projno),
    FOREIGN KEY (eno) REFERENCES EMPLOYEE(eno),
    FOREIGN KEY (projno) REFERENCES PROJECT(projno)
);

-- Inserting sample data for each relation
INSERT INTO DEPARTMENT VALUES (1, 'Sales');
INSERT INTO DEPARTMENT VALUES (2, 'Finance');
INSERT INTO DEPARTMENT VALUES (3, 'HR');
INSERT INTO DEPARTMENT VALUES (4, 'IT');
INSERT INTO DEPARTMENT VALUES (5, 'Marketing');

INSERT INTO EMPLOYEE VALUES (101, 'John Doe', '1990-01-01', '2020-01-01', 'Manager', 50000.00, 1);
INSERT INTO EMPLOYEE VALUES (102, 'Jane Smith', '1995-05-15', '2020-02-01', 'Analyst', 40000.00, 2);
INSERT INTO EMPLOYEE VALUES (103, 'Alice Johnson', '1992-08-20', '2020-03-01', 'Clerk', 30000.00, 3);
INSERT INTO EMPLOYEE VALUES (104, 'Bob Williams', '1993-11-10', '2020-04-01', 'Manager', 45000.00, 4);
INSERT INTO EMPLOYEE VALUES (105, 'Emily Brown', '1988-03-05', '2020-05-01', 'Analyst', 42000.00, 5);

INSERT INTO PROJECT VALUES (201, 'Project A', 1);
INSERT INTO PROJECT VALUES (202, 'Project B', 2);
INSERT INTO PROJECT VALUES (203, 'Project C', 3);
INSERT INTO PROJECT VALUES (204, 'Project D', 4);
INSERT INTO PROJECT VALUES (205, 'Project E', 5);

INSERT INTO WORKSFOR VALUES (101, 201, 40);
INSERT INTO WORKSFOR VALUES (102, 202, 45);
INSERT INTO WORKSFOR VALUES (103, 203, 50);
INSERT INTO WORKSFOR VALUES (104, 204, 55);
INSERT INTO WORKSFOR VALUES (105, 205, 60);

-- ii. List the department number and the number of employees in each department.
SELECT D.deptno, COUNT(*) AS num_employees
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.deptno = E.deptno
GROUP BY D.deptno;

-- iii. List the details of employees who have worked in more than three projects on a day.
SELECT E.*
FROM EMPLOYEE E
JOIN WORKSFOR W ON E.eno = W.eno
WHERE W.hours > 3;

-- iv. Develop a view that will keep track of the department number, the number of employees in the department, and the total basic pay expenditure for each department.
CREATE OR REPLACE VIEW department_pay_expenditure AS
SELECT D.deptno, COUNT(*) AS num_employees, SUM(E.basicpay) AS total_expenditure
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.deptno = E.deptno
GROUP BY D.deptno;

-- v. Write a PL/SQL to check whether the given number is Armstrong number or not.
CREATE OR REPLACE FUNCTION is_armstrong_number(num IN INT)
RETURN BOOLEAN
IS
    total_digits INT;
    temp_num INT := num;
    sum_digits INT := 0;
BEGIN
    total_digits := LENGTH(num);
    WHILE temp_num > 0 LOOP
        sum_digits := sum_digits + POWER(MOD(temp_num, 10), total_digits);
        temp_num := FLOOR(temp_num / 10);
    END LOOP;
    IF sum_digits = num THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/



-- 13. Consider the following employee and department tables. 
-- EMPLOYEE(empno, ename, designation, manager, hiredate, salary, commission, deptno) 
-- DEPARTMENT(deptno, dname, location) 
-- i. Create the above tables by properly specifying the primary keys and foreign keys and enter at least five tuples for each relation. 
-- ii. List the employees whose salary is greater than at least one of the employees of deptno 30 .
-- iii. List the name, job, salary of employees in the department with the highest average salary. 
-- iv. List the employees who are working either as manager or analyst with salary ranging from 
-- 2000 and 5000 . 
-- v. Write a trigger to ensure that no DML operations are allowed on employee table. 

CREATE TABLE EMPLOYEE (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    designation VARCHAR(50),
    manager INT,
    hiredate DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (manager) REFERENCES EMPLOYEE(empno),
    FOREIGN KEY (deptno) REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    location VARCHAR(100)
);

-- Inserting sample data for each relation
INSERT INTO EMPLOYEE VALUES (1, 'John Doe', 'Manager', NULL, '2022-01-01', 25000.00, NULL, 10);
INSERT INTO EMPLOYEE VALUES (2, 'Jane Smith', 'Clerk', 1, '2022-02-01', 22000.00, NULL, 20);
INSERT INTO EMPLOYEE VALUES (3, 'Alice Johnson', 'Analyst', 1, '2022-03-01', 23000.00, NULL, 10);
INSERT INTO EMPLOYEE VALUES (4, 'Bob Williams', 'Clerk', 2, '2022-04-01', 24000.00, NULL, 20);
INSERT INTO EMPLOYEE VALUES (5, 'Emily Brown', 'Manager', NULL, '2022-05-01', 26000.00, NULL, 30);

INSERT INTO DEPARTMENT VALUES (10, 'Sales', 'New York');
INSERT INTO DEPARTMENT VALUES (20, 'Finance', 'Los Angeles');
INSERT INTO DEPARTMENT VALUES (30, 'HR', 'Chicago');
INSERT INTO DEPARTMENT VALUES (40, 'IT', 'Houston');
INSERT INTO DEPARTMENT VALUES (50, 'Marketing', 'San Francisco');

-- ii. List the employees whose salary is greater than at least one of the employees of deptno 30.
SELECT *
FROM EMPLOYEE
WHERE salary > ANY (
    SELECT salary
    FROM EMPLOYEE
    WHERE deptno = 30
);

-- iii. List the name, job, salary of employees in the department with the highest average salary.
SELECT E.ename, E.designation, E.salary
FROM EMPLOYEE E
WHERE deptno = (
    SELECT deptno
    FROM (
        SELECT deptno, AVG(salary) AS avg_salary
        FROM EMPLOYEE
        GROUP BY deptno
        ORDER BY avg_salary DESC
        FETCH FIRST ROW ONLY
    )
);

-- iv. List the employees who are working either as manager or analyst with salary ranging from 2000 and 5000.
SELECT *
FROM EMPLOYEE
WHERE (designation = 'Manager' OR designation = 'Analyst') AND salary BETWEEN 2000 AND 5000;

-- v. Write a trigger to ensure that no DML operations are allowed on the employee table.
CREATE OR REPLACE TRIGGER prevent_dml_employee
BEFORE INSERT OR DELETE OR UPDATE ON EMPLOYEE
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'DML operations are not allowed on the employee table');
END;
/


-- 14. Consider the following relations for a transport management system application: 
-- BUS (ROUTENO, SOURCE, DESTINATION) 
-- DRIVER (DID, DNAME, DOB, GENDER) 
-- ASSIGN_ROUTE (DID, ROUTENO, JOURNEY_DATE) 
-- i. The primary keys are underlined. Identify the foreign keys and draw schema diagram 
-- ii. Create the above mentioned tables and populate the tables  
-- Note: Read all questions and populate values accordingly. 
-- iii. Include constraints that the routeNo starts with letter 'R' and gender of driver is always 
-- 'Male' 
-- iv. Develop a SQL query to list the details of drivers who have traveled more than three 
-- times on the same route 
-- v. Write PL/SQL program to check given number is odd or even.


CREATE TABLE BUS (
    ROUTENO INT PRIMARY KEY,
    SOURCE VARCHAR(100),
    DESTINATION VARCHAR(100)
);

CREATE TABLE DRIVER (
    DID INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DOB DATE,
    GENDER VARCHAR(1) CHECK (GENDER = 'M')
);

CREATE TABLE ASSIGN_ROUTE (
    DID INT,
    ROUTENO INT,
    JOURNEY_DATE DATE,
    PRIMARY KEY (DID, ROUTENO, JOURNEY_DATE),
    FOREIGN KEY (DID) REFERENCES DRIVER(DID),
    FOREIGN KEY (ROUTENO) REFERENCES BUS(ROUTENO)
);

-- ii. Create the above mentioned tables and populate the tables.
INSERT INTO BUS VALUES (1, 'City A', 'City B');
INSERT INTO BUS VALUES (2, 'City C', 'City D');
INSERT INTO BUS VALUES (3, 'City E', 'City F');
INSERT INTO BUS VALUES (4, 'City G', 'City H');
INSERT INTO BUS VALUES (5, 'City I', 'City J');

INSERT INTO DRIVER VALUES (101, 'John Doe', '1980-01-01', 'M');
INSERT INTO DRIVER VALUES (102, 'Jane Smith', '1985-02-15', 'M');
INSERT INTO DRIVER VALUES (103, 'Alice Johnson', '1978-08-20', 'M');
INSERT INTO DRIVER VALUES (104, 'Bob Williams', '1979-11-10', 'M');
INSERT INTO DRIVER VALUES (105, 'Emily Brown', '1975-03-05', 'M');

INSERT INTO ASSIGN_ROUTE VALUES (101, 1, '2022-01-01');
INSERT INTO ASSIGN_ROUTE VALUES (102, 2, '2022-02-01');
INSERT INTO ASSIGN_ROUTE VALUES (103, 3, '2022-03-01');
INSERT INTO ASSIGN_ROUTE VALUES (104, 4, '2022-04-01');
INSERT INTO ASSIGN_ROUTE VALUES (105, 5, '2022-05-01');

-- iii. Include constraints that the routeNo starts with letter 'R' and gender of driver is always 'Male'.
ALTER TABLE BUS ADD CONSTRAINT CHK_ROUTE_NO CHECK (ROUTENO LIKE 'R%');

-- iv. Develop a SQL query to list the details of drivers who have traveled more than three times on the same route.
SELECT D.*
FROM DRIVER D
JOIN ASSIGN_ROUTE AR ON D.DID = AR.DID
GROUP BY D.DID, D.DNAME
HAVING COUNT(*) > 3;

-- v. Write PL/SQL program to check given number is odd or even.
CREATE OR REPLACE FUNCTION check_odd_even(num IN INT)
RETURN VARCHAR2
IS
BEGIN
    IF MOD(num, 2) = 0 THEN
        RETURN 'Even';
    ELSE
        RETURN 'Odd';
    END IF;
END;
/


-- 15. Consider the following relations for a transport management system application: 
-- DRIVER (DCODE, DNAME, DOB, GENDER) 
-- CITY (CCODE, CNAME) 
-- TRUCK (TRUCKCODE, TTYPE) 
-- TTYPE can take two values (‘L’,’H’) 
-- L-Light , H- Heavy 
-- Each truck is assigned a unique truck code. There can be many trucks belonging to the same truck type. 
-- DRIVE_TRUCK (TRUCKCODE, DCODE, DOT, CCODE) 
-- DOT – Date of Trip 
-- i. The primary keys are underlined. Identify the foreign keys and draw schema diagram 
-- ii. Create the above mentioned tables and populate the tables 
-- iii. Include the constraint as mentioned above and the gender of driver is always 'male'. 
-- iv. Develop a SQL query to list the details of each driver and the number of trips traveled. 
-- v.  Create a view that displays the Driver details and also the city in which he drives a truck 


CREATE TABLE DRIVER (
    DCODE INT PRIMARY KEY,
    DNAME VARCHAR(50),
    DOB DATE,
    GENDER VARCHAR(1) CHECK (GENDER = 'M')
);

CREATE TABLE CITY (
    CCODE INT PRIMARY KEY,
    CNAME VARCHAR(100)
);

CREATE TABLE TRUCK (
    TRUCKCODE INT PRIMARY KEY,
    TTYPE VARCHAR(1) CHECK (TTYPE IN ('L', 'H'))
);

CREATE TABLE DRIVE_TRUCK (
    TRUCKCODE INT,
    DCODE INT,
    DOT DATE,
    CCODE INT,
    PRIMARY KEY (TRUCKCODE, DCODE, DOT),
    FOREIGN KEY (TRUCKCODE) REFERENCES TRUCK(TRUCKCODE),
    FOREIGN KEY (DCODE) REFERENCES DRIVER(DCODE),
    FOREIGN KEY (CCODE) REFERENCES CITY(CCODE)
);

-- ii. Create the above mentioned tables and populate the tables.
INSERT INTO DRIVER VALUES (101, 'John Doe', '1980-01-01', 'M');
INSERT INTO DRIVER VALUES (102, 'Jane Smith', '1985-02-15', 'M');
INSERT INTO DRIVER VALUES (103, 'Alice Johnson', '1978-08-20', 'M');
INSERT INTO DRIVER VALUES (104, 'Bob Williams', '1979-11-10', 'M');
INSERT INTO DRIVER VALUES (105, 'Emily Brown', '1975-03-05', 'M');

INSERT INTO CITY VALUES (201, 'City A');
INSERT INTO CITY VALUES (202, 'City B');
INSERT INTO CITY VALUES (203, 'City C');
INSERT INTO CITY VALUES (204, 'City D');
INSERT INTO CITY VALUES (205, 'City E');

INSERT INTO TRUCK VALUES (301, 'L');
INSERT INTO TRUCK VALUES (302, 'H');
INSERT INTO TRUCK VALUES (303, 'L');
INSERT INTO TRUCK VALUES (304, 'H');
INSERT INTO TRUCK VALUES (305, 'L');

INSERT INTO DRIVE_TRUCK VALUES (301, 101, '2022-01-01', 201);
INSERT INTO DRIVE_TRUCK VALUES (302, 102, '2022-02-01', 202);
INSERT INTO DRIVE_TRUCK VALUES (303, 103, '2022-03-01', 203);
INSERT INTO DRIVE_TRUCK VALUES (304, 104, '2022-04-01', 204);
INSERT INTO DRIVE_TRUCK VALUES (305, 105, '2022-05-01', 205);

-- iii. Include the constraint as mentioned above and the gender of driver is always 'male'.
-- Already included in table creation.

-- iv. Develop a SQL query to list the details of each driver and the number of trips traveled.
SELECT D.*, COUNT(DT.TRUCKCODE) AS num_trips
FROM DRIVER D
JOIN DRIVE_TRUCK DT ON D.DCODE = DT.DCODE
GROUP BY D.DCODE, D.DNAME;

-- v. Create a view that displays the Driver details and also the city in which he drives a truck.
CREATE OR REPLACE VIEW driver_city_details AS
SELECT D.*, C.CNAME
FROM DRIVER D
JOIN DRIVE_TRUCK DT ON D.DCODE = DT.DCODE
JOIN CITY C ON DT.CCODE = C.CCODE;


-- 16. Consider the following relational schema for Products Order database application: 
-- Products (p_id, p_name, retail_price, qty_on_hand) 
-- Orders (order_id, order_date) 
-- Order_details (order_number, product_number, qty_ordered) 
-- Where: order_number references order_id  product_number references p_id 
-- i. The primary keys are underlined. Identify the foreign keys and draw schema diagram 
-- ii. Create the above mentioned tables and populate the tables  
-- iii. Include the constraint on orderid that it starts with letter ‘O’.  
-- iv. Display the ProdID and the sum of quantity ordered for each product. 
-- v. Create a view that keeps track of P_id, price, order_id, qty_ordered and ordered_date. 
-- vi. Create a database TRIGGER, which deletes the order from Orders table, AFTER the deletion of corresponding order_number in Order_details. 


CREATE TABLE PRODUCTS (
    p_id INT PRIMARY KEY,
    p_name VARCHAR(50),
    retail_price DECIMAL(10, 2),
    qty_on_hand INT
);

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    order_date DATE CHECK (order_date LIKE 'O%')
);

CREATE TABLE ORDER_DETAILS (
    order_number INT,
    product_number INT,
    qty_ordered INT,
    FOREIGN KEY (order_number) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_number) REFERENCES PRODUCTS(p_id)
);

-- ii. Create the above mentioned tables and populate the tables.
INSERT INTO PRODUCTS VALUES (1, 'Product A', 100.00, 50);
INSERT INTO PRODUCTS VALUES (2, 'Product B', 150.00, 30);
INSERT INTO PRODUCTS VALUES (3, 'Product C', 200.00, 20);
INSERT INTO PRODUCTS VALUES (4, 'Product D', 250.00, 40);
INSERT INTO PRODUCTS VALUES (5, 'Product E', 300.00, 60);

INSERT INTO ORDERS VALUES (101, 'O2022-01-01');
INSERT INTO ORDERS VALUES (102, 'O2022-02-01');
INSERT INTO ORDERS VALUES (103, 'O2022-03-01');
INSERT INTO ORDERS VALUES (104, 'O2022-04-01');
INSERT INTO ORDERS VALUES (105, 'O2022-05-01');

INSERT INTO ORDER_DETAILS VALUES (101, 1, 10);
INSERT INTO ORDER_DETAILS VALUES (102, 2, 5);
INSERT INTO ORDER_DETAILS VALUES (103, 3, 15);
INSERT INTO ORDER_DETAILS VALUES (104, 4, 20);
INSERT INTO ORDER_DETAILS VALUES (105, 5, 25);

-- iii. Include the constraint on orderid that it starts with letter ‘O’.
-- Already included in table creation.

-- iv. Display the ProdID and the sum of quantity ordered for each product.
SELECT OD.product_number AS ProdID, SUM(OD.qty_ordered) AS total_ordered
FROM ORDER_DETAILS OD
GROUP BY OD.product_number;

-- v. Create a view that keeps track of P_id, price, order_id, qty_ordered and ordered_date.
CREATE OR REPLACE VIEW order_tracking AS
SELECT P.p_id, P.retail_price AS price, OD.order_number AS order_id, OD.qty_ordered, O.order_date AS ordered_date
FROM PRODUCTS P
JOIN ORDER_DETAILS OD ON P.p_id = OD.product_number
JOIN ORDERS O ON OD.order_number = O.order_id;

-- vi. Create a database TRIGGER, which deletes the order from Orders table, AFTER the deletion of corresponding order_number in Order_details.
CREATE OR REPLACE TRIGGER delete_order_trigger
AFTER DELETE ON ORDER_DETAILS
FOR EACH ROW
BEGIN
    DELETE FROM ORDERS WHERE order_id = :OLD.order_number;
END;
/

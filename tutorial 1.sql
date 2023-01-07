/*employee(employee-name, street, city)
works(employee-name, company-name, salary)
company(company-name, city)
manages (employee-name, manager-name)*/
-- Figure 5: Employee database.

/*1. Give an SQL schema definition for the employee database of Figure 5. Choose an appropriate
primary key for each relation schema, and insert any other integrity constraints (for example,
foreign keys) you find necessary.*/

create database db_EmployeeData;
show databases;
use db_EmployeeData;

create table Tbl_employee 
(
	employee_name varchar(255)  Primary key,
	street varchar(255),
	city varchar(255)
);

create table Tbl_works
(
	employee_name varchar(255)  Primary key,
	company_name varchar(255),
	salary int
);

create table Tbl_company
(
	company_name varchar(255)  Primary key,
	city varchar(255)
);

create table Tbl_manages
(
	employee_name varchar(255)  Primary key,
	manager_name varchar(255)
);

INSERT INTO tbl_employee (employee_name, street, city) VALUES 
  ('John Smith', '123 Main St', 'New York'),
  ('Jane Doe', '456 Market Ave', 'Chicago'),
  ('Bob Johnson', '789 Park Blvd', 'Los Angeles'),
  ('Alice Williams', '321 Maple St', 'Houston'),
  ('Mike Brown', '654 Oak Ave', 'Philadelphia'),
  ('Sarah Davis', '159 Pine St', 'Phoenix'),
  ('William Thompson', '753 Cedar St', 'San Antonio'),
  ('Ashley Johnson', '964 Birch Ave', 'San Diego'),
  ('David Anderson', '147 Maple St', 'Dallas'),
  ('Jessica Thompson', '753 Cedar St', 'San Francisco');

INSERT INTO tbl_works (employee_name, company_name, salary) VALUES 
  ('John Smith', 'Acme Inc', 75000),
  ('Jane Doe', 'Acme Inc', 80000),
  ('Bob Johnson', 'Acme Inc', 65000),
  ('Alice Williams', 'Acme Inc', 90000),
  ('Mike Brown', 'XYZ Corp', 75000),
  ('Sarah Davis', 'XYZ Corp', 80000),
  ('William Thompson', 'XYZ Corp', 65000),
  ('Ashley Johnson', 'ABC Inc', 90000),
  ('David Anderson', 'ABC Inc', 75000),
  ('Jessica Thompson', 'ABC Inc', 80000);

INSERT INTO tbl_company (company_name, city) VALUES
  ('new company 1','Chicago'),
  ('new company 2','New York'),
  ('Acme Inc', 'New York'),
  ('XYZ Corp', 'Chicago'),
  ('ABC Inc', 'Los Angeles');

INSERT INTO tbl_manages (employee_name, manager_name) VALUES
  ('Jane Doe', 'John Smith'),
  ('Bob Johnson', 'Jane Doe'),
  ('Alice Williams', 'Bob Johnson'),
  ('Mike Brown', 'John Smith'),
  ('Sarah Davis', 'Mike Brown'),
  ('William Thompson', 'Sarah Davis'),
  ('Ashley Johnson', 'William Thompson'),
  ('David Anderson', 'Ashley Johnson'),
  ('Jessica Thompson', 'David Anderson');
  
-- Add foreign key 
ALTER TABLE Tbl_works
ADD FOREIGN KEY (employee_name) REFERENCES Tbl_employee(employee_name);

ALTER TABLE Tbl_works
Add FOREIGN KEY(company_name) REFERENCES Tbl_company(company_name);

ALTER TABLE Tbl_manages
ADD FOREIGN KEY(employee_name) REFERENCES Tbl_employee(employee_name);

/* 2. Consider the employee database of Figure 5, where the primary keys are underlined. Give
an expression in SQL for each of the following queries:*/

-- (a) Find the names of all employees who work for First Bank Corporation.

SELECT employee_name FROM Tbl_works WHERE company_name = 'Acme Inc';  -- I used Acme Inc cause i made the database without "First Bank coorporation"

-- Note"::::::::: I have used "Acme Inc" instead of "First Bank coorporation" down below.

-- (b) Find the names and cities of residence of all employees who work for First Bank Corporation.

-- using subqueries
SELECT employee_name, city FROM tbl_employee WHERE employee_name IN
(SELECT employee_name FROM tbl_works WHERE company_name = 'Acme Inc'); 

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee
INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
WHERE Tbl_works.company_name = 'Acme Inc';

-- (c)  Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.

-- using Subqueries
SELECT Tbl_employee.employee_name, Tbl_employee.street, Tbl_employee.city FROM Tbl_employee WHERE employee_name IN
(SELECT employee_name FROM Tbl_works WHERE company_name = 'Acme Inc' AND salary > 10000); 

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.street, Tbl_employee.city FROM Tbl_employee
INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
WHERE Tbl_works.company_name = 'Acme Inc' AND Tbl_works.salary > 10000;

-- (d) Find all employees in the database who live in the same cities as the companies for which they work.

-- using subqueries
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee  WHERE Tbl_employee.city = 
(SELECT city FROM Tbl_company  WHERE Tbl_company.company_name = 
(SELECT company_name FROM Tbl_works WHERE Tbl_works.employee_name = Tbl_employee.employee_name));

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee
INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
INNER JOIN Tbl_company ON Tbl_works.company_name = Tbl_company.company_name
WHERE Tbl_company.city = Tbl_employee.city;

-- (e) Find all employees in the database who live in the same cities and on the same streets as do their managers.

INSERT INTO tbl_employee (employee_name, street, city) VALUES 
('Bikrant Bidari','123 Main St','New York' );
INSERT INTO tbl_works (employee_name, company_name, salary) VALUES 
('Bikrant Bidari', 'Acme Inc', 65000);
INSERT INTO tbl_manages (employee_name, manager_name) VALUES
  ('Bikrant Bidari', 'John Smith');




-- (f) Find all employees in the database who do not work for First Bank Corporation.
SELECT employee_name from Tbl_works WHERE company_name != 'Acme Inc';

-- (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT e1.employee_name
FROM employee e1
INNER JOIN works w1 ON e1.employee_name = w1.employee_name
WHERE w1.salary > ALL (
  SELECT w2.salary
  FROM works w2
  INNER JOIN employee e2 ON w2.employee_name = e2.employee_name
  INNER JOIN company c ON w2.company_name = c.company_name
  WHERE c.company_name = 'XYZ Corp'
);

-- (h) Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located.
SELECT * FROM Tbl_company
WHERE Tbl_company.city = (SELECT Tbl_company.city FROM Tbl_company WHERE Tbl_company.company_name = 'XYZ Corp');

-- (i) Find all employees who earn more than the average salary of all employees of their company.
SELECT tbl_works.employee_name, tbl_works.company_name FROM
(SELECT company_name, AVG(salary) AS average_salary
FROM tbl_works GROUP BY company_name) AS average
JOIN tbl_works ON average.company_name = tbl_works.company_name
WHERE tbl_works.salary > average.average_salary;

-- (j) Find the company that has the most employees.
SELECT company_name, employee_count FROM
(SELECT company_name, COUNT(employee_name) AS employee_count
FROM tbl_works GROUP BY company_name) as C1
ORDER BY employee_count DESC;


-- (k) Find the company that has the smallest payroll.
SELECT company_name, payroll FROM
(SELECT company_name, SUM(salary) AS payroll
 FROM tbl_works GROUP BY company_name) AS total_payroll
ORDER BY payroll ASC;

-- (l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation
-- will be using Acme Inc instead of First Bank Corporation
select c.company_name
from tbl_company c join tbl_works w
on c.company_name = w.company_name
group by c.company_name
having avg(w.salary) > (select avg(w2.salary)
                        from tbl_company c2 join
                             tbl_works w2
                             on c2.company_name = w2.company_name
                        where c2.company_name = 'Acme Inc'
                       );

/* 3. Consider the relational database of Figure 5. Give an expression in SQL for each of the
following queries:
*/

-- (a) Modify the database so that Jones now lives in Newtown.
select * from tbl_employee where employee_name='John Smith';

-- update city
UPDATE Tbl_employee
SET city='Newtown'
Where employee_name='John Smith';  -- used John Smith instead of Jones

-- (b) Give all employees of First Bank Corporation a 10 percent raise.

select * from tbl_works where company_name='Acme Inc';

-- update salary
UPDATE Tbl_works
SET salary=salary *1.1
Where company_name='Acme Inc';

-- NOTE::::::::::: using Acme Inc instead of First Bank Corporation
-- (c) Give all managers of First Bank Corporation a 10 percent raise.

UPDATE tbl_works 
SET salary = salary * 1.1
WHERE employee_name = ANY (SELECT DISTINCT manager_name  FROM tbl_manages) AND company_name = 'Acme Inc';

select * from tbl_works where company_name='Acme Inc';

-- (d) Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100,000; in such cases, give only a 3 percent raise.
UPDATE tbl_works w
INNER JOIN (
  SELECT e.employee_name
  FROM tbl_employee e
  INNER JOIN tbl_works w ON e.employee_name = w.employee_name
  INNER JOIN tbl_company c ON w.company_name = c.company_name
  WHERE c.company_name = 'Acme Inc'
  AND e.employee_name IN (
    SELECT m.manager_name
    FROM tbl_manages m
  )
) m ON w.employee_name = m.employee_name
SET w.salary = 
  CASE WHEN w.salary * 1.1 <= 100000 THEN w.salary * 1.1
  ELSE w.salary * 1.03
  END;

-- (e) Delete all tuples in the works relation for employees of Small Bank Corporation.
DELETE w FROM works w
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'XYZ Corp';



CREATE DATABASE depiMnf;
USE depiMnf;--database for company
CREATE TABLE Employee (
    SSN INT PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    BirthDate DATE NOT NULL,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    HirringDate DATE NOT NULL,
    DNUM INT,
    supervisor_id INT,
    manager_id INT,
   -- FOREIGN KEY (DNUM) REFERENCES department(DNUM),
    FOREIGN KEY (supervisor_id) REFERENCES Employee(SSN),
    FOREIGN KEY (manager_id) REFERENCES Employee(SSN)
);
CREATE TABLE department (
    DNUM INT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL UNIQUE,
    SSN INT,
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);
CREATE TABLE Dlocations (
    DNUM INT NOT NULL,
    location VARCHAR(50) NOT NULL,
    PRIMARY KEY (DNUM, location),
    FOREIGN KEY (DNUM) REFERENCES department(DNUM)
);
CREATE TABLE dependant (
    DependentName VARCHAR(50) NOT NULL,
    SSN INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    BirthDate DATE NOT NULL,
    Fname VARCHAR(50) NOT NULL,
    PRIMARY KEY (DependentName, SSN),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);
CREATE TABLE project (
    PNumber INT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL,
    DNUM INT NOT NULL,
    FOREIGN KEY (DNUM) REFERENCES department(DNUM)
);
CREATE TABLE EmployeeProject (
    PNumber INT NOT NULL,
    SSN INT NOT NULL,
    workingHours INT NOT NULL,
    PRIMARY KEY (PNumber, SSN),
    FOREIGN KEY (PNumber) REFERENCES project(PNumber),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_dnum
FOREIGN KEY (DNUM) REFERENCES department(DNUM);



INSERT INTO Employee (SSN, gender, BirthDate, Fname, Lname, HirringDate, DNUM, supervisor_id, manager_id)
VALUES 
(1001, 'Female', '2005-05-18', 'Sara', 'Ibrahim', '2020-06-15', 1, NULL, NULL),
(1002, 'Male', '1985-05-10', 'Ali', 'Hassan', '2010-03-01', 1, 1001, 1001),  
(1003, 'Male', '1988-11-30', 'Khaled', 'Omar', '2011-09-10', 2, NULL, NULL), 
(1004, 'Female', '1992-02-18', 'Mona', 'Ali', '2014-04-20', 2, 1003, 1003),
(1005, 'Male', '1987-12-05', 'Yasser', 'Mahmoud', '2013-01-12', 3, NULL, NULL);
INSERT INTO department (DNUM, DName, SSN)
VALUES 
(1, 'HR', NULL),
(2, 'IT', NULL),
(3, 'Finance', NULL);

UPDATE department SET SSN = 1001 WHERE DNUM = 1;
UPDATE department SET SSN = 1003 WHERE DNUM = 2;
UPDATE department SET SSN = 1005 WHERE DNUM = 3;

DELETE FROM dependant
WHERE DependentName = 'Sara' AND SSN = 1001;
SELECT Employee.SSN, Employee.Fname, Employee.Lname, EmployeeProject.PNumber, EmployeeProject.workingHours
FROM Employee
JOIN EmployeeProject ON Employee.SSN = EmployeeProject.SSN;







use depiMnf;--database for company

UPDATE Employee SET gender = 'M' WHERE gender = 'Male';

UPDATE Employee SET gender = 'F' WHERE gender = 'Female';

ALTER TABLE Employee
ADD CONSTRAINT chk_employee_gender CHECK (gender IN ('M', 'F'));

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_dnum
FOREIGN KEY (DNUM) REFERENCES department(DNUM)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE dependant
ADD CONSTRAINT chk_dependant_gender CHECK (gender IN ('M', 'F'));

ALTER TABLE EmployeeProject
ADD CONSTRAINT df_workingHours DEFAULT 0 FOR workingHours;

ALTER TABLE Employee
ADD Email VARCHAR(150);

UPDATE Employee SET Email = 'sara@example.com' WHERE SSN = 1001;
UPDATE Employee SET Email = 'ali@example.com' WHERE SSN = 1002;
UPDATE Employee SET Email = 'khaled@example.com' WHERE SSN = 1003;
UPDATE Employee SET Email = 'mona@example.com' WHERE SSN = 1004;
UPDATE Employee SET Email = 'yasser@example.com' WHERE SSN = 1005;

ALTER TABLE Employee
ADD CONSTRAINT uq_employee_email UNIQUE (Email);



ALTER TABLE dependant
ADD CONSTRAINT fk_dependant_employee
FOREIGN KEY (SSN) REFERENCES Employee(SSN)
ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE Employee
ALTER COLUMN Email VARCHAR(200);

ALTER TABLE Employee
DROP CONSTRAINT uq_employee_email;



CREATE DATABASE HR;
USE HR;
CREATE TABLE Employees (
    EmployeeID INT Identity(1,1) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    eMail VARCHAR(20) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    SALARY MONEY NOT NULL
);

CREATE TABLE Dependents (
    DependentID INT Identity(1,1) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Relationship VARCHAR(20) NOT NULL
);

CREATE TABLE Jobs (
    JobID INT Identity(1,1) PRIMARY KEY NOT NULL,
    JobTitle VARCHAR(20) NOT NULL,
    MinSalary MONEY NULL,
    MaxSalary MONEY NULL
);

CREATE TABLE Locations (
    LocationID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    StreetAddress VARCHAR(100) NULL,
    PostalCode VARCHAR(20) NULL,
    City VARCHAR(20) NOT NULL,
    StateProvince VARCHAR(20) NULL
);

CREATE TABLE Regions (
    RegionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    RegionName VARCHAR(20) NULL
);

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DepartmentName VARCHAR(20) NOT NULL
);

CREATE TABLE COUNTRIES (
    CountryID VARCHAR(2) PRIMARY KEY NOT NULL,
    CountryName VARCHAR(20) NULL
);

SELECT * FROM Employees;

ALTER TABLE Employees ADD JobId INT NULL, ManagerId INT NULL, DepartmentId INT NULL
GO

ALTER TABLE Employees
ADD CONSTRAINT [FK_Employees_Jobs_JobID] FOREIGN KEY([JobId])REFERENCES [dbo].[Jobs] ([JobId]),
CONSTRAINT [FK_Employees_Departments_DepartmentID] FOREIGN KEY([DepartmentId])REFERENCES [dbo].[Departments] ([DepartmentId]),
CONSTRAINT [FK_Employees_Employees_ManagerID] FOREIGN KEY([ManagerId])REFERENCES [dbo].[Employees] ([EmployeeId])

ALTER TABLE Dependents ADD EmployeeId INT NULL

ALTER TABLE Dependents
ADD CONSTRAINT [FK_Dependents_Employee_EmployeeId] FOREIGN KEY([EmployeeId])REFERENCES [dbo].[Employees] ([EmployeeId])

ALTER TABLE COUNTRIES ADD RegionId INT NULL

ALTER TABLE COUNTRIES
ADD CONSTRAINT [FK_COUNTRIES_Region_RegionId] FOREIGN KEY([RegionId])REFERENCES [dbo].[Regions] ([RegionId])

ALTER TABLE Locations ADD CountryId VARCHAR(2) NULL

ALTER TABLE COUNTRIES
ADD CONSTRAINT [FK_Locations_COUNTRIES_CountryId] FOREIGN KEY([CountryID])REFERENCES [dbo].[COUNTRIES] ([CountryId])

ALTER TABLE COUNTRIES DROP FK_Locations_COUNTRIES_CountryId
ALTER TABLE COUNTRIES DROP FK_COUNTRIES_Region_RegionId
ALTER TABLE Dependents DROP FK_Dependents_Employee_EmployeeId
ALTER TABLE Employees DROP FK_Employees_Employees_ManagerID
ALTER TABLE Employees DROP FK_Employees_Departments_DepartmentID
ALTER TABLE Employees DROP FK_Employees_Jobs_JobID

DROP TABLE COUNTRIES;
DROP TABLE Departments;
DROP TABLE Regions;
DROP TABLE Locations;
DROP TABLE Jobs;
DROP TABLE Dependents;
DROP TABLE Employees;

CREATE TABLE Regions (
    RegionId INT IDENTITY(1,1) NOT NULL,
    RegionName VARCHAR(25) DEFAULT NULL,
    CONSTRAINT [PK_Regions_RegionsId] PRIMARY KEY CLUSTERED ([RegionId] ASC)
)

CREATE TABLE Countries (
    CountryId CHAR(2) NOT NULL,
    CountryName VARCHAR(40) DEFAULT NULL,
    RegionId INT NOT NULL,
    CONSTRAINT [PK_Countries_CountryId] PRIMARY KEY ([CountryId] ASC),
    CONSTRAINT [FK_Countries_Regions_CountryId] FOREIGN KEY([RegionId])REFERENCES [dbo].[Regions] ([RegionId])
)

CREATE TABLE Locations (
    LocationId INT IDENTITY(1,1) NOT NULL,
    StreetAddress VARCHAR(40) DEFAULT NULL,
    PostalCode VARCHAR(12) DEFAULT NULL,
    City VARCHAR(30) NOT NULL,
    StateProvince VARCHAR(25) DEFAULT NULL,
    CountryId CHAR(2) NOT NULL,
    CONSTRAINT [PK_Locations_LocationId] PRIMARY KEY ([LocationId] ASC),
    CONSTRAINT [FK_Locations_Countries_LocationId] FOREIGN KEY([CountryId])REFERENCES [dbo].[Countries] ([CountryId])
)

CREATE TABLE Jobs (
    JobId INT IDENTITY(1,1) NOT NULL,
    Job_Title VARCHAR(35) NOT NULL,
    MinSalary MONEY DEFAULT NULL,
    MaxSalary MONEY DEFAULT NULL,
    CONSTRAINT [PK_Jobs_JobId] PRIMARY KEY CLUSTERED ([JobId] ASC)
)

CREATE TABLE Departments (
    DepartmentId INT IDENTITY(1,1) NOT NULL,
    DepartmentName VARCHAR(30) NOT NULL,
    LocationId INT DEFAULT NULL,
    CONSTRAINT [PK_Departments_DepartmentId] PRIMARY KEY ([DepartmentId] ASC),
    CONSTRAINT [FK_Departments_Locations_LocationId] FOREIGN KEY([LocationId])REFERENCES [dbo].[Locations] ([LocationId])
)

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    FirstName VARCHAR(20) DEFAULT NULL,
    LastName VARCHAR(25) NOT NULL,
    eMail VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(13) DEFAULT NULL,
    HireDate DATE NOT NULL,
    JobId INT NOT NULL,
    Salary MONEY NOT NULL,
    ManagerId INT NULL,
    DepartmentId INT NULL,
    CONSTRAINT [PK_Employees_EmployeeId] PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [FK_Employees_Departments_DepartmentId] FOREIGN KEY([DepartmentId])REFERENCES [dbo].[Departments] ([DepartmentId]),
    CONSTRAINT [FK_Employees_Employees_ManagerId] FOREIGN KEY([ManagerId])REFERENCES [dbo].[Employees] ([EmployeeId]),
    CONSTRAINT [FK_Employees_Jobs_JobId] FOREIGN KEY([JobId])REFERENCES [dbo].[Jobs] ([JobId])
)

CREATE TABLE Dependents (
    DependentId INT IDENTITY(1,1) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Relationship VARCHAR(25) NOT NULL,
    EmployeeId INT NOT NULL,
    CONSTRAINT [PK_Dependents_DependentId] PRIMARY KEY CLUSTERED ([DependentID] ASC),
    CONSTRAINT [FK_Dependets_Employee_EmployeeId] FOREIGN KEY([EmployeeId])REFERENCES [dbo].[Employees] ([EmployeeId])
)

EXEC sp_RENAME 'Jobs.Job_Title', 'JobTitle', 'COLUMN' /* Renaming Column Job_Title to JobTitle*/

ALTER TABLE Employees 
ADD Gender CHAR(1) NULL

ALTER TABLE Employees
DROP COLUMN Gender


/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Regions ON

INSERT INTO Regions (RegionId, RegionName) VALUES(1,'Europe')
INSERT INTO Regions (RegionId, RegionName) VALUES(2,'Americas')
INSERT INTO Regions (RegionId, RegionName) VALUES(3,'Asia')
INSERT INTO Regions (RegionId, RegionName) VALUES(4,'Middle East and Africa')

/* Adding 5th Row to the Regions Table  */
INSERT INTO Regions (RegionId, RegionName) VALUES(5,'Ocenia')

/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Regions OFF

INSERT INTO Countries (CountryId, CountryName, RegionId) VALUES(1,'USA',2)
INSERT INTO Countries (CountryId, CountryName, RegionId) VALUES(2,'India',3)
INSERT INTO Countries (CountryId, CountryName, RegionId) VALUES(3,'Mexico',2)
INSERT INTO Countries (CountryId, CountryName, RegionId) VALUES(4,'Germany',1)
INSERT INTO Countries (CountryId, CountryName, RegionId) VALUES(5,'Algeria',4)

/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Locations ON

INSERT INTO Locations (LocationId, StreetAddress, PostalCode, City, StateProvince, CountryId) VALUES(1,'800 West Renner Road',75080,'Richardson', 'Texas', 1)
INSERT INTO Locations (LocationId, StreetAddress, PostalCode, City, StateProvince, CountryId) VALUES(2,'16th Cross Malleswaram',560003,'Bengaluru', 'Karnataka', 2)
INSERT INTO Locations (LocationId, StreetAddress, PostalCode, City, StateProvince, CountryId) VALUES(3,'310 Manzana',77500,'Cancun', 'Quintana Roo', 3)
INSERT INTO Locations (LocationId, StreetAddress, PostalCode, City, StateProvince, CountryId) VALUES(4,'120 Mercedesstrasse',70372,'Stuttgart', 'Baden-Wurttemberg', 4)
INSERT INTO Locations (LocationId, StreetAddress, PostalCode, City, StateProvince, CountryId) VALUES(5,'Prom des Sablettes',4992,'Hussein Dey', 'Algiers', 5)

/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Locations OFF

/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Jobs ON

INSERT INTO Jobs (JobId, JobTitle, MinSalary, MaxSalary) VALUES(1,'Project Manager',100000,150000)
INSERT INTO Jobs (JobId, JobTitle, MinSalary, MaxSalary) VALUES(2,'Executive Engineer',75000,95000)
INSERT INTO Jobs (JobId, JobTitle, MinSalary, MaxSalary) VALUES(3,'Senior Engineer',60000,70000)
INSERT INTO Jobs (JobId, JobTitle, MinSalary, MaxSalary) VALUES(4,'Junior Engineer',50000,58000)
INSERT INTO Jobs (JobId, JobTitle, MinSalary, MaxSalary) VALUES(5,'Engineer Trainee',40000,48000)

/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Jobs OFF

/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Departments ON

INSERT INTO Departments (DepartmentId, DepartmentName, LocationId) VALUES(1,'Project Engineering',3)
INSERT INTO Departments (DepartmentId, DepartmentName, LocationId) VALUES(2,'Design and Drafting',4)
INSERT INTO Departments (DepartmentId, DepartmentName, LocationId) VALUES(3,'Production Engineering',1)
INSERT INTO Departments (DepartmentId, DepartmentName, LocationId) VALUES(4,'Application Engineering',2)
INSERT INTO Departments (DepartmentId, DepartmentName, LocationId) VALUES(5,'Quality Control and Testing',5)

/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Departments OFF

/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Employees ON

INSERT INTO Employees (EmployeeId, FirstName, LastName, eMail, PhoneNumber, HireDate, JobId, Salary, ManagerId, DepartmentId) VALUES(1,'Naveen','Jindal','naveenjindal@jsom.com','9728830011','2005-06-12',1,140000,001,1)
INSERT INTO Employees (EmployeeId, FirstName, LastName, eMail, PhoneNumber, HireDate, JobId, Salary, ManagerId, DepartmentId) VALUES(2,'Erik','Johnson','erikjohnson@ejcse.com','9728831069','2000-03-18',2,90000,002,4)
INSERT INTO Employees (EmployeeId, FirstName, LastName, eMail, PhoneNumber, HireDate, JobId, Salary, ManagerId, DepartmentId) VALUES(3,'Edith','Donnell','edithodonnell@eodsah.com','9728832058','2008-09-03',3,68000,003,2)
INSERT INTO Employees (EmployeeId, FirstName, LastName, eMail, PhoneNumber, HireDate, JobId, Salary, ManagerId, DepartmentId) VALUES(4,'Sebastian','Vettel','sebvettel@jsom.com','9728830018','2010-12-09',4,55000,004,5)
INSERT INTO Employees (EmployeeId, FirstName, LastName, eMail, PhoneNumber, HireDate, JobId, Salary, ManagerId, DepartmentId) VALUES(5,'Daniel','Ricciardo','dannyric@jsom.com','9728830017','2013-03-06',5,45000,005,3)


/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Employees OFF

/* Turn Identity Insert ON so records can be inserted in the Identity Column  */
SET IDENTITY_INSERT Dependents ON

INSERT INTO Dependents (DependentId, FirstName, LastName, Relationship, EmployeeId) VALUES(1,'Gisele','Bundchen','Wife',2)
INSERT INTO Dependents (DependentId, FirstName, LastName, Relationship, EmployeeId) VALUES(2,'Halle','Barry','Daughter',1)
INSERT INTO Dependents (DependentId, FirstName, LastName, Relationship, EmployeeId) VALUES(3,'Lee','Mckenzie','Wife',4)
INSERT INTO Dependents (DependentId, FirstName, LastName, Relationship, EmployeeId) VALUES(4,'Brad','Pitt','Husband',3)
INSERT INTO Dependents (DependentId, FirstName, LastName, Relationship, EmployeeId) VALUES(5,'Mel','Gibson','Father',5)

/* Turn Identity Insert OFF  */
SET IDENTITY_INSERT Employees OFF

select * from Employees;
select * from Dependents;
select * from Jobs;
select * from Countries;
select * from Locations;
select * from Regions;
select * from Departments;
USE HR;
/* HOMEWORK 4 Answers (queries) from line 5 to line 96 */
/* Tables and dataset for which queries were written can be found line 101 to line 506 */

/* #1 */
SELECT RegionID, COUNT(*) as CountriesCount
from Countries WITH (NOLOCK)
GROUP BY RegionId
ORDER BY CountriesCount DESC;

/* #2 */
SELECT EmployeeId, FirstName, LastName, Salary
from Employees WITH (NOLOCK)
WHERE Salary IN (SELECT MAX(Salary) from Employees WHERE DepartmentId = 5);

/* #3 */
SELECT TOP 5 * from Employees WITH (NOLOCK)
ORDER BY Salary DESC;

/* #4 */
SELECT TOP 1 e.EmployeeId, e.FirstName, e.LastName
FROM employees e WITH (NOLOCK)
WHERE (SELECT COUNT(*) FROM dependents d WHERE d.EmployeeID = e.EmployeeID) =
(SELECT MAX(depCount) FROM (SELECT COUNT(*) AS depCount FROM Dependents GROUP BY EmployeeId) AS depCounts);

/* #5 */
SELECT JobId, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY JobId;

/* #6 */
SELECT EmployeeId, FirstName, LastName, HireDate
from Employees WITH (NOLOCK)
WHERE YEAR(HireDate) = 2019;

/* #7 */
SELECT EmployeeId, FirstName, LastName, HireDate
from Employees WITH (NOLOCK)
WHERE YEAR(HireDate) <> 2016;

/* #8 */
SELECT EmployeeId, COUNT(EmployeeId) as No_of_Dependents
from Dependents WITH (NOLOCK)
GROUP BY EmployeeId
HAVING COUNT(EmployeeId) >= 2;

/* Tables Join */
/* #9 */
SELECT Regions.RegionId, Regions.RegionName, COUNT(c.CountryID) AS numCountries from Regions Regions WITH (NOLOCK)
INNER JOIN Countries c
ON Regions.RegionId = c.RegionId
GROUP BY Regions.RegionID, Regions.RegionName
ORDER BY COUNT(c.CountryID) DESC;

/* #10 */
SELECT l.LocationId, d.DepartmentId, d.DepartmentName, COUNT(e.EmployeeId) AS numEmployees
FROM Locations l
INNER JOIN Departments d ON l.LocationId = d.LocationId
INNER JOIN Employees e ON d.DepartmentId = e.DepartmentId
GROUP BY l.LocationId, d.DepartmentId, d.DepartmentName
ORDER BY COUNT(e.EmployeeId) DESC;

/* #11 */
SELECT e.EmployeeId, e.FirstName AS EmployeeFirstName, e.LastName As EmployeeLastName, d.FirstName AS DependentFirstName, 
d.LastName AS DependentLastName, d.Relationship AS Relationship
from Employees e WITH (NOLOCK)
INNER JOIN Dependents d
ON e.EmployeeId = d.EmployeeId
WHERE e.EmployeeId IN (SELECT EmployeeId FROM Dependents)
ORDER BY e.EmployeeId;

/* #12 */
SELECT e.EmployeeId, e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName, COUNT(d.EmployeeId) AS NumDependents
from Employees e WITH (NOLOCK)
LEFT JOIN Dependents d
ON e.EmployeeId = d.EmployeeId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY EmployeeId;

/* #13 */
SELECT e.EmployeeId, e.FirstName As EmployeeFirstName, e.LastName AS EmployeeLastName
from Employees e WITH (NOLOCK)
LEFT JOIN Dependents d
ON e.EmployeeId = d.EmployeeId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
HAVING COUNT(d.EmployeeId) = 0;

/* #14 */
SELECT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, e.Salary, j.JobTitle, d.DepartmentName, l.StreetAddress, l.PostalCode,
l.City, c.CountryName, r.RegionName
from Employees e WITH (NOLOCK)
INNER JOIN Jobs j ON e.JobId = j.JobId
INNER JOIN Departments d ON e.DepartmentId = d.DepartmentId
INNER JOIN Locations l ON d.LocationId = l.LocationId
INNER JOIN Countries c ON l.CountryId = c.CountryId
INNER JOIN Regions r ON c.RegionId = r.RegionId;


/* Tables and dataset for which the above queries were written can be found below from line 101 to line 506 */

CREATE DATABASE HR;
GO
USE HR;
GO

CREATE TABLE Regions (
	RegionId INT IDENTITY(1,1) NOT NULL,
	RegionName VARCHAR (25) DEFAULT NULL,
	CONSTRAINT [PK_Regions_RegionId] PRIMARY KEY (RegionId)
);

CREATE TABLE Countries (
	CountryId CHAR (2) NOT NULL,
	CountryName VARCHAR (40) DEFAULT NULL,
	RegionId INT NOT NULL,
	CONSTRAINT [PK_Countries_CountryID] PRIMARY KEY (CountryId),
	CONSTRAINT  [FK_Countries_Region_CountryId] FOREIGN KEY (RegionId) REFERENCES Regions (RegionId) 
);

CREATE TABLE Locations (
	LocationId INT IDENTITY(1,1) ,
	StreetAddress VARCHAR (40) DEFAULT NULL,
	PostalCode VARCHAR (12) DEFAULT NULL,
	City VARCHAR (30) NOT NULL,
	StateProvince VARCHAR (25) DEFAULT NULL,
	CountryId CHAR (2) NOT NULL,
	CONSTRAINT [PK_Locations_LocationId] PRIMARY KEY (LocationId),
	CONSTRAINT [FK_Locations_Countries_LocationId] FOREIGN KEY (CountryId) REFERENCES Countries (CountryId) 
);

CREATE TABLE Jobs (
	JobId INT IDENTITY(1,1) ,
	JobTitle VARCHAR (35) NOT NULL,
	MinSalary MONEY DEFAULT 10000.00,
	MaxSalary MONEY DEFAULT 10000000.00,
	CONSTRAINT [PK_Jobs_JobId] PRIMARY KEY (JobId)
);

CREATE TABLE Departments (
	DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
	DepartmentName VARCHAR (30) NOT NULL,
	LocationId INT DEFAULT NULL,
	CONSTRAINT [FK_Departments_Location_LocationId] FOREIGN KEY (LocationId) REFERENCES Locations (LocationId) 
);

CREATE TABLE Employees (
	EmployeeId INT IDENTITY(1,1) ,
	FirstName VARCHAR (20) DEFAULT NULL,
	LastName VARCHAR (25) NOT NULL,
	eMail VARCHAR (100) NOT NULL,
	PhoneNumber VARCHAR (20) DEFAULT NULL,
	HireDate DATE NOT NULL,
	JobId INT NOT NULL,
	Salary MONEY NOT NULL,
	ManagerId INT DEFAULT NULL,
	DepartmentId INT DEFAULT NULL,
	CONSTRAINT [PK_Employees_EmployeeId]PRIMARY KEY (EmployeeId),
	CONSTRAINT [FK_Employees_Jobs_JobId] FOREIGN KEY (JobId) REFERENCES Jobs (JobId) ,
	CONSTRAINT [FK_Employees_Departments_DepartmentId] FOREIGN  KEY (DepartmentId) REFERENCES Departments (DepartmentId) ,
	CONSTRAINT [FK_Employees_Employees_ManagerId] FOREIGN  KEY (ManagerId) REFERENCES Employees (EmployeeId),
	
);

CREATE TABLE Dependents (
	DependentId INT IDENTITY(1,1) ,
	FirstName VARCHAR (50) NOT NULL,
	LastName VARCHAR (50) NOT NULL,
	Relationship VARCHAR (25) NOT NULL,
	EmployeeId INT NOT NULL,
	CONSTRAINT [PK_Dependents_DependentId] PRIMARY KEY (DependentId),
	CONSTRAINT [FK_Dependents_Employee_EmployeeId] FOREIGN KEY (EmployeeId) REFERENCES Employees (EmployeeId) 
);

USE [HR]
GO

SET IDENTITY_INSERT [dbo].[Regions] ON 
GO
INSERT [dbo].[Regions] ([RegionId],[RegionName]) VALUES (1,'Europe')
GO
INSERT [dbo].[Regions] ([RegionId],[RegionName]) VALUES (2,'Americas')
GO
INSERT [dbo].[Regions] ([RegionId],[RegionName]) VALUES (3,'Asia')
GO
INSERT [dbo].[Regions] ([RegionId],[RegionName]) VALUES (4,'Middle East and Africa')
GO
SET IDENTITY_INSERT [dbo].[Regions] OFF
GO

INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('AR','Argentina',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('BO','Bolivia',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('PA','Paraguay',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('AU','Australia',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('NZ','New zealand',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('BE','Belgium',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('BR','Brazil',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('CA','Canada',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('CH','Switzerland',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('C','China',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('DE','Germany',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('DK','Denmark',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('EG','Egypt',4)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('FR','France',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('HK','HongKong',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('IL','Israel',4)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('I','India',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('IT','Italy',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('JP','Japa',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('KW','Kuwait',4)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('MX','Mexico',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('NG','Nigeria',4)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('NL','Netherlands',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('SG','Singapore',3)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('UK','United Kingdom',1)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('US','United States of America',2)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('ZM','Zambia',4)
GO
INSERT [dbo].[Countries] ([CountryId],[CountryName],[RegionId]) VALUES ('ZW','Zimbabwe',4)
GO

SET IDENTITY_INSERT [dbo].[Locations] ON 
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (1500,'2011 Interiors Blvd','99236','South San Francisco','California','US')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (1700,'2004 Charade Rd','98199','Seattle','Washingto','US')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (2400,'8204 Arthur St',NULL,'Londo',NULL,'UK')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (2500,'Magdalen Centre,The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (3000,'1098 Av. Paulista','01310-000','Sao Paulo','Brazil','BR')
GO
INSERT [dbo].[Locations] ([LocationId],[StreetAddress],[PostalCode],[City],[StateProvince],[CountryId]) VALUES (4000,'60 Aria Street','602580','Singapore','Singapore','SG')
GO
SET IDENTITY_INSERT [dbo].[Locations] OFF
GO

SET IDENTITY_INSERT [dbo].[Departments] ON 
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (1,'Administratio',1700)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (2,'Marketing',1800)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (3,'Purchasing',1700)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (4,'Human Resources',2400)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (5,'Shipping',1500)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (6,'IT',1400)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (7,'Public Relations',2700)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (8,'Sales',2500)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (9,'Executive',1700)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (10,'Finance',1700)
GO
INSERT [dbo].[Departments] ([DepartmentId],[DepartmentName],[LocationId]) VALUES (11,'Accounting',1700)
GO
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO

SET IDENTITY_INSERT [dbo].[jobs] ON 
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (1,'Public Accountant',42000.00,90000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (2,'Accounting Manager',82000.00,160000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (3,'Administration Assistant',30000.00,60000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (4,'President',200000.00,400000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (5,'Administration Vice President',150000.00,300000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (6,'Accountant',42000.00,90000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (7,'Finance Manager',82000.00,160000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (8,'Human Resources Representative',40000.00,90000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (9,'Programmer',40000.00,100000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (10,'Marketing Manager',90000.00,150000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (11,'Marketing Representative',40000.00,90000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (12,'Public Relations Representative',45000.00,105000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (13,'Purchasing Clerk',25000.00,55000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (14,'Purchasing Manager',80000.00,150000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (15,'Sales Manager',100000.00,200000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (16,'Sales Representative',60000.00,120000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (17,'Shipping Clerk',25000.00,55000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (18,'Stock Clerk',20000.00,50000.00)
GO
INSERT [dbo].[jobs] ([JobId],[JobTitle],[MinSalary],[MaxSalary]) VALUES (19,'Stock Manager',55000.00,85000.00)
GO
SET IDENTITY_INSERT [dbo].[jobs] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (100,'Steve','King','steven.king@sqltutorial.org','515.123.4567','2009-06-17',4,240000.00,NULL,9)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (101,'Neena','Kochhar','neena.kochhar@sqltutorial.org','515.123.4568','2011-09-21',5,170000.00,100,9)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (102,'Lex','De Haa','lex.de haan@sqltutorial.org','515.123.4569','2015-01-13',5,170000.00,100,9)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (103,'Alexander','Hunold','alexander.hunold@sqltutorial.org','590.423.4567','2012-01-03',9,90000.00,102,6)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (104,'Bruce','Ernst','bruce.ernst@sqltutorial.org','590.423.4568','2013-05-21',9,60000.00,103,6)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (105,'David','Austi','david.austin@sqltutorial.org','590.423.4569','2019-06-25',9,48000.00,103,6)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (106,'Valli','Pataballa','valli.pataballa@sqltutorial.org','590.423.4560','2020-02-05',9,48000.00,103,6)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (107,'Diana','Lorentz','diana.lorentz@sqltutorial.org','590.423.5567','2021-02-07',9,42000.00,103,6)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (108,'Nancy','Greenberg','nancy.greenberg@sqltutorial.org','515.124.4569','2016-08-17',7,120000.00,101,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (109,'Daniel','Faviet','daniel.faviet@sqltutorial.org','515.124.4169','2016-08-16',6,90000.00,108,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (110,'John','Che','Johnn.chen@sqltutorial.org','515.124.4269','2019-09-28',6,82000.00,108,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (111,'Ismael','Sciarra','ismael.sciarra@sqltutorial.org','515.124.4369','2019-09-30',6,77000.00,108,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (112,'Jose Manuel','Urma','jose manuel.urman@sqltutorial.org','515.124.4469','2020-03-07',6,78000.00,108,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (113,'Luis','Popp','luis.popp@sqltutorial.org','515.124.4567','2021-12-07',6,69000.00,108,10)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (114,'De','Raphaely','den.raphaely@sqltutorial.org','515.127.4561','2016-12-07',14,110000.00,100,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (115,'Alexander','Khoo','alexander.khoo@sqltutorial.org','515.127.4562','2017-05-18',13,31000.00,114,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (116,'Shelli','Baida','shelli.baida@sqltutorial.org','515.127.4563','2019-12-24',13,29000.00,114,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (117,'Sigal','Tobias','sigal.tobias@sqltutorial.org','515.127.4564','2019-07-24',12,28000.00,114,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (118,'Guy','Himuro','guy.himuro@sqltutorial.org','515.127.4565','2020-11-15',13,26000.00,114,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (119,'Kare','Colmenares','karen.colmenares@sqltutorial.org','515.127.4566','2021-08-10',13,25000.00,114,3)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (120,'Matthew','Weiss','matthew.weiss@sqltutorial.org','650.123.1234','2018-07-18',19,80000.00,100,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (121,'Adam','Fripp','adam.fripp@sqltutorial.org','650.123.2234','2019-04-10',19,82000.00,100,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (122,'Payam','Kaufling','payam.kaufling@sqltutorial.org','650.123.3234','2017-05-01',19,79000.00,100,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (123,'Shanta','Vollma','shanta.vollman@sqltutorial.org','650.123.4234','2019-10-10',19,65000.00,100,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (126,'Irene','Mikkilineni','irene.mikkilineni@sqltutorial.org','650.124.1224','2020-09-28',18,27000.00,120,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (145,'John','Russell','Johnn.russell@sqltutorial.org',NULL,'2018-10-01',15,140000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (146,'Kare','Partners','karen.partners@sqltutorial.org',NULL,'2019-01-05',15,135000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (176,'Jonatho','Taylor','jonathon.taylor@sqltutorial.org',NULL,'2020-03-24',16,86000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (177,'Jack','Livingsto','jack.livingston@sqltutorial.org',NULL,'2020-04-23',16,84000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (178,'Kimberely','Grant','kimberely.grant@sqltutorial.org',NULL,'2021-05-24',16,70000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (179,'Charles','Johnnso','charles.Johnnson@sqltutorial.org',NULL,'2022-01-04',16,62000.00,100,8)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (192,'Sarah','Bell','sarah.bell@sqltutorial.org','650.501.1876','2018-02-04',17,40000.00,123,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (193,'Britney','Everett','britney.everett@sqltutorial.org','650.501.2876','2019-03-03',17,39000.00,123,5)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (200,'Jennifer','Whale','jennifer.whalen@sqltutorial.org','515.123.4444','2009-09-17',3,44000.00,101,1)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (201,'Michael','Hartstei','michael.hartstein@sqltutorial.org','515.123.5555','2018-02-17',10,130000.00,100,2)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (202,'Pat','Fay','pat.fay@sqltutorial.org','603.123.6666','2019-08-17',11,60000.00,201,2)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (203,'Susa','Mavris','susan.mavris@sqltutorial.org','515.123.7777','2016-06-07',8,65000.00,101,4)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (204,'Herma','Baer','hermann.baer@sqltutorial.org','515.123.8888','2016-06-07',12,100000.00,101,7)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (205,'Shelley','Higgins','shelley.higgins@sqltutorial.org','515.123.8080','2016-06-07',2,120000.00,101,11)
GO
INSERT [dbo].[Employees] ([EmployeeId],[FirstName],[LastName],[eMail],[PhoneNumber],[HireDate],[JobId],[Salary],[ManagerId],[DepartmentId]) VALUES (206,'William','Gietz','william.gietz@sqltutorial.org','515.123.8181','2016-06-07',1,83000.00,205,11)
GO
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Penelope','Gietz','Child',206)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Nick','Higgins','Child',205)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Ed','Whale','Child',200)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Jennifer','King','Child',100)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Johnnny','Kochhar','Child',101)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Bette','De Haa','Child',102)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Grace','Faviet','Child',109)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Matthew','Che','Child',110)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Joe','Sciarra','Child',111)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Christia','Urma','Child',112)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Zero','Popp','Child',113)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Karl','Greenberg','Child',108)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Uma','Mavris','Child',203)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Vivie','Hunold','Child',103)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Cuba','Ernst','Child',104)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Fred','Austi','Child',105)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Hele','Pataballa','Child',106)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Da','Lorentz','Child',107)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Bob','Hartstei','Child',201)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Lucille','Fay','Child',202)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Kirste','Baer','Child',204)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Elvis','Khoo','Child',115)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Sandra','Baida','Spouse',116)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Camero','Tobias','Spouse',117)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Kevi','Himuro','Child',118)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Rip','Colmenares','Spouse',119)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Julia','Raphaely','Child',114)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Woody','Russell','Spouse',145)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Alec','Partners','Child',146)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Sandra','Taylor','Spouse',176)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Janna','King','Spouse',100)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'John','Kochhar','Spouse',101)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Julia','De Haa','Spouse',102)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Brett','De Haa','Child',102)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Valarie','Hunold','Spouse',103)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Vince','Hunold','Child',103)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Venessa','Hunold','Child',103)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Smith','Whale','Spouse',200)
GO
INSERT [dbo].[Dependents] ( [FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Lucy','Whale','Child',200)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Lilia','Whale','Child',200)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'David','Whale','Child',200)
GO
INSERT [dbo].[Dependents] ([FirstName],[LastName],[Relationship],[EmployeeId]) VALUES ( 'Willaim','Whale','Child',200)
GO
USE HR;

--- ###Question 1.###
CREATE PROCEDURE EmployeeProfileReport 
    @Salary DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    --- ###Question 1. (A)###
    CREATE TABLE #EmployeeProfileReport (
        EmployeeId INT NOT NULL,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        HireDate DATE NOT NULL,
        Salary DECIMAL(10,2) NOT NULL,
        departmentId INT NOT NULL,
        DepartmentName VARCHAR(50) NOT NULL,
        JobId INT NOT NULL,
        JobTitle VARCHAR(50) NOT NULL,
        CONSTRAINT PK_EmployeeProfileReport PRIMARY KEY (EmployeeId),
        CONSTRAINT UQ_EmployeeProfileReport_Name_HireDate UNIQUE (FirstName, LastName, HireDate),
    );
    CREATE NONCLUSTERED INDEX IX_EmployeeProfileReport_DepartmentJob
    ON #EmployeeProfileReport (departmentId, JobId);

    -- Case 1
    INSERT INTO #EmployeeProfileReport (EmployeeId, FirstName, LastName, HireDate, Salary, departmentId, DepartmentName, JobId, JobTitle)
    SELECT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, e.Salary, d.DepartmentId, d.DepartmentName, j.JobId, j.JobTitle
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentId = d.DepartmentId
    INNER JOIN Jobs j ON e.JobId = j.JobId
    WHERE e.Salary > @Salary;
    
    --- ###Question 1. (B)###
    -- Select data from temporary table
    SELECT * FROM #EmployeeProfileReport;
    
END;
GO

-- Execute stored procedure for Salary input parameter value of 85000
EXEC EmployeeProfileReport @Salary = 85000;
DROP PROCEDURE EmployeeProfileReport;

--- ###Question 1. (C)###

-- ###Case 1
EXECUTE EmployeeProfileReport 85000;

-- ###Case 2
ALTER PROCEDURE EmployeeProfileReport
@Salary INT
AS
BEGIN 
   SELECT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, e.Salary, d.DepartmentId, d.DepartmentName, j.JobId, j.JobTitle
    FROM Employees e
    JOIN Departments d ON e.DepartmentId = d.DepartmentId
    JOIN Jobs j ON e.JobId = j.JobId
	where e.Salary < @Salary;
END

EXECUTE EmployeeProfileReport 85000;


-- ###Case 3
ALTER PROCEDURE EmployeeProfileReport
@Salary INT
AS
BEGIN 
   SELECT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, e.Salary, d.DepartmentId, d.DepartmentName, j.JobId, j.JobTitle
    FROM Employees e
    JOIN Departments d ON e.DepartmentId = d.DepartmentId
    JOIN Jobs j ON e.JobId = j.JobId
	where e.Salary = @Salary;
END

EXECUTE EmployeeProfileReport 85000;

--- ###Question 2.###

CREATE PROCEDURE EmployeeProfileReportTableVariable
@Salary INT
AS
BEGIN

DECLARE @EmployeeProfileReport TABLE
(
--- ###Question 2. (B):(a)and(b)###
    EmployeeId INT PRIMARY KEY,   
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE,
    DepartmentId INT,
    Salary DECIMAL(8,2),
    DepartmentName VARCHAR(50),
    JobId INT,
    JobTitle VARCHAR(50),
    RegionName VARCHAR(50),
    CountryName VARCHAR(50),
    UNIQUE (FirstName, LastName, HireDate)
);

--- ###Question 2. (B):(c)###
-- We cannot establish a non-clustered index on the primary key because indexes must be unique, and jobId is neither a composite unique key 
-- nor a primary key.

--- ###Question 2. (A)###
INSERT INTO @EmployeeProfileReport
SELECT DISTINCT e.EmployeeId, e.FirstName, e.LastName, e.HireDate, e.DepartmentId, e.Salary, d.DepartmentName, e.JobId, j.JobTitle, r.RegionName, c.CountryName
FROM Employees e 
INNER JOIN Jobs j ON e.JobId = j.JobId 
INNER JOIN Departments d ON e.DepartmentId = d.DepartmentId 
INNER JOIN Locations l ON d.LocationId = l.LocationId 
INNER JOIN Countries c ON l.CountryId = c.CountryId 
INNER JOIN Regions r ON c.RegionId = r.RegionId
WHERE e.Salary > @Salary;

--- ###Question 2. (C)###
SELECT * FROM @EmployeeProfileReport;

END
GO
DROP PROCEDURE EmployeeProfileReportTableVariable;
--- ###Question 2. (D)###
-- ###Case 1
EXECUTE EmployeeProfileReportTableVariable 85000;

-- ###Case 2
ALTER PROCEDURE EmployeeProfileReportTableVariable
@Salary INT
AS
BEGIN 
	SELECT e.EmployeeId,e.FirstName,e.LastName,e.HireDate,e.Salary,e.DepartmentId,d.DepartmentName,e.jobId,j.jobTitle,r.RegionName,c.CountryName
	from Employees e 
    inner join jobs j on e.JobId = j.JobId 
    inner join Departments d on e.DepartmentId=d.DepartmentId 
    inner join Locations l on d.LocationId=l.LocationId 
    inner join Countries c on l.CountryId=c.CountryId 
    inner join Regions r on c.RegionId=r.RegionId
	where e.Salary < @Salary
END

EXECUTE EmployeeProfileReportTableVariable 85000;

-- ###Case 3
ALTER PROCEDURE EmployeeProfileReportTableVariable
@Salary INT
AS
BEGIN 
	SELECT e.EmployeeId,e.FirstName,e.LastName,e.HireDate,e.Salary,e.DepartmentId,d.DepartmentName,e.jobId,j.jobTitle,r.RegionName,c.CountryName
	from Employees e 
    inner join jobs j on e.JobId = j.JobId 
    inner join Departments d on e.DepartmentId=d.DepartmentId 
    inner join Locations l on d.LocationId=l.LocationId 
    inner join Countries c on l.CountryId=c.CountryId 
    inner join Regions r on c.RegionId=r.RegionId
	where e.Salary = @Salary
END

EXECUTE EmployeeProfileReportTableVariable 85000;




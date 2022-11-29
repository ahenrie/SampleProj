--Function to convert CalDate to DateID to be used in the TaskFacts table 

CREATE FUNCTION convertDate 

(@CalDate DATETIME) 

RETURNS INT 

AS 

BEGIN 

DECLARE @DateID INT; 

SELECT @DateID = DateID 

FROM dimDate 

WHERE CalDate = @CalDate; 

RETURN @DateID; 

END; 

GO 

-- Procedure to fill Dates dimension table with data. 

CREATE PROC fillDates 

(@StartDate DATETIME, @EndDate DATETIME) 

AS 

BEGIN 

WHILE @StartDate < @EndDate     

BEGIN 

INSERT INTO dimDate 

VALUES (@StartDate, DATENAME(WEEKDAY, @StartDate), 

--Hour of day added 

DATEPART(HOUR, @StartDate), 

DATEPART(WEEK, @StartDate), DATEPART(MONTH, @StartDate), DATEPART(QUARTER, @StartDate), YEAR(@StartDate),  getDate()); 

SET @StartDate = DATEADD(Minute, 1, @StartDate); 

END; 

END; 

GO 

 

EXEC fillDates @StartDate = '1/1/2019', @EndDate = '1/1/2023'; 

 

SELECT * FROM dimDate; 

GO 

 

-- Procedure to fill Departments dimension table with data with incremental updates. 

CREATE PROC fillDepartments 

AS 

BEGIN 

INSERT INTO dimDepartment 

SELECT DepartID, DepartName, GETDATE() 

FROM [AD\10914763].Department 

WHERE DepartID NOT IN (SELECT DepartID from dimDepartment); 

END; 

GO 

 

EXEC fillDepartments; 

 

SELECT * FROM dimDepartment; 

GO 

 

-- Procedure to fill Employee dimension table with data with incremental updates. 

CREATE PROC fillEmployees 

AS 

BEGIN 

INSERT INTO dimEmployee 

SELECT EmployeeID, CONCAT(EmpFName, ' ', EmpLName) AS EmpName, MobileNum, HireDate, ExitDate, GETDATE() 

FROM [AD\10914763].Employee 

WHERE EmployeeID NOT IN (SELECT EmployeeID from dimEmployee); 

END; 

GO 

 

EXEC fillEmployees; 

 

SELECT * FROM dimEmployee; 

GO 

 

-- Procedure to fill Customer Aggregate table with data using full replacement. 

CREATE PROC fillCustAgg 

AS 

BEGIN 

    DELETE FROM dimCustAgg; 

    INSERT INTO dimCustAgg 

    SELECT c.CustomerID, c.CustFName, c.CustLName, c.MobileNum, COUNT(t.TaskID), GETDATE() 

    FROM [AD\10914763].Customer c LEFT JOIN [AD\10914763].Task t 

    ON c.CustomerID = t.CustomerID 

    GROUP BY c.CustomerID, c.CustFName, c.CustLName, c.MobileNum; 

END; 

GO 

 

EXEC fillCustAgg; 

GO 

 

SELECT * FROM dimCustAgg; 

GO 

 

-- Procedure to fill Task Facts table with data using full replacement. 

CREATE PROC fillTaskFacts 

AS 

BEGIN 

    DELETE FROM dwTaskFacts 

    INSERT INTO dwTaskFacts 

    SELECT t.TaskID, e.EmployeeID, e.DepartID, c.CustomerID,  dbo.convertDate(StartTime),  dbo.convertDate(EndTime), t.ContactMode, t.Memo, t.StartTime, t.EndTime, GETDATE() 

    FROM [AD\10914763].Employee e JOIN  [AD\10914763].Task t 

    ON e.EmployeeID = t.EmpID JOIN [AD\10914763].Customer c 

    ON t.CustomerID = c.CustomerID; 

END; 

 

EXEC fillTaskFacts; 

 

SELECT * FROM dwTaskFacts; 

SELECT * FROM [AD\10914763].Task; 

 

-- Creating trigger to fire based on updates ran on Task table. 

CREATE TRIGGER taskUpdated ON [AD\10914763].Task 

AFTER UPDATE 

AS 

BEGIN 

UPDATE [AD\10914763].Task 

SET TaskUpdated = 'Y' 

WHERE TaskID IN (SELECT TaskID FROM INSERTED); 

END; 

GO 

 

-- Testing trigger 

UPDATE [AD\10914763].Task 

SET StartTime = '01/01/2019 07:00:00.000' 

WHERE TaskID = 13500; 

 

UPDATE [AD\10914763].Task 

SET EndTime = '01/01/2019 08:00:00.000' 

WHERE TaskID = 13500; 

 

UPDATE [AD\10914763].Task 

SET StartTime = '01/20/2019 09:15:00.000' 

WHERE TaskID = 13501; 

 

UPDATE [AD\10914763].Task 

SET EndTime = '01/21/2019 13:07:00.000' 

WHERE TaskID = 13501; 

GO 

 

-- Creating stored procedure to sync with trigger. 

CREATE PROC syncTaskDetails 

AS 

BEGIN 

DELETE FROM dwTaskFacts WHERE TaskID IN 

(SELECT TaskID FROM [AD\10914763].Task WHERE TaskUpdated = 'Y') 

-- Reinserting all records removed by above code 

INSERT INTO dwTaskFacts 

SELECT t.TaskID, e.EmployeeID, e.DepartID, c.CustomerID,  dbo.convertDate(StartTime),  dbo.convertDate(EndTime), t.ContactMode, t.Memo, t.StartTime, t.EndTime, GETDATE() 

    FROM [AD\10914763].Employee e JOIN  [AD\10914763].Task t 

    ON e.EmployeeID = t.EmpID JOIN [AD\10914763].Customer c 

    ON t.CustomerID = c.CustomerID 

WHERE TaskID IN (SELECT TaskID FROm [AD\10914763].Task WHERE TaskUpdated = 'Y'); 

DISABLE TRIGGER taskUpdated ON [AD\10914763].Task; 

UPDATE [AD\10914763].Task 

SET TaskUpdated = NULL 

WHERE TaskUpdated = 'Y'; 

ENABLE TRIGGER taskUpdated ON [AD\10914763].Task 

END; 

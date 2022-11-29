CREATE TABLE dimDate ( 

    DateID INT IDENTITY(1,1) PRIMARY KEY, 

    CalDate DATETIME, 

    DayOfTheWeek VARCHAR(9), 

    HourOfDay INT, 

    WeekOfYear INT, 

    MonthOfYear VARCHAR(9), 

    QuarterOfYear INT, 

    TaskYear INT, 

    RecTimestamp DATETIME); 

GO 

 

CREATE TABLE dimDepartment ( 

    DepartID INT PRIMARY KEY, 

    DepartName VARCHAR(25), 

    RecTimestamp DATETIME 

); 

GO 

 

CREATE TABLE dimEmployee ( 

    EmployeeID INT PRIMARY KEY, 

    EmpName VARCHAR(50), 

    MobileNum CHAR(10), 

    HireDate DATE, 

    ExitDate DATE, 

    RecTimestamp DATETIME 

); 

GO 

 

CREATE TABLE dimCustAgg ( 

    CustomerID INT PRIMARY KEY, 

    CustFName VARCHAR(20), 

    CustLName VARCHAR(20), 

    MobileNum CHAR(10), 

    NumTaskCompletion INT, 

    RecTimestamp DATETIME 

); 

GO 

 

CREATE TABLE dwTaskFacts ( 

    TaskID INT PRIMARY KEY, 

    EmployeeID INT REFERENCES dimEmployee(EmployeeID), 

    DepartID INT REFERENCES dimDepartment(DepartID), 

    CustomerID INT REFERENCES dimCustAgg(CustomerID), 

    StartDateID INT REFERENCES dimDate(DateID), 

    EndDateID INT REFERENCES dimDate(DateID), 

    ContactMode VARCHAR(20), 

    Memo VARCHAR(500), 

    StartTime DATETIME, 

    EndTime DATETIME, 

    RecTimestamp DATETIME 

); 

GO 

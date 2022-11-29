--Get parameters for sales associates
SELECT * FROM Employee
WHERE ExitDate IS NULL
AND DepartID = 11016;

SELECT * FROM Department;
SELECT * FROM Customer;

ALTER TRIGGER RandomSalesAssign
	ON Customer
	AFTER INSERT
AS
BEGIN
	IF UPDATE(CustomerID)
	BEGIN
	DECLARE @RandomNum INT
	--Generate Random EmployeeID
		SELECT @RandomNum = EmployeeID 
		FROM Employee 
		WHERE ExitDate IS NUll AND DepartID = 11016
		ORDER BY NEWID()
		OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY;
	--Auto Assign new CuOwner to new customer
		UPDATE Customer
		SET CuOwner = @RandomNum
		WHERE CuOwner IS NULL;
	END;
END;
GO

--Test trigger
INSERT INTO Customer
VALUES
('Josh', 'Smells', 'M', '1991-08-15', 'Black',NULL,NULL,NULL,NULL,12030,5116);

INSERT INTO Customer
VALUES
('Derrick', 'Smells', 'F', '1991-08-17', 'Hispanic',NULL,NULL,NULL,NULL,12030,5112);

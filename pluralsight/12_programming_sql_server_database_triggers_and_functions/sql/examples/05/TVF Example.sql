/*
  Now create the Multi-Statement, Table-Valued Funciton version
*/
CREATE OR ALTER FUNCTION dbo.SuperAdd_tvf(@a INT, @b INT)
RETURNS @SumValueTable TABLE 
( SumValue INT )
WITH SCHEMABINDING
AS
BEGIN
	INSERT INTO @SumValueTable (SumValue) 
		SELECT @a + @b;
	
	RETURN;
END;
GO


select * from dbo.SuperAdd_tvf(2,2);
GO



CREATE OR ALTER FUNCTION dbo.AverageCustomerSale(@CusomterID INT, @StartDate DATETIME, @EndDate DATETIME)
RETURNS @AverageCustomerSale TABLE 
( 
  CustomerID INT,
  MinimumSale Decimal(9,2),
  MaximumSale Decimal(9,2),
  AverageSale Decimal(9,2)
)
WITH SCHEMABINDING
AS
BEGIN

	IF(DATEDIFF(DAY,@StartDate,@EndDate) < 1)
	BEGIN
		SET @EndDate = DATEADD(DAY,10,@StartDate);
	END

	INSERT INTO @AverageCustomerSale
	SELECT O.CustomerID, MIN(TotalCost) MinimumSale, MAX(TotalCost) MaximumSale, AVG(TotalCost) AverageSale from Sales.Orders O
	CROSS APPLY (
	  SELECT SUM(Quantity + UnitPrice) TotalCost FROM Sales.OrderLines 
	  WHERE OrderId = O.OrderID
	) OL
	
	WHERE O.CustomerID = @CusomterID
	AND O.OrderDate >= @StartDate
	AND O.OrderDAte <= @EndDate
	GROUP BY O.CustomerID;

	
	RETURN;
END;
GO

/*
  Select a single customer's worth of data for a specific range
*/
SELECT * FROM dbo.AverageCustomerSale(10,'2015-01-01','2015-06-01');

SELECT * FROM dbo.AverageCustomerSale(10,'2015-01-01','2015-01-02');

SELECT * FROM dbo.AverageCustomerSale(10,'2015-01-01','2014-01-01');


/*
  Select all customers and their sales values for a specified range
*/
SELECT C.CustomerID, ACS.* FROM Sales.Customers C
	CROSS APPLY (
		SELECT * FROM dbo.AverageCustomerSale(C.CustomerID, '2015-01-01','2015-06-01')	
	) ACS
	WHERE MinimumSale > 100
GO





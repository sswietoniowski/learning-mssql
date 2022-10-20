/*
  Create simple ITVF
*/
CREATE OR ALTER FUNCTION dbo.SuperAdd_itvf(@a INT, @b INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN(SELECT @a + @b AS SumValue);
GO


select * from dbo.SuperAdd_itvf(2,2);
GO

select * from dbo.SuperAdd_itvf('a',2);
GO

/*
  Convert this to a CTE Example
*/
CREATE OR ALTER FUNCTION dbo.SuperAdd_itvf(@a INT, @b INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN(
	WITH SumValues AS (
		SELECT @a + @b AS SumValue
	)
	SELECT SumValue FROM SumValues
	)
GO


select * from dbo.SuperAdd_itvf(2,2);
GO

select * from dbo.SuperAdd_itvf('a',2);
GO



/*
	See the plan difference in real life between a MSTVF and ITVF
*/
CREATE OR ALTER FUNCTION dbo.FiscalYearEndingDB(@SaleDate DATETIME)
RETURNS @FiscalYearTable TABLE
(FiscalYear INT)
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @saleMonth INT = MONTH(@SaleDate);
	DECLARE @saleYear INT = YEAR(@SaleDate);
	DECLARE @fiscalYear INT = @saleYear;
	DECLARE @FiscalEndMonth INT;

	SELECT @FiscalEndMonth = CAST(SettingValue AS INT) FROM Application.Settings WHERE SettingName='FiscalEndMonth';

	IF(@saleMonth > @FiscalEndMonth AND @FiscalEndMonth != 1) 
	BEGIN
		SET @fiscalYear = @saleYear + 1;
	END;

	INSERT INTO @FiscalYearTable VALUES (@fiscalYear);

	RETURN;
END;
GO

/*
  Select more than 100 rows with this MSTVF
*/
SELECT OrderId, OrderDate, FY.FiscalYear as FiscalSaleYear from Sales.Orders SO
CROSS APPLY (
	SELECT * FROM dbo.FiscalYearEndingDB(SO.OrderDate)
) AS FY
 WHERE OrderDate > '2013-06-28'
GO


/*
  Convert to an ITVF
*/
CREATE OR ALTER FUNCTION dbo.FiscalYearEndingDB_ITVF(@SaleDate DATETIME)
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN(
		WITH EndMonth AS (
			SELECT CAST(SettingValue AS INT) AS FiscalEndMonth FROM Application.Settings WHERE SettingName='FiscalEndMonth'
		)
		SELECT CASE WHEN (MONTH(@SaleDate) > EM.FiscalEndMonth AND EM.FiscalEndMonth != 1) THEN
			YEAR(@SaleDate) + 1 ELSE YEAR(@SaleDate) END FiscalYear
		FROM EndMonth EM
	);
GO

/*
  See the difference in the query plan
*/
SELECT OrderId, OrderDate, FY.FiscalYear as FiscalSaleYear from Sales.Orders SO
CROSS APPLY (
	SELECT * FROM dbo.FiscalYearEndingDB_ITVF(SO.OrderDate)
) AS FY
 WHERE OrderDate > '2013-06-28'
GO

/*
  And the MSTVF again  
*/
SELECT OrderId, OrderDate, FY.FiscalYear as FiscalSaleYear from Sales.Orders SO
CROSS APPLY (
	SELECT * FROM dbo.FiscalYearEndingDB(SO.OrderDate)
) AS FY
 WHERE OrderDate > '2013-06-28'
GO











/*
  Convert the previous Multi-Statement Table-Valued Function into an
  Inline Table-Valued Function

  One challenge usually centers around using parameters when manipultaion
  was performed through a table variable or similar method. This example
  shows one way to use a Common Table Expression (CTE) to write the
  Inline SQL Statement with the modified variables.

*/
CREATE OR ALTER FUNCTION dbo.AverageCustomerSale_ITVF(@CustomerID INT, @StartDate DATETIME, @EndDate DATETIME)
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN (
	with ParameterData AS (
			SELECT CustomerID, @StartDate as StartDate,
			CASE WHEN DATEDIFF(DAY,@StartDate,@EndDate) < 1 then DATEADD(DAY,1,@StartDate) ELSE @EndDate END EndDate
			FROM Sales.Customers
		)
		SELECT PD.CustomerID, MIN(TotalCost) MinimumSale, MAX(TotalCost) MaximumSale, AVG(TotalCost) AverageSale FROM
			ParameterData PD INNER JOIN Sales.Orders O ON PD.CustomerID = O.CustomerID
		CROSS APPLY (
		  SELECT SUM(Quantity + UnitPrice) TotalCost FROM Sales.OrderLines 
		  WHERE OrderId = O.OrderID
		) OL
		WHERE 
		PD.CustomerID = @CustomerID
		AND O.OrderDate >= PD.StartDate
		AND O.OrderDate <= PD.EndDate
		GROUP BY PD.CustomerID
	);
GO

/*
  Select a single customer's worth of data for a specific range
*/
SELECT * FROM dbo.AverageCustomerSale_ITVF(10,'2015-01-01','2015-06-01');

SELECT * FROM dbo.AverageCustomerSale_ITVF(10,'2015-01-01','2015-01-02');

SELECT * FROM dbo.AverageCustomerSale_ITVF(10, '2015-01-01','2014-01-01');



/*
  Select all customers and their sales values for a specified range
*/
SELECT C.CustomerID, ACS.* FROM Sales.Customers C
	CROSS APPLY (
		SELECT * FROM dbo.AverageCustomerSale_ITVF(C.CustomerID, '2015-01-01','2015-06-01')	
	) ACS
	WHERE MinimumSale > 100
GO























set statistics time on;
/*
  Select all customers and their sales values for a specified range
*/
SELECT C.CustomerID, ACS.* FROM Sales.Customers C
	CROSS APPLY (
		SELECT * FROM dbo.AverageCustomerSale_ITVF(C.CustomerID, '2015-01-01','2015-06-01')	
	) ACS
	WHERE MinimumSale > 100
GO

/*
  Compare against the MSTVF
*/
SELECT C.CustomerID, ACS.* FROM Sales.Customers C
	CROSS APPLY (
		SELECT * FROM dbo.AverageCustomerSale(C.CustomerID, '2015-01-01','2015-06-01')	
	) ACS
	WHERE MinimumSale > 100
GO
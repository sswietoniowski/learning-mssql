USE [AdventureWorks2012];
GO

-- Create the procedure for testing purposes
IF OBJECT_ID('AnnualTop5SalesPersonByMonthlyPercent') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[AnnualTop5SalesPersonByMonthlyPercent];
END
GO

CREATE PROCEDURE [dbo].[AnnualTop5SalesPersonByMonthlyPercent] (@Year int)
AS
BEGIN
	CREATE TABLE [tempdb].[dbo].[MonthlyTotals] 
	([MonthNumber] INT PRIMARY KEY, [TotalSales] DECIMAL(18,2));
	
	INSERT INTO [tempdb].[dbo].[MonthlyTotals] ([MonthNumber], [TotalSales])
	SELECT (DATEPART(YEAR, [OrderDate])*100)+DATEPART(MONTH, [OrderDate]), SUM([TotalDue])
	FROM [Sales].[SalesOrderHeader]
	WHERE [SalesPersonID] IS NOT NULL
		AND DATEPART(YEAR, [OrderDate]) = @Year
	GROUP BY (DATEPART(YEAR, [OrderDate])*100)+DATEPART(MONTH, [OrderDate]);
	
	CREATE TABLE [tempdb].[dbo].[EmpSalesPercentByMonth]
	([SalesPersonID] INT, [MonthNumber] INT, [TotalSales] DECIMAL(18,2), [PercentMonthTotal] DECIMAL(18,2));
	
	INSERT INTO [tempdb].[dbo].[EmpSalesPercentByMonth] ([SalesPersonID], [MonthNumber], [TotalSales])
	SELECT [SalesPersonID], (DATEPART(YEAR, [OrderDate])*100)+DATEPART(MONTH, [OrderDate]), SUM([TotalDue])
	FROM [Sales].[SalesOrderHeader]
	WHERE [SalesPersonID] IS NOT NULL
		AND DATEPART(YEAR, [OrderDate]) = @Year	
	GROUP BY [SalesPersonID], (DATEPART(YEAR, [OrderDate])*100)+DATEPART(MONTH, [OrderDate]);

	CREATE CLUSTERED INDEX [IX_EmpSalesPercentByMonth_MonthNumber] 
	ON [tempdb].[dbo].[EmpSalesPercentByMonth] ([MonthNumber]);

	UPDATE [pbm]
	SET [pbm].[PercentMonthTotal] = [pbm].[TotalSales]/[mt].[TotalSales]
	FROM [tempdb].[dbo].[EmpSalesPercentByMonth] AS pbm
	INNER JOIN [tempdb].[dbo].[MonthlyTotals] AS mt 
		ON [pbm].[MonthNumber] = [mt].[MonthNumber];
	
	DROP TABLE [tempdb].[dbo].[MonthlyTotals];
	
	SELECT TOP 5 * 
	FROM [tempdb].[dbo].[EmpSalesPercentByMonth]
	ORDER BY [PercentMonthTotal] DESC;
	
	DROP TABLE [tempdb].[dbo].[EmpSalesPercentByMonth];
END;
GO

-- Start event session for recompile events




-- Run the following workload for testing
EXECUTE [AnnualTop5SalesPersonByMonthlyPercent] @Year=2005;
GO
EXECUTE [AnnualTop5SalesPersonByMonthlyPercent] @Year=2006;
GO
EXECUTE [AnnualTop5SalesPersonByMonthlyPercent] @Year=2007;
GO
EXECUTE [AnnualTop5SalesPersonByMonthlyPercent] @Year=2008;

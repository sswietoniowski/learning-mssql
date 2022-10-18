USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO

/*
	Set compat mode to 110 and
	set DB to use old CE,
	as if we just upgraded from SQL 2012
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] 
	SET COMPATIBILITY_LEVEL = 110;

USE [WideWorldImporters]
GO
ALTER DATABASE SCOPED CONFIGURATION 
	SET LEGACY_CARDINALITY_ESTIMATION = ON;
GO

/*
	Run a query
*/
USE [WideWorldImporters];
GO

SELECT 
	[ol].[StockItemID], 
	[ol].[Description], 
	[ol].[UnitPrice],
	[o].[CustomerID], 
	[o].[SalespersonPersonID],
	[o].[OrderDate]
FROM [Sales].[OrderLines] [ol]
JOIN [Sales].[Orders] [o]
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [ol].[Description] LIKE 'Superhero action jacket (Blue)%'
AND [o].[OrderDate] = '2016-08-22';
GO


/*
	Now set compat mode to 130
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] 
	SET COMPATIBILITY_LEVEL = 130;
GO

USE [WideWorldImporters]
GO
ALTER DATABASE SCOPED CONFIGURATION 
	SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

/*
	Re-run our query
*/
USE [WideWorldImporters];
GO

SELECT 
	[ol].[StockItemID], 
	[ol].[Description], 
	[ol].[UnitPrice],
	[o].[CustomerID], 
	[o].[SalespersonPersonID],
	[o].[OrderDate]
FROM [Sales].[OrderLines] [ol]
JOIN [Sales].[Orders] [o]
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [ol].[Description] LIKE 'Superhero action jacket (Blue)%'
AND [o].[OrderDate] = '2016-08-22';
GO

/*
	Could also use QUERYTRACEON hint to set CE
	Use TF 9481 to revert to old CE 
	Use TF 2312 to get new CE 
*/
SELECT 
	[ol].[StockItemID], 
	[ol].[Description], 
	[ol].[UnitPrice],
	[o].[CustomerID], 
	[o].[SalespersonPersonID],
	[o].[OrderDate]
FROM [Sales].[OrderLines] [ol]
JOIN [Sales].[Orders] [o]
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [ol].[Description] LIKE 'Superhero action jacket (Blue)%'
AND [o].[OrderDate] = '2016-08-22'
OPTION (QUERYTRACEON 9481); 
GO


/*
	How do we see problems with estimates?
*/
DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160808';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;
GO


/*
	Add on to our code
*/
DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160808';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN @ItemHx [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5;
GO

/*
	Try a larger date range
*/

DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160831';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN @ItemHx [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5;
GO


/*
	Force a recompile
*/

DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160831';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN @ItemHx [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5
OPTION (RECOMPILE);
GO


/*
	Using trace flag 2453
	SQL Server 2012 SP2 
	SQL Server 2014 CU3
	https://support.microsoft.com/en-us/kb/2952444
	http://sqlperformance.com/2014/06/t-sql-queries/table-variable-perf-fix
*/
DBCC TRACEON (2453);
GO	

DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160831';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN @ItemHx [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5;
GO

DBCC TRACEOFF (2453);
GO	


/*
	Can also try a temp table
*/
DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160831';

SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
INTO #ItemHX
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN #ItemHX [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5;

DROP TABLE #ItemHX;
GO


/*
	Start with a clean copy of WWI
*/
USE [master];
GO
RESTORE DATABASE [WideWorldImporters] 
FROM  DISK = N'C:\Backups\WideWorldImportersEnlarged.bak' 
WITH  FILE = 1,  
MOVE N'WWI_Primary' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters.mdf',  
MOVE N'WWI_UserData' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters_UserData.ndf',  
MOVE N'WWI_Log' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters.ldf',  
MOVE N'WWI_InMemory_Data_1' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters_InMemory_Data_1',  
NOUNLOAD, 
REPLACE, 
STATS = 5;
GO

/*
	Create a procedure for testing
*/
USE [WideWorldImporters];
GO

DROP PROCEDURE IF EXISTS [Sales].[usp_GetFullProductInfo];
GO

CREATE PROCEDURE [Sales].[usp_GetFullProductInfo]
	@StockItemID INT
AS	

	SELECT 
		[o].[CustomerID], 
		[o].[OrderDate], 
		[ol].[StockItemID], 
		[ol].[Quantity],
		[ol].[UnitPrice]
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	ORDER BY [o].[OrderDate] DESC;

	SELECT
		[o].[CustomerID], 
		SUM([ol].[Quantity]*[ol].[UnitPrice])
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	GROUP BY [o].[CustomerID]
	ORDER BY [o].[CustomerID] ASC;
GO

/*
	Enable actual plan and STATISTICS IO
	Execute the stored procecdure
*/
SET STATISTICS IO ON;
GO

EXEC [Sales].[usp_GetFullProductInfo] 90 WITH RECOMPILE;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224 WITH RECOMPILE;
GO

SET STATISTICS IO OFF;
GO

/*
	Add some data...as may happen during a normal day
*/
INSERT INTO [Sales].[OrderLines]
	([OrderLineID], [OrderID], [StockItemID], 
	[Description], [PackageTypeID], [Quantity], 
	[UnitPrice], [TaxRate], [PickedQuantity], 
	[PickingCompletedWhen], [LastEditedBy], 
	[LastEditedWhen])
SELECT 
	[OrderLineID] + 800000, [OrderID], [StockItemID], 
	[Description], [PackageTypeID], [Quantity] + 2, 
	[UnitPrice], [TaxRate], [PickedQuantity], 
	NULL, [LastEditedBy], SYSDATETIME() 
FROM [WideWorldImporters].[Sales].[OrderLines]
WHERE [OrderID] > 54999;
GO


/*
	Re-run the stored procedures
*/	
SET STATISTICS IO ON;
GO

EXEC [Sales].[usp_GetFullProductInfo] 90 WITH RECOMPILE;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224 WITH RECOMPILE;
GO

SET STATISTICS IO OFF;
GO



/*
	There's a recommended index, but what if this is
	a third-party application, and you cannot
	change or add indexes?

	Determine which plan is "better" to force 
	
	For a stored procedure, use an OBJECT plan guide
	For a stand-along query, use a SQL or TEMPLATE plan guide 
*/
EXEC sp_create_plan_guide   
    @name =  N'ProductInfo_SP_PlanGuide1',  
    @stmt = N'SELECT 
		[o].[CustomerID], 
		[o].[OrderDate], 
		[ol].[StockItemID], 
		[ol].[Quantity],
		[ol].[UnitPrice]
		FROM [Sales].[Orders] [o]
		JOIN [Sales].[OrderLines] [ol]
			ON [o].[OrderID] = [ol].[OrderID]
		WHERE [ol].[StockItemID] = @StockItemID
		ORDER BY [o].[OrderDate] DESC;',  
    @type = N'OBJECT',  
    @module_or_batch = N'[Sales].[usp_GetFullProductInfo]',  
    @params = NULL,  
    @hints = N'OPTION (OPTIMIZE FOR (@StockItemID = 90))'; 

EXEC sp_create_plan_guide   
    @name =  N'ProductInfo_SP_PlanGuide2',  
    @stmt = N'SELECT
		[o].[CustomerID], 
		SUM([ol].[Quantity]*[ol].[UnitPrice])
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	GROUP BY [o].[CustomerID]
	ORDER BY [o].[CustomerID] ASC;',  
    @type = N'OBJECT',  
    @module_or_batch = N'[Sales].[usp_GetFullProductInfo]',  
    @params = NULL,  
    @hints = N'OPTION (OPTIMIZE FOR (@StockItemID = 90))'; 

/*
	Re-run the stored procedures
*/	
EXEC [Sales].[usp_GetFullProductInfo] 90 WITH RECOMPILE;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224 WITH RECOMPILE;
GO


/*
	Run it with another value...
	How do we know if a plan guide is being used?
*/
EXEC [Sales].[usp_GetFullProductInfo] 130;
GO


/*
	What about an individual query?
	Run each query separately
*/
SET STATISTICS IO ON;
GO

SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [ol].[StockItemID] = 90
ORDER BY [o].[OrderDate] DESC;
GO

SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [ol].[StockItemID] = 224
ORDER BY [o].[OrderDate] DESC;
GO

SET STATISTICS IO OFF;
GO

/*
	Find the plan in cache
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].execution_count, 
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM [sys].[dm_exec_query_stats] AS [qs]
CROSS APPLY [sys].[dm_exec_query_plan] ([qs].[plan_handle]) AS [qp]
CROSS APPLY [sys].[dm_exec_sql_text]([qs].[plan_handle]) AS [s]
WHERE [s].[text] LIKE '%OrderLines%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO


/*
	Remove the plan(s) from cache
*/
DBCC FREEPROCCACHE(
	0x060005003F601709601F24DC8002000001000000000000000000000000000000000000000000000000000000
	);
GO
DBCC FREEPROCCACHE(
	0x060005009BE23A08E01724DC8002000001000000000000000000000000000000000000000000000000000000
	);
GO

/*
	Create a query template first,
	use that in the guide
*/
DECLARE @SQLStatement NVARCHAR(MAX);
DECLARE @Parameters NVARCHAR(MAX);
EXEC sp_get_query_template 
    N'SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [ol].[StockItemID] = 90
ORDER BY [o].[OrderDate] DESC',
	@SQLStatement OUTPUT,
	@Parameters OUTPUT
	  
EXEC sp_create_plan_guide   
    @name =  N'ProductInfo_Query_PlanGuide',  
	@stmt = @SQLStatement,
    @type = N'TEMPLATE',  
    @module_or_batch = NULL,  
    @params = @Parameters,  
    @hints = N'OPTION (PARAMETERIZATION FORCED)'; 

/*
	Re-run the queries 
*/
SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [ol].[StockItemID] = 90
ORDER BY [o].[OrderDate] DESC;
GO

SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [ol].[StockItemID] = 224
ORDER BY [o].[OrderDate] DESC;
GO

/*
	Change casing and spacing,
	what happens to the plan?
*/
SELECT 
	[o].[CustomerID], 
	[o].[OrderDate], 
	[ol].[StockItemID], 
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
WHERE ol.stockitemid =    224
ORDER BY [o].[OrderDate] DESC;
GO

/*
	Check to see what plan guides exist
*/
SELECT *
FROM [sys].[plan_guides];
GO

/*
	Any issues with using the plan guide?
*/
SELECT *
FROM sys.fn_validate_plan_guide (65536);
GO

SELECT *
FROM sys.fn_validate_plan_guide (65537);
GO

SELECT *
FROM sys.fn_validate_plan_guide (65539);
GO


/*
	Remove ALL plan guides in a database
*/
USE [WideWorldImporters];
GO  
EXEC sp_control_plan_guide N'DROP ALL';  
GO  


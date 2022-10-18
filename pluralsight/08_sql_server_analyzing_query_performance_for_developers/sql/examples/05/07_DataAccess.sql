USE [WideWorldImporters];
GO


/*
	https://www.sqlskills.com/blogs/kimberly/sp_helpindex-v20170228/
*/
EXEC sp_SQLskills_helpindex 'Sales.Orders';
GO

SET STATISTICS IO ON;
GO
SET STATISTICS TIME ON;
GO


/*
	create a copy of the table
*/
SELECT *
INTO [Sales].[Copy_Orders]
FROM [Sales].[Orders];
GO


/*
	Include actual plan
	Table scan (against a heap)
	*Note IO and CPU
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Copy_Orders]
WHERE [CustomerID] > 550;
GO


/*
	Can we make this better?
*/
CREATE NONCLUSTERED INDEX [IX_Copy_Orders_CustomerID]
	ON [Sales].[Copy_Orders] (
		[CustomerID]
		)
	INCLUDE (
		[OrderID], [OrderDate]
		);
GO


/*
	Re-run
	*Compare IO and CPU
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Copy_Orders]
WHERE [CustomerID] > 550;
GO


/*
	Index scan (clustered)
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Orders]
WHERE [CustomerID] > 550;
GO


/*
	Index scan (clustered)
	But does it scan the entire index?
	How do you know?
*/
SELECT TOP 10 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Orders]
WHERE [CustomerID] > 550;
GO


/*
	Re-run the two queries together to compare
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Orders]
WHERE [CustomerID] > 550;
GO

SELECT TOP 10 
	[CustomerID], 
	[OrderID], 
	[OrderDate]
FROM [Sales].[Orders]
WHERE [CustomerID] > 550;
GO


/*
	Index scan (nonclustered)
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 30000;
GO


/*
	What if we run the same query,
	but with a different OrderID?
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 60000;
GO


/*
	So should we always want the seek?
	*Check IO and CPU
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 30000;
GO

SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 60000;
GO


/*
	What if I force a scan?
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 30000;
GO

SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] > 60000;
GO

SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders] WITH (INDEX(FK_Sales_Orders_CustomerID))
WHERE [OrderID] > 60000;
GO


/*
	Check our indexes
*/
EXEC sp_SQLskills_helpindex 'Sales.Orders';
GO


/*
	Check index usage stats for two indexes
*/
SELECT 
	[index_id], 
	[singleton_lookup_count], 
	[range_scan_count]
FROM sys.dm_db_index_operational_stats
(DB_ID(), OBJECT_ID('Sales.Orders'), NULL, NULL)
WHERE [index_id] IN (1,2);
GO


/*
	Rebuild to clear out index info
*/
ALTER INDEX [PK_Sales_Orders] ON [Sales].[Orders] REBUILD;
GO
ALTER INDEX [FK_Sales_Orders_CustomerID] ON [Sales].[Orders] REBUILD;
GO


/*
	Verify stats reset
*/
SELECT 
	[index_id], 
	[singleton_lookup_count], 
	[range_scan_count]
FROM sys.dm_db_index_operational_stats
(DB_ID(), OBJECT_ID('Sales.Orders'), NULL, NULL)
WHERE [index_id] IN (1,2);
GO



/*
	Nonclustered index seek
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [OrderID] = 40000;
GO


/*
	What type of seek?
*/
SELECT 
	[index_id], 
	[singleton_lookup_count], 
	[range_scan_count]
FROM sys.dm_db_index_operational_stats
(DB_ID(), OBJECT_ID('Sales.Orders'), NULL, NULL)
WHERE [index_id] IN (1,2);
GO


/*
	Another nonclustered index seek
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [CustomerID] = 1065;
GO


/*
	What type of seek?
*/
SELECT 
	[index_id], 
	[singleton_lookup_count], 
	[range_scan_count]
FROM sys.dm_db_index_operational_stats
(DB_ID(), OBJECT_ID('Sales.Orders'), NULL, NULL)
WHERE [index_id] IN (1,2);
GO


/*
	One more nonclustered index seek
*/
SELECT 
	[CustomerID], 
	[OrderID]
FROM [Sales].[Orders]
WHERE [CustomerID] > -1;
GO


/*
	Clean up
*/
DROP TABLE [Sales].[Copy_Orders];
GO

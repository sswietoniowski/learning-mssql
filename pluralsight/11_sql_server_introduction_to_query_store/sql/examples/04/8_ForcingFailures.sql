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
	Enable Query Store with settings we want
*/
USE [master];
GO

ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE = ON;
GO

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE, 
	CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), 
	DATA_FLUSH_INTERVAL_SECONDS = 60,  
	INTERVAL_LENGTH_MINUTES = 5, 
	MAX_STORAGE_SIZE_MB = 100, 
	QUERY_CAPTURE_MODE = ALL, 
	SIZE_BASED_CLEANUP_MODE = AUTO, 
	MAX_PLANS_PER_QUERY = 200)
GO

/*
	Clear out any old data, just in case
*/
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE CLEAR;
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
	Enable actual plan 
	Execute the stored procecdure
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
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
	Re-run the stored procedure, 
	check the plan
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	What do we see in Query Store?
*/


/*
	Add the "recommended" index
*/
USE [WideWorldImporters];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice]);
GO

/*
	Note the index ID
*/
SELECT *
FROM [sys].[indexes]
WHERE [object_id] = OBJECT_ID(N'Sales.OrderLines')
AND [type] = 2;
GO

/*
	Remove SP plans from cache so it will
	use the new index
*/
SELECT 
	[qs].[execution_count], 
	[s].[text], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM [sys].[dm_exec_query_stats] [qs]
CROSS APPLY [sys].[dm_exec_query_plan] ([qs].[plan_handle]) [qp]
CROSS APPLY [sys].[dm_exec_sql_text]([qs].[plan_handle]) s
JOIN [sys].[dm_exec_cached_plans] [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%GetFullProduct%';
GO

DBCC FREEPROCCACHE(
	0x05000500996DB224C08280EA8002000001000000000000000000000000000000000000000000000000000000
	);
GO


/*
	Run the SP again and check the plan
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

/*
	Within QS, force the plan
	Re-run queries and confirm plan
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

EXEC [Sales].[usp_GetFullProductInfo] 150;
GO

/*
	What happens if we drop the index?
*/
DROP INDEX [NCI_OrderLines_StockItemID] 
	ON [Sales].[OrderLines];
GO


/*
	Re-run and check the plan
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

EXEC [Sales].[usp_GetFullProductInfo] 150;
GO


/*
	Check status of forced plan
	All reasons listed in MSDN:
	https://msdn.microsoft.com/en-us/library/dn818155.aspx
*/
SELECT 
	[p].[plan_id], 
	[p].[query_id], 
	[q].[object_id] AS containing_object_id,
    [p].[force_failure_count], 
	[p].[last_force_failure_reason_desc]
FROM [sys].[query_store_plan] AS [p]
JOIN [sys].[query_store_query] AS [q]
	ON [p].[query_id] = [q].[query_id]
WHERE [is_forced_plan] = 1;
GO

/*
	The count doesn't increment per failure
*/
EXEC [Sales].[usp_GetFullProductInfo] 90;
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

EXEC [Sales].[usp_GetFullProductInfo] 150;
GO

/*
	Check one more time
*/
SELECT 
	[p].[plan_id], 
	[p].[query_id], 
	[q].[object_id] AS containing_object_id,
    [p].[force_failure_count], 
	[p].[last_force_failure_reason_desc]
FROM [sys].[query_store_plan] AS [p]
JOIN [sys].[query_store_query] AS [q]
	ON [p].[query_id] = [q].[query_id]
WHERE [is_forced_plan] = 1;
GO


/*
	Re-add the index
*/
CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice]);
GO

/*
	Note the index ID
*/
SELECT *
FROM [sys].[indexes]
WHERE [object_id] = OBJECT_ID(N'Sales.OrderLines')
AND [type] = 2;
GO

/*
	Does the forced plan get used?
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	What shows for the forced plan?
*/
SELECT 
	[p].[plan_id], 
	[p].[query_id], 
	[q].[object_id] AS containing_object_id,
    [p].[force_failure_count], 
	[p].[last_force_failure_reason_desc]
FROM [sys].[query_store_plan] AS [p]
JOIN [sys].[query_store_query] AS [q]
	ON [p].[query_id] = [q].[query_id]
WHERE [is_forced_plan] = 1;
GO

/*
	What happens if we change the index definition?
	(remove a column)
*/
CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID])
	WITH (DROP_EXISTING=ON);
GO

/*
	Try it again
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO


/*
	What does QS say?
*/
SELECT 
	[p].[plan_id], 
	[p].[query_id], 
	[q].[object_id] AS containing_object_id,
    [p].[force_failure_count], 
	[p].[last_force_failure_reason_desc]
FROM [sys].[query_store_plan] AS [p]
JOIN [sys].[query_store_query] AS [q]
	ON [p].[query_id] = [q].[query_id]
WHERE [is_forced_plan] = 1;
GO


/*
	Change it back
*/
USE [WideWorldImporters];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice])
	WITH (DROP_EXISTING=ON);
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO


/*
	Change again, this time ADD a column
*/
USE [WideWorldImporters];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[PickedQuantity], [UnitPrice])
	WITH (DROP_EXISTING=ON);
GO

EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	What's the index_id?
*/
SELECT *
FROM [sys].[indexes]
WHERE [object_id] = OBJECT_ID(N'Sales.OrderLines')
AND [type] = 2;
GO

/*
	Drop the index, recreate with a different name
*/
DROP INDEX [NCI_OrderLines_StockItemID] ON [Sales].[OrderLines];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID_New]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice]);
GO

/*
	What's the index_id?
*/
SELECT *
FROM [sys].[indexes]
WHERE [object_id] = OBJECT_ID(N'Sales.OrderLines')
AND [type] = 2;
GO

/*
	Within QS, unforce, then re-force the plan
	force_failure_count is now 0
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	What does QS say?
*/
SELECT 
	[p].[plan_id], 
	[p].[query_id], 
	[q].[object_id] AS containing_object_id,
    [p].[force_failure_count], 
	[p].[last_force_failure_reason_desc]
FROM [sys].[query_store_plan] AS [p]
JOIN [sys].[query_store_query] AS [q]
	ON [p].[query_id] = [q].[query_id]
WHERE [is_forced_plan] = 1;
GO

/*
	Recreate the index with original name
*/
CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice]);
GO

/*
	Check the index_id
*/
SELECT *
FROM [sys].[indexes]
WHERE [object_id] = OBJECT_ID(N'Sales.OrderLines')
AND [type] = 2;
GO

/*
	Run the SP
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	Drop the extra index
*/
DROP INDEX [NCI_OrderLines_StockItemID_New] ON [Sales].[OrderLines];
GO




/*
	What if we change the stored procedure?
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
GO

/*
	Execute the SP
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO


/*
	What's in QS?
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsp].[is_forced_plan],
	[qsq].[object_id],
	OBJECT_NAME([qsq].[object_id]),
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] <> 0;
GO

/*
	Use ALTER when changing stored procedures
	Avoid the DROP/CREATE pattern because object_id changes
*/

/*
	Force the plan for the new object_id
*/
EXEC sp_query_store_force_plan 34, 46;
GO

/*
	Confirm it's forced
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsp].[is_forced_plan],
	[qsq].[object_id],
	OBJECT_NAME([qsq].[object_id]),
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] <> 0;
GO

/*
	Change the stored procedure again, 
	use ALTER, remove a column
*/
USE [WideWorldImporters];
GO

ALTER PROCEDURE [Sales].[usp_GetFullProductInfo]
	@StockItemID INT
AS	

	SELECT 
		[o].[CustomerID], 
		[o].[OrderDate], 
		[ol].[Quantity],
		[ol].[UnitPrice]
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	ORDER BY [o].[OrderDate] DESC;
GO


/*
	Everything should be the same
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsp].[is_forced_plan],
	[qsq].[object_id],
	OBJECT_NAME([qsq].[object_id]),
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] <> 0;
GO

/*
	Run the SP
*/
EXEC [Sales].[usp_GetFullProductInfo] 224;
GO

/*
	What's in QS?
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsp].[is_forced_plan],
	[qsq].[object_id],
	OBJECT_NAME([qsq].[object_id]),
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo');
GO

/*
	Set up an Extended Events session to track failures
*/
CREATE EVENT SESSION [QS_Force_Failures] 
	ON SERVER 
ADD EVENT qds.query_store_plan_forcing_failed
ADD TARGET package0.event_file(
	SET filename=N'C:\temp\QS_Force_Failures',max_file_size=(512))
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF);
GO
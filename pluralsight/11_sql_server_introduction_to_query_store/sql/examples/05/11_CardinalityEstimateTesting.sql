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
	Set compat mode to 110, as if we
	just upgraded from SQL 2012
*/
USE [master];
GO

ALTER DATABASE [WideWorldImporters] 
	SET COMPATIBILITY_LEVEL = 110;
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
	Flush QS data to disk
*/
EXEC [sys].[sp_query_store_flush_db];
GO

/*
	Find our query
*/
SELECT 
    [qst].[query_text_id],
	[qsq].[query_id],  
	[qst].[query_sql_text], 
	[qsp].[compatibility_level],
	[qsp].[engine_version],
	[qsp].[plan_id], 
    [rs].[last_execution_time],
	(DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
	[rs].[last_execution_time])) AS [LocalLastExecutionTime]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id] 
WHERE [qsp].[compatibility_level] < 120; 
GO

/*
	Use the query_text_id to compare
	performance of different compat modes
*/
SELECT 
    [qst].[query_text_id],
	[qsq].[query_id],  
	[qsp].[compatibility_level],
	[qsp].[engine_version],
	[qsp].[plan_id], 
	[rs].[avg_cpu_time],
	[rs].[avg_logical_io_reads],
	[rs].[avg_duration],
	TRY_CONVERT(XML, [qsp].[query_plan]),
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id] 
WHERE [qst].[query_text_id] = 1;
GO

/*
	Could also test with QUERYTRACEON hints
	But this creates a different query_text_id
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
OPTION (QUERYTRACEON 9481); -- revert to 2012 CE
GO


/*
	We will use the current copy of WWI,
	and run a new SP
*/
USE [WideWorldImporters];
GO

DROP PROCEDURE IF EXISTS [Warehouse].[usp_GetCustomerStockItemHistory];
GO

CREATE PROCEDURE [Warehouse].[usp_GetCustomerStockItemHistory]
	@StartDate DATE,
	@EndDate DATE
AS	

SELECT [CustomerID], SUM([StockItemID])
FROM [Warehouse].[StockItemTransactions]
WHERE [TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate
GROUP BY [CustomerID];

GO

/*
	Run queries outside of SSMS
*/


/*
	Now we need a copy of the database 
	WITH Query Store in it to use for
	testing.

	Options?
		Backup and restore
		DBCC CLONEDATABASE (with 2016 SP1 and higher)
		https://sqlperformance.com/2016/08/sql-statistics/expanding-dbcc-clonedatabase
*/
BACKUP DATABASE [WideWorldImporters]
  TO  DISK = N'C:\Backups\WWI_Testing.bak'
  WITH INIT, 
  NOFORMAT, 
  COPY_ONLY, 
  STATS = 10, 
  NAME = N'WWI_Testing_full';
GO
 
/* 
	restore in our TEST/DEV environment 
	(we'll restore locally)
*/
USE [master];
GO

RESTORE DATABASE [TEST_WideWorldImporters] 
	FROM  DISK = N'C:\Backups\WWI_Testing.bak' 
	WITH  FILE = 1,  
	MOVE N'WWI_Primary' TO N'C:\Databases\TEST_WWI\TEST_WWI.mdf',  
	MOVE N'WWI_UserData' TO N'C:\Databases\TEST_WWI\TEST_WWI_UserData.ndf',  
	MOVE N'WWI_Log' TO N'C:\Databases\TEST_WWI\TEST_WWI_log.ldf',  
	MOVE N'WWI_InMemory_Data_1' TO N'C:\Databases\TEST_WWI\TEST_WWI_InMemory_Data_1',  
	NOUNLOAD,  
	REPLACE,  
	STATS = 5;
GO
 

/*
	Query Store already enabled
	Considerations:
		Do you want any data to age out during testing?
		Do you need to increase space allocated?
*/
ALTER DATABASE [TEST_WideWorldImporters] SET QUERY_STORE ( 
	CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 90),  
	MAX_STORAGE_SIZE_MB = 1024);
GO

USE [TEST_WideWorldImporters];
GO

SELECT 
	[actual_state_desc], 
	[readonly_reason], 
	[desired_state_desc], 
	[current_storage_size_mb], 
    [max_storage_size_mb], 
	[flush_interval_seconds], 
	[interval_length_minutes], 
    [stale_query_threshold_days], 
	[size_based_cleanup_mode_desc], 
    [query_capture_mode_desc], 
	[max_plans_per_query]
FROM [sys].[database_query_store_options];
GO

/*
	Create the new index 
*/
CREATE NONCLUSTERED INDEX NCI_StockItemTransactions_TransactionOccurredWhen
	ON [Warehouse].[StockItemTransactions] ([TransactionOccurredWhen], [CustomerID])
	INCLUDE ([StockItemID])
	ON [USERDATA];
GO


/*
	Run queries outside of SSMS
*/


/*
	Compare performance in the UI
	using the query_id
*/
SELECT 
	[qst].[query_text_id],
	[qsq].[query_id],  
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Warehouse.usp_GetCustomerStockItemHistory');
GO


/*
	Compare performance with TSQL
	Need to know the time intervals
*/
SELECT 
	[qst].[query_text_id],
	[qsq].[query_id],  
	[qsp].[plan_id],
	[rs].[runtime_stats_id],
	[rs].[runtime_stats_interval_id],
	[rsi].[start_time],
	[rsi].[end_time],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs]
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Warehouse.usp_GetCustomerStockItemHistory')
	AND [rs].[execution_type] = 0
	AND [rsi].[start_time] > DATEADD(HOUR, -8, GETUTCDATE());
GO


/*
	Include the averages in the output
*/
SELECT 
	[qst].[query_text_id],
	[qsq].[query_id],  
	[qsp].[plan_id],
	[rsi].[start_time],
	[rsi].[end_time],
	[rs].[count_executions],
	[rs].[avg_cpu_time],
	[rs].[avg_logical_io_reads],
	[rs].[avg_duration],
	[qst].[query_sql_text],
	TRY_CONVERT(XML, [qsp].[query_plan])
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs]
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Warehouse.usp_GetCustomerStockItemHistory')
	AND [rs].[execution_type] = 0
	AND [rsi].[start_time] > DATEADD(HOUR, -8, GETUTCDATE());  
GO


/*
	Change a stored procedure
	(remove StockItemID from SELECT)
*/
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
	Run queries outside of SSMS
*/


/*
	Look at performance differences
*/
SELECT 
	[qst].[query_text_id],
	[qsq].[query_id],  
	[qsp].[plan_id],
	OBJECT_NAME([qsq].[object_id]) AS [ObjectName],
	[rsi].[start_time],
	[rsi].[end_time],
	[rs].[count_executions],
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
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo')
	AND [rs].[execution_type] = 0
	AND [rsi].[start_time] > DATEADD(HOUR, -12, GETUTCDATE())  
ORDER BY [qst].[query_text_id], [rsi].[start_time];
GO


/*
	Can we do better?
	Yes, for overall SP perf
	Need to use the time intervals, and
	just get averages for Production data
*/
SELECT 
	[qst].[query_text_id],
	OBJECT_NAME([qsq].[object_id]) AS [ObjectName],
	SUM([rs].[count_executions]) AS [TotalExecutions],
	AVG([rs].[avg_cpu_time]) AS [AvgCPUTime],
	AVG([rs].[avg_logical_io_reads]) AS [AvgLogicalIO],
	AVG([rs].[avg_duration]) AS [AvgDuration],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs]
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo')
	AND [rs].[execution_type] = 0
	AND [rsi].[end_time] <= '2016-12-19 20:05:00.0000000'
GROUP BY [qst].[query_text_id],	OBJECT_NAME([qsq].[object_id]), [qst].[query_sql_text];
GO

/*
	Now get just SP numbers
*/
SELECT 
	OBJECT_NAME([qsq].[object_id]) AS [ObjectName],
	AVG([rs].[avg_cpu_time]) AS [AvgCPUTime],
	AVG([rs].[avg_logical_io_reads]) AS [AvgLogicalIO],
	AVG([rs].[avg_duration]) AS [AvgDuration]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs]
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo')
	AND [rs].[execution_type] = 0
	AND [rsi].[end_time] <= '2016-12-19 20:05:00.0000000'
GROUP BY OBJECT_NAME([qsq].[object_id]);
GO

/*
	And compare...
*/
WITH ProdData
AS
(
	SELECT 
		[qsq].[object_id],
		OBJECT_NAME([qsq].[object_id]) AS [ObjectName],
		AVG([rs].[avg_cpu_time]) AS [ProdAvgCPUTime],
		AVG([rs].[avg_logical_io_reads]) AS [ProdAvgLogicalIO],
		AVG([rs].[avg_duration]) AS [ProdAvgDuration]
	FROM [sys].[query_store_query] [qsq]
	JOIN [sys].[query_store_query_text] [qst]
		ON [qsq].[query_text_id] = [qst].[query_text_id]
	JOIN [sys].[query_store_plan] [qsp] 
		ON [qsq].[query_id] = [qsp].[query_id]
	JOIN [sys].[query_store_runtime_stats] [rs]
		ON [qsp].[plan_id] = [rs].[plan_id]
	JOIN [sys].[query_store_runtime_stats_interval] [rsi]
			ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
	WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo')
		AND [rs].[execution_type] = 0
		AND [rsi].[end_time] <= '2016-12-19 20:05:00.0000000'
	GROUP BY [qsq].[object_id], OBJECT_NAME([qsq].[object_id])
)
SELECT 
	OBJECT_NAME([qsq].[object_id]) AS [ObjectName],
	[ProdData].[ProdAvgCPUTime],
	AVG([rs].[avg_cpu_time]) AS [TestAvgCPUTime],
	[ProdData].[ProdAvgLogicalIO],
	AVG([rs].[avg_logical_io_reads]) AS [TestAvgLogicalIO],
	[ProdData].[ProdAvgDuration],
	AVG([rs].[avg_duration]) AS [TestAvgDuration]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs]
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
JOIN ProdData
	ON [qsq].[object_id] = [ProdData].[object_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_GetFullProductInfo')
	AND [rs].[execution_type] = 0
	AND [rsi].[start_time] >= '2016-12-19 20:05:00.0000000'
GROUP BY OBJECT_NAME([qsq].[object_id]), [ProdData].[ProdAvgCPUTime],
	[ProdData].[ProdAvgLogicalIO], [ProdData].[ProdAvgDuration];
GO



/*
	Clean up
*/
USE [master];
GO

DROP DATABASE [TEST_WideWorldImporters];
GO
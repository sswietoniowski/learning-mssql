/*
	Make sure query store is enabled
	and clear anything that may be in there

*/
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE = ON;
GO
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE CLEAR;
GO

/*
	Reminder, these are defaults for aggregation
	and flushing settings
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	INTERVAL_LENGTH_MINUTES = 60,  
		/*	
			(default is 60)
			arbitary numbers not allowed
			acceptable values are:
				1, 5, 10, 15, 30, 60, 1440
		*/
	DATA_FLUSH_INTERVAL_SECONDS = 900);
		/*	
			INT data type
			(default is 900)
		*/
GO

/*
	SET DATA_FLUSH_INTERVAL_SECONDS   
	and INTERVAL_LENGTH_MINUTES to 
	*very low* values
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	INTERVAL_LENGTH_MINUTES = 5,
	DATA_FLUSH_INTERVAL_SECONDS = 60);
GO


/*
	Create stored procedure for testing
*/
USE [WideWorldImporters]
GO

DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerTransactionInfo];
GO

CREATE PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	

	SELECT [CustomerID], SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
GO


/*
	Run the query below to ensure a
	specific plan is in cache for demo
*/
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 401;
GO

/*
	Verify the plan in cache
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].execution_count, 
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[cp].[size_in_bytes]/1024 AS [PlanSizeKB], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats AS [qs]
CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
CROSS APPLY sys.dm_exec_sql_text([qs].[plan_handle]) AS [s]
INNER JOIN sys.dm_exec_cached_plans AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

/*
	Start workload using this file
	(external to SSMS):
	
	5_create_2_clients_usp_CustomerTransactionInfo.cmd
	
	Let workload run for 2-3 minutes
*/

/*
	Note what is in the views
*/
USE [WideWorldImporters];
GO

SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[rs].[runtime_stats_id],
	[rs].[runtime_stats_interval_id],
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_CustomerTransactionInfo');
GO

/*
	Note the intervals
*/
SELECT *
FROM [sys].[query_store_runtime_stats_interval];

/*
	Runtime stats are unique based on
	plan_id, execution_type, runtime_stats_interval_id
	"Typically, one row represents runtime statistics that are flushed to disk, 
	while other(s) represent in-memory state."
*/
SELECT *
FROM [sys].[query_store_runtime_stats]
WHERE [runtime_stats_id] IN (1);
GO

/*
	Manually flush data to disk
*/
EXECUTE [sp_query_store_flush_db];
GO


/*
	Query to force the other plan in cache
*/
DBCC FREEPROCCACHE;
GO
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO


/*
	Query to confirm the plan in cache
	currently is the other plan
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].execution_count, 
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[cp].[size_in_bytes]/1024 AS [PlanSizeKB], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats AS [qs]
CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
CROSS APPLY sys.dm_exec_sql_text([qs].[plan_handle]) AS [s]
INNER JOIN sys.dm_exec_cached_plans AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO


/*
	Now what do we see in the views?
*/
USE [WideWorldImporters];
GO

SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[rs].[runtime_stats_id],
	[rs].[runtime_stats_interval_id],
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	[rs].[count_executions],
	[qst].[query_sql_text],
	TRY_CONVERT(XML, [qsp].[query_plan])
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'Sales.usp_CustomerTransactionInfo');
GO

/*
	Use different intervals to compare performance
*/
SELECT
	[qsq].[query_id], 
	[qsp1].[plan_id] [Plan1],
	[qsp2].[plan_id] [Plan2],
	[qsq].[object_id],
	[rs1].[avg_duration] [AvgDuration_1],
	[rs2].[avg_duration] [AvgDuration_2],
	[rs1].[avg_logical_io_reads] [AvgLogicalReads_1],
	[rs2].[avg_logical_io_reads] [AvgLogicalReads_2],
	[rsi1].[start_time] [IntervalStart_1],
	[rsi2].[start_time] [IntervalStart_2],
	[qst].[query_sql_text],
	TRY_CONVERT(XML, [qsp1].[query_plan]) [Plan_1],
	TRY_CONVERT(XML, [qsp2].[query_plan]) [Plan_2]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp1] 
	ON [qsq].[query_id] = [qsp1].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs1] 
	ON [qsp1].[plan_id] = [rs1].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] AS [rsi1]  
    ON [rs1].[runtime_stats_interval_id] = [rsi1].[runtime_stats_interval_id]   
JOIN [sys].[query_store_plan] [qsp2] 
	ON [qsq].[query_id] = [qsp2].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs2] 
	ON [qsp2].[plan_id] = [rs2].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] AS [rsi2]  
    ON [rs2].[runtime_stats_interval_id] = [rsi2].[runtime_stats_interval_id] 
WHERE [rsi1].[start_time] > DATEADD(MINUTE, -10, GETUTCDATE())   
AND [rsi2].[start_time] > [rsi1].[start_time]   
    AND [qsp1].[plan_id] <> [qsp2].[plan_id] 
    AND [rs2].[avg_duration] > 2*[rs1].[avg_duration]  
ORDER BY [qsq].[query_id], [rsi1].[start_time], [rsi2].[start_time];  
GO

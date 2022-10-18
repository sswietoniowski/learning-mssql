/*
	What do we see in the Query StoreUI?
*/

/*
	What do we get from the system views?
*/
USE [WideWorldImporters];
GO

SELECT *
FROM [sys].[query_store_query];
GO

SELECT *
FROM [sys].[query_store_query_text];
GO

SELECT *
FROM [sys].[query_store_plan];
GO

SELECT *
FROM [sys].[query_store_runtime_stats];
GO


/*
	Query compile and optimization information
*/
SELECT 
	[qst].[query_text_id], 
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qsq].[context_settings_id], 
	[qst].[query_sql_text], 
	[qsq].[initial_compile_start_time], 
	[qsq].[last_compile_start_time],
	[qsq].[last_execution_time], 
	[qsq].[avg_compile_duration], 
	[qsq].[count_compiles], 
	[qsq].[avg_optimize_cpu_time], 
	[qsq].[avg_optimize_duration]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO


/*
	Query plan and execution information
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[qsq].[initial_compile_start_time],
	[qsq].[last_compile_start_time], 
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	TRY_CONVERT(XML, [qsp].[query_plan]),
	[qsp].[query_plan],
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsp].[query_id] = 3
GO


/*
	Queries executed in the last 8 hours
	with multiple plans
*/
SELECT
	[qsq].[query_id], 
	COUNT([qsp].[plan_id]) AS [PlanCount],
	[qsq].[object_id], 
	MAX(DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
		[qsp].[last_execution_time])) AS [LocalLastExecutionTime],
	MAX([qst].query_sql_text) AS [Query_Text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
WHERE [qsp].[last_execution_time] > DATEADD(HOUR, -8, GETUTCDATE())
GROUP BY [qsq].[query_id], [qsq].[object_id]
HAVING COUNT([qsp].[plan_id]) > 1;
GO


/*
	Confirm the plan that's being used now
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].[execution_count], 
	[qs].[last_execution_time],
	[s].[text], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM [sys].[dm_exec_query_stats] AS [qs]
CROSS APPLY [sys].[dm_exec_query_plan] ([qs].[plan_handle]) AS [qp]
CROSS APPLY [sys].[dm_exec_sql_text]([qs].[plan_handle]) AS [s]
JOIN [sys].[dm_exec_cached_plans] AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO


/*
	Check the distribution of data
*/
SELECT [CustomerID], COUNT(*)
FROM [Sales].[CustomerTransactions]
GROUP BY [CustomerID]
ORDER BY [CustomerID] ASC;
GO




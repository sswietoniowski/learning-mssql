/*
	Start running external query
*/


/*
	This is a function and requires input!
*/
SELECT *
FROM sys.dm_exec_sql_text;
GO


/*
	Must pass in sql_handle or plan_handle
*/
SELECT
	[r].[session_id],
	DB_NAME([r].[database_id]) [DatabaseName],
	[t].[text]
FROM sys.dm_exec_requests [r]
CROSS APPLY sys.dm_exec_sql_text([r].sql_handle) [t];
GO


/*
	This is a function and requires input!
*/
SELECT *
FROM sys.dm_exec_query_plan


/*
	Must pass in plan_handle
*/
SELECT
	[r].[session_id],
	DB_NAME([r].[database_id]) [DatabaseName],
	[t].[text],
	[p].[query_plan]
FROM sys.dm_exec_requests [r]
CROSS APPLY sys.dm_exec_sql_text([r].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([r].[plan_handle]) [p];
GO


/*
	Not that useful on its own...	
*/
SELECT *
FROM sys.dm_exec_cached_plans;


/*
	Add on to our previous DMO query
*/
SELECT
	[r].[session_id],
	DB_NAME([r].[database_id]) [DatabaseName],
	[cp].[objtype],
	[cp].[size_in_bytes],
	[t].[text],
	[p].[query_plan]
FROM sys.dm_exec_requests [r]
CROSS APPLY sys.dm_exec_sql_text([r].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([r].[plan_handle]) [p]
JOIN sys.dm_exec_cached_plans [cp]
	ON [r].[plan_handle] = [cp].[plan_handle];
GO


/*
	Yet another function that requires input :)
*/
SELECT *
FROM sys.dm_exec_text_query_plan;
GO


/*
	Must pass in plan_handle and offsets to specify a statement in a batch
	(use 0 and -1 if don't know offset values)
*/
SELECT
	[r].[session_id],
	DB_NAME([r].[database_id]) [DatabaseName],
	[tq].[query_plan]
FROM sys.dm_exec_requests [r]
CROSS APPLY sys.dm_exec_text_query_plan([r].plan_handle, 0, -1) [tq];
GO


/*
	Stop external query, we've generated enough information!
*/


/*
	This can return a lot of data!
	(take note of some of the cool data)
	Filters recommended
*/
SELECT *
FROM sys.dm_exec_query_stats;
GO


/*
	Alter our previous DMO query
*/
SELECT
	[qs].[last_execution_time],
	[qs].[execution_count],
	[qs].[total_logical_reads]/[qs].[execution_count] [AvgLogicalReads],
	[qs].[max_logical_reads],
	[t].[text],
	[p].[query_plan]
FROM sys.dm_exec_query_stats [qs]
CROSS APPLY sys.dm_exec_sql_text([qs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([qs].[plan_handle]) [p]
WHERE [qs].[execution_count] > 25
OR [qs].[total_logical_reads] > 10000
ORDER BY [qs].[total_logical_reads]/[qs].[execution_count] DESC;
GO


/*
	Works like dm_exec_query_stats
*/
SELECT *
FROM sys.dm_exec_function_stats;
GO

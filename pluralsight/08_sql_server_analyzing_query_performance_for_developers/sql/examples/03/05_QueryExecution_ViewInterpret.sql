USE [WideWorldImporters];
GO

/*
	Create same SP used previously
*/
USE [WideWorldImporters];
GO

DROP PROCEDURE IF EXISTS [Application].[usp_GetPersonInfo];
GO

CREATE PROCEDURE [Application].[usp_GetPersonInfo] (@PersonID INT)
AS

	SELECT 
		[p].[FullName], 
		[p].[EmailAddress], 
		[c].[FormalName]
	FROM [Application].[People] [p]
	LEFT OUTER JOIN [Application].[Countries] [c] 
		ON [p].[PersonID] = [c].[LastEditedBy]
	WHERE [p].[PersonID] = @PersonID;
GO

/*
	Create XE session again to capture 
	sql_statement_completed	and sp_statement_completed
	AND query_post_execution_showplan (use with caution!)
*/
IF EXISTS (
	SELECT * 
	FROM sys.server_event_sessions
	WHERE [name] = 'QueryPerf')
BEGIN
	DROP EVENT SESSION [QueryPerf] ON SERVER;
END
GO

CREATE EVENT SESSION [QueryPerf] 
	ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(
	WHERE ([duration]>(1000))),
ADD EVENT sqlserver.sql_statement_completed(
	WHERE ([duration]>(1000))),
ADD EVENT sqlserver.query_post_execution_showplan
ADD TARGET package0.event_file(
	SET filename=N'C:\Temp\QueryPerf',max_file_size=(256))
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF);
GO


/*
	Enable Query Store and clear out any data that might already exist
*/
USE [master];
GO

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE = ON;
GO

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE, 
	CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), 
	DATA_FLUSH_INTERVAL_SECONDS = 60,  
	INTERVAL_LENGTH_MINUTES = 5, 
	MAX_STORAGE_SIZE_MB = 100, 
	QUERY_CAPTURE_MODE = ALL, 
	SIZE_BASED_CLEANUP_MODE = AUTO, 
	MAX_PLANS_PER_QUERY = 200);
GO

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE CLEAR;
GO

/*
	Remove everything from the plan cache
*/
DBCC FREEPROCCACHE;
GO

/*
	Start session
*/
ALTER EVENT SESSION [QueryPerf] 
	ON SERVER
	STATE = START;
GO

/*
	Copy below to a separate window 
	We want to keep SSMS query output separate 
	from our demo code
*/

/*
	Enable stats
*/
SET STATISTICS IO ON;
GO
SET STATISTICS TIME ON;
GO
SET STATISTICS XML ON;
GO

/*
	Enable client statistics (toolbar)
*/

/*
	Run SP and query one time
*/
USE [WideWorldImporters];
GO

EXECUTE [Application].[usp_GetPersonInfo] 1234;
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO


/*
	Stop event session
*/
ALTER EVENT SESSION [QueryPerf] 
	ON SERVER
	STATE = STOP;
GO



/*
	IN ANOTHER WINDOW, look at data in 
	XE, cache, and Query Store
	(SSMS data already in another window)
*/


/*
	Query for cache
*/
SELECT
	[qs].[last_execution_time],
	[qs].[execution_count],
	[qs].[total_elapsed_time],
	[qs].[total_elapsed_time]/[qs].[execution_count] [AvgDuration],
	[qs].[total_logical_reads],
	[qs].[total_logical_reads]/[qs].[execution_count] [AvgLogicalReads],
	[t].[text],
	[p].[query_plan]
FROM sys.dm_exec_query_stats [qs]
CROSS APPLY sys.dm_exec_sql_text([qs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([qs].[plan_handle]) [p]
WHERE [t].[text] LIKE '%Countries%';
GO


/*
	Query for Query Store
*/
USE [WideWorldImporters];
GO

SELECT 
	[qsq].[query_id],  
	[qst].[query_sql_text], 
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsp].[plan_id], 
	[rs].[count_executions],
	[rs].[avg_logical_io_reads], 
	[rs].[avg_duration],
	TRY_CONVERT(XML, [qsp].[query_plan]),
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
WHERE [qst].[query_sql_text] LIKE '%Countries%'; 
GO



/*
	Clean up
*/
DROP EVENT SESSION [QueryPerf] ON SERVER;
GO
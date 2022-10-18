USE [WideWorldImporters];
GO

/*
	Compute Scalar can be "innocent" or "awful"
*/
SELECT COUNT(*)
FROM [Sales].[Orders];

SELECT COUNT_BIG (*)
FROM [Sales].[Orders];


SELECT @SoldCount = COUNT(DISTINCT [ol].[StockItemID])
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
WHERE [o].[SalespersonPersonID] = @SalesPersonID

/*
	Create a Scalar UDF
*/
CREATE FUNCTION dbo.CountProductsSold (
	@SalesPersonID INT
	) RETURNS INT

AS

BEGIN
    DECLARE @SoldCount INT;

	SELECT @SoldCount = COUNT(DISTINCT [ol].[StockItemID])
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol]
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [o].[SalespersonPersonID] = @SalesPersonID
	
    RETURN (@SoldCount);

END

GO


/*
	What's the cost of the Compute Scalar?
*/
SELECT 
	[FullName] AS [SalesPerson], 
	[dbo].[CountProductsSold]([PersonID]) AS [NumberOfProductsSold]
FROM [Application].[People]
WHERE [IsSalesperson] = 1;
GO


/*
	re-run with STATISTICS IO enabled
*/	
SET STATISTICS IO ON;
GO

SELECT 
	[FullName] AS [SalesPerson], 
	[dbo].[CountProductsSold]([PersonID]) AS [NumberOfProductsSold]
FROM [Application].[People]
WHERE [IsSalesperson] = 1;
GO

SET STATISTICS IO OFF;
GO


/*
	How do you see what's going on?
	XE or Profiler
*/
DECLARE @SQLcmd NVARCHAR(MAX) = N'
CREATE EVENT SESSION [CaptureQueryIO] ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(SET collect_statement=(1)
    WHERE ([sqlserver].[session_id]=(' + CAST(@@SPID AS NVARCHAR) + '))),
ADD EVENT sqlserver.sql_batch_completed(
    WHERE ([sqlserver].[session_id]=(' + CAST(@@SPID AS NVARCHAR) + '))) 
ADD TARGET package0.event_file(SET filename=N''C:\temp\CaptureQueryIO.xel'')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)'

PRINT @SQLCmd;
EXECUTE(@SQLCmd)
GO

ALTER EVENT SESSION [CaptureQueryIO]
ON SERVER
STATE = START;
GO


/*
	Run our query again
*/
SELECT 
	[FullName] AS [SalesPerson], 
	[dbo].[CountProductsSold]([PersonID]) AS [NumberOfProductsSold]
FROM [Application].[People]
WHERE [IsSalesperson] = 1;
GO


/*
	Stop session and check XE data
*/
ALTER EVENT SESSION [CaptureQueryIO]
ON SERVER
STATE = STOP;


/*
	Can also use new 2016 function!
*/
SELECT
	[fs].[last_execution_time],
	[fs].[execution_count],
	[fs].[total_logical_reads]/[fs].[execution_count] [AvgLogicalReads],
	[fs].[max_logical_reads],
	[t].[text],
	[p].[query_plan]
FROM sys.dm_exec_function_stats [fs]
CROSS APPLY sys.dm_exec_sql_text([fs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([fs].[plan_handle]) [p];
GO


/*
	Estimated Plan?
*/
SELECT 
	[FullName] AS [SalesPerson], 
	[dbo].[CountProductsSold]([PersonID]) AS [NumberOfProductsSold]
FROM [Application].[People]
WHERE [IsSalesperson] = 1;
GO

 /*
	clean up
 */
DROP FUNCTION dbo.CountProductsSold;
GO
DROP EVENT SESSION [CaptureQueryIO] ON SERVER;
GO



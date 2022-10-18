USE [WideWorldImporters];
GO


/*
	Query that returns some data
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate], 
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
WHERE [OrderDate] BETWEEN '2012-01-01 00:00:00.000' AND '2013-12-31 23:59:59.997'
ORDER BY [OrderDate]
OPTION (RECOMPILE);
GO


/*
	Check out row and page count
*/
SELECT 
	OBJECT_NAME([p].[object_id]) [TableName], 
	[si].[name] [IndexName], 
	[au].[type_desc] [Type], 
	[p].[rows] [RowCount], 
	[au].total_pages [PageCount]
FROM [sys].[partitions] [p]
JOIN [sys].[allocation_units] [au] 
	ON [p].[partition_id] = [au].[container_id]
JOIN [sys].[indexes] [si] 
	ON [p].[object_id] = [si].object_id 
	AND [p].[index_id] = [si].[index_id]
WHERE [p].[object_id] = OBJECT_ID(N'Sales.Orders');
GO


/*
	Trick the optimize a bit here and change row count
	**Don't try this at home!!**
*/
UPDATE STATISTICS  [Sales].[Orders]
	WITH ROWCOUNT = 100, PAGECOUNT = 801;
GO


/*
	re-run
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate], 
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
WHERE [OrderDate] BETWEEN '2012-01-01 00:00:00.000' AND '2013-12-31 23:59:59.997'
ORDER BY [OrderDate]
OPTION (RECOMPILE);
GO

/*
	How to track these?
	In the default trace...
	C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\Log

	Can we get better information through XEvents?  Yes ;)
*/
CREATE EVENT SESSION [SortWarnings] 
	ON SERVER 
	ADD EVENT sqlserver.hash_warning(
		ACTION(
			sqlserver.sql_text,sqlserver.tsql_stack)
			),
	ADD EVENT sqlserver.sort_warning(
		ACTION(
			sqlserver.sql_text,sqlserver.tsql_stack)
			),
	ADD EVENT sqlserver.sql_batch_completed
ADD TARGET package0.event_file(
	SET filename=N'C:\temp\SortWarnings',max_file_size=(512)
	)
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,
TRACK_CAUSALITY=ON,STARTUP_STATE=ON)
GO

ALTER EVENT SESSION [SortWarnings]
	ON SERVER
	STATE=START;
GO

/*
	Re-run again, view the data
*/
SELECT 
	[CustomerID], 
	[OrderID], 
	[OrderDate], 
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
WHERE [OrderDate] BETWEEN '2012-01-01 00:00:00.000' AND '2013-12-31 23:59:59.997'
ORDER BY [OrderDate]
OPTION (RECOMPILE);
GO

/*
	The XE session isn't perfect - you can't rely on sql_text
	Either use tsql_stack and remove sql_batch_completed, or,
	remove tsql_stack and sql_text, and keep sql_batch_completed

	Clean up 
*/
ALTER EVENT SESSION [SortWarnings]
	ON SERVER
	STATE=STOP;
GO

DROP EVENT SESSION [SortWarnings]
	ON SERVER;
GO

/*
	Restore database to properly "reset" statistics
*/

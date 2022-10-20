/*
	Check databases and growth increments after restores
*/
USE [master];
GO

SELECT 
	DB_NAME([f].[database_id]) AS [Database],
	[f].[type] AS [FileType],
	[f].[type_desc] AS [FileTypeDesc], 
	[f].[physical_name] AS [FileName], 
	[f].[size]*8/1024 [SizeMB],
	[f].[growth]*8/1024 [GrowthMB]
FROM [master].[sys].[master_files] [f]
WHERE [f].[database_id] > 4;
GO


/*
	Check events in the default trace
*/
SELECT distinct(te.name) AS [Event]
FROM ::fn_trace_geteventinfo(1) ti
JOIN sys.trace_events te ON ti.eventID = te.trace_event_id
ORDER BY te.name;
GO


/*
	Note all events 
*/
SELECT [name], [object_type], [description]
FROM [sys].[dm_xe_objects]
WHERE [object_type] = N'event'
AND [name] LIKE '%size_change%'
ORDER BY [name];
GO


/*
	Event session to track file growth
	(this only works for SQL Server 2012 and higher
	Start manually and then run scripts 3, 4, 5 and 6.
	Look at histogram data and file_target data
*/
CREATE EVENT SESSION [TrackAutoGrowth] 
	ON SERVER 
ADD EVENT 
	sqlserver.database_file_size_change(
		SET collect_database_name=(1)
		) 
ADD TARGET 
	package0.event_file(
		SET filename=N'C:\temp\TrackAutoGrowth'
		),
ADD TARGET 
	package0.histogram(
		SET filtering_event_name=N'sqlserver.database_file_size_change',
		slots=(10),
		source=N'database_name',
		source_type=(0)
		)
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,
	TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF
	);
GO


/*
	Start the event session and 
	view target data
	Run scripts 3, 4, 5, and 6
*/
ALTER EVENT SESSION [TrackAutoGrowth]
	ON SERVER
	STATE=START;
GO

/*
	When finished, stop the event session
*/
ALTER EVENT SESSION [TrackAutoGrowth]
	ON SERVER
	STATE=STOP;
GO


/*
	Drop the event session
	Run script 7 to drop the databases
*/
DROP EVENT SESSION [TrackAutoGrowth]
	ON SERVER;
GO
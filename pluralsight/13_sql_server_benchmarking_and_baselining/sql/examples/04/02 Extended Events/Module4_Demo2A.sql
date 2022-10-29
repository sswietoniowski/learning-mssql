/*
	Module4_Demo2A.sql
	Use this script to schedule the creation and start
	of an Extended Events session
	Change the session name and filename as appropriate
*/

IF EXISTS (
    SELECT * FROM sys.server_event_sessions WHERE name='CaptureQueries')
    DROP EVENT SESSION [CaptureQueries] ON SERVER;
GO

CREATE EVENT SESSION [CaptureQueries] ON SERVER 
ADD EVENT sqlserver.rpc_completed(SET collect_statement=(1)
    ACTION(sqlserver.database_id)
    WHERE ([physical_reads]>=(10000))),
ADD EVENT sqlserver.sql_batch_completed 
ADD TARGET package0.event_file(SET filename=N'C:\Pluralsight\XEvents\CaptureQueries.xel', max_file_size = 128, max_rollover_files = 10)
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION CaptureQueries
ON SERVER
STATE = START
GO

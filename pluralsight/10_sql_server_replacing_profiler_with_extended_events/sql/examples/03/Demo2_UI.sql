/*
	Default templates exist, just as in Profiler
	The Activity Tracking Template recreates what the default trace captures
	Issue with said template in SQL 2012:
	https://www.sqlskills.com/blogs/jonathan/workaround-for-bug-in-activity-tracking-event-session-template-in-2012-rc0/
*/

/*
	create an event session TrackQueries with 
	sql_batch_completed and sp_statement_completed,
	filter on is_system = 0
*/


/*
	Create the event session
*/
IF EXISTS (
		SELECT 1 
		FROM [sys].[server_event_sessions] 
		WHERE [name] = 'TrackQueries'
		)
	DROP EVENT SESSION [TrackQueries] 
		ON SERVER;
GO


/*
	create session that tracks sp_ and sql_ statement_completed
*/
CREATE EVENT SESSION [TrackQueries]
	ON SERVER 
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(
		sqlserver.client_app_name,sqlserver.database_id
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		),
ADD EVENT sqlserver.sp_statement_completed (
    ACTION (
		sqlserver.database_id,sqlserver.client_app_name)
    WHERE (
		[sqlserver].[is_system]=(0))
		) 
ADD TARGET package0.event_file (
	SET filename=N'C:\Temp\TrackQueries.xel')
WITH (MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF);
GO


/*
	start 
*/
ALTER EVENT SESSION [TrackQueries]
	ON SERVER
	STATE=START;
GO


/*
	Run .ps1 scripts
*/


/*
	After some initial analysis...
*/
ALTER EVENT SESSION [TrackQueries]
	ON SERVER
	DROP EVENT sql_batch_completed,
	DROP EVENT sp_statement_completed;
GO


ALTER EVENT SESSION [TrackQueries]
	ON SERVER 
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(
		sqlserver.client_app_name,sqlserver.query_hash,sqlserver.query_plan_hash
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		),
ADD EVENT sqlserver.sp_statement_completed (
    ACTION (
		sqlserver.client_app_name,sqlserver.query_hash,sqlserver.query_plan_hash
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		); 
GO

/*
	Remove sql_batch_completed
*/
ALTER EVENT SESSION [TrackQueries]
	ON SERVER
	DROP EVENT sql_batch_completed;
GO


ALTER EVENT SESSION [TrackQueries]
	ON SERVER 
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(
		sqlserver.client_app_name,sqlserver.query_hash,sqlserver.query_plan_hash
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		);
GO 


/*
	Stop when done
*/

ALTER EVENT SESSION [TrackQueries]
	ON SERVER
	STATE=STOP;
GO

/*
	Clean up
*/
DROP EVENT SESSION [TrackQueries] 
	ON SERVER;
GO
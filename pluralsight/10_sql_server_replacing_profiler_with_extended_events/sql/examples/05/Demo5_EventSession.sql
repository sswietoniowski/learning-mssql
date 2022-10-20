/*
	Check to see if the event session exists
*/
IF EXISTS (
		SELECT 1 
		FROM [sys].[server_event_sessions] 
		WHERE [name] = 'GetPlans'
		)
	DROP EVENT SESSION [GetPlans] 
		ON SERVER;
GO

/*
	Create the event session
*/
CREATE EVENT SESSION [GetPlans] 
	ON SERVER 
ADD EVENT sqlserver.query_post_execution_showplan (
    WHERE (
		[sqlserver].[is_system]=(0)
		AND [duration] > 100000000) --100 seconds
	) 
ADD TARGET package0.event_file (
	SET filename=N'C:\Temp\GetPlans.xel'
	)
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF);
GO

/*
	Start the event session
*/
ALTER EVENT SESSION [GetPlans] 
	ON SERVER 
	STATE=START;
GO

/*
	Stop the event session
*/
ALTER EVENT SESSION [GetPlans] 
	ON SERVER 
	STATE=STOP;
GO

/*
	Clean up
*/
DROP EVENT SESSION [GetPlans] 
	ON SERVER;
GO

/*
	Check to see if the event session exists
*/
IF EXISTS (
		SELECT 1 
		FROM [sys].[server_event_sessions] 
		WHERE [name] = 'AddAnAction'
		)
	DROP EVENT SESSION [AddAnAction] 
		ON SERVER;
GO

/*
	Create the event session
*/
CREATE EVENT SESSION [AddAnAction] 
	ON SERVER 
ADD EVENT sqlserver.sp_statement_completed (
    ACTION (
		sqlserver.database_id)
		),
ADD EVENT sqlserver.sql_batch_completed (
    ACTION (
		sqlserver.database_id)
		),
ADD EVENT sqlserver.sql_statement_completed (
    ACTION (
		sqlserver.database_id)
		) 
ADD TARGET package0.event_file (
	SET filename=N'C:\Temp\AddAnAction.xel'
	)
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF);
GO

/*
	Start the event session
*/
ALTER EVENT SESSION [AddAnAction] 
	ON SERVER 
	STATE=START;
GO

/*
	Remove events
*/
ALTER EVENT SESSION [AddAnAction] 
	ON SERVER 
DROP EVENT sqlserver.sp_statement_completed,
DROP EVENT sqlserver.sql_batch_completed,
DROP EVENT sqlserver.sql_statement_completed;
GO

/*
	Add events back, include tsql_stack
*/
ALTER EVENT SESSION [AddAnAction] 
	ON SERVER 
ADD EVENT sqlserver.sp_statement_completed (
    ACTION (
		sqlserver.database_id,sqlserver.tsql_stack)
	),
ADD EVENT sqlserver.sql_batch_completed (
    ACTION (
		sqlserver.database_id,sqlserver.tsql_stack)
	),
ADD EVENT sqlserver.sql_statement_completed (
    ACTION (
		sqlserver.database_id,sqlserver.tsql_stack)
	);
GO

/*
	Stop the event session
*/
ALTER EVENT SESSION [AddAnAction] 
	ON SERVER 
	STATE=STOP;
GO

/*
	Clean up
*/
DROP EVENT SESSION [AddAnAction] 
	ON SERVER;
GO
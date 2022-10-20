/*
	Check to see what exists
*/
SELECT * 
FROM [sys].[server_event_sessions];
GO

SELECT * 
FROM [sys].[fn_trace_getinfo](0);
GO



/*
	Start
*/
ALTER EVENT SESSION [XE_ReadsFilter_Trace]
	ON SERVER
	STATE=START;
GO

DECLARE @TraceID INT = 2;
EXEC sp_trace_setstatus @TraceID, 1;
GO


/*
	What's running?
	(Start workload, remove filter)
*/
SELECT
	[es].[name] AS [EventSession],
	[xe].[create_time] AS [SessionCreateTime],
	[xe].[total_buffer_size] AS [TotalBufferSize],
	[xe].[dropped_event_count] AS [DroppedEventCount]
FROM [sys].[server_event_sessions] [es]
LEFT OUTER JOIN [sys].[dm_xe_sessions] [xe] ON [es].[name] = [xe].[name];
GO

SELECT 
	[id] AS [TraceID],
	CASE	
		WHEN [status] = 0 THEN 'Not running'
		WHEN [status] = 1 THEN 'Running'
	END AS [TraceStatus],
	[start_time] AS [TraceStartTime],
	[buffer_size] AS [BufferSize],
	[dropped_event_count] AS [DroppedEventCount]
FROM [sys].[traces];
GO


/*
	Stop
*/
ALTER EVENT SESSION [XE_ReadsFilter_Trace]
	ON SERVER
	STATE=STOP;
GO

DECLARE @TraceID INT = 2;
EXEC sp_trace_setstatus @TraceID, 0; 
GO


/*
	Remove
*/
DROP EVENT SESSION [XE_ReadsFilter_Trace]
	ON SERVER;
GO

DECLARE @TraceID INT = 2;
EXEC sp_trace_setstatus @TraceID, 2;
GO
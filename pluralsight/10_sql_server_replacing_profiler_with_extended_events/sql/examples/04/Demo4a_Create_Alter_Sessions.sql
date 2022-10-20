/*
	Create an event session with a
	ring_buffer target
*/

IF EXISTS (
	SELECT 1 FROM [sys].[server_event_sessions] 
	WHERE [name] = 'Capture_Queries_RB'
	)
	DROP EVENT SESSION [Capture_Queries_RB] ON SERVER;
GO

CREATE EVENT SESSION [Capture_Queries_RB] 
	ON SERVER 
ADD EVENT sqlserver.rpc_completed (
    ACTION (
		sqlserver.database_id,
		sqlserver.client_app_name
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		),
ADD EVENT sqlserver.sp_statement_completed(
    ACTION (
		sqlserver.database_id,
		sqlserver.client_app_name
		)
    WHERE (
		[sqlserver].[is_system]=(0))
		) 
ADD TARGET package0.ring_buffer(
	SET max_events_limit=(5000),max_memory=(32768)
	)
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF
	);
GO


/*
	Start the session
*/
ALTER EVENT SESSION [Capture_Queries_RB]
	ON SERVER
	STATE=START;
	GO

/*
	Run .ps1 scripts
	Query the ring_buffer in a separate window
*/


/*
	Check to see how many events are in the ring_buffer, 
	and how many you can really see
*/
SELECT
    ring_buffer_event_count, 
    event_node_count, 
    ring_buffer_event_count - event_node_count AS events_not_in_xml
FROM
(    SELECT target_data.value('(RingBufferTarget/@eventCount)[1]', 'int') AS ring_buffer_event_count,
        target_data.value('count(RingBufferTarget/event)', 'int') as event_node_count
    FROM
    (    SELECT CAST(target_data AS XML) AS target_data  
        FROM sys.dm_xe_sessions as s
        INNER JOIN sys.dm_xe_session_targets AS st 
            ON s.address = st.event_session_address
        WHERE s.name = N'Capture_Queries_RB'
            AND st.target_name = N'ring_buffer'    ) AS n    ) AS t;


/*
	Check memory allocated for ring_buffer and what can be read 
*/
SELECT
    target_data.value('(RingBufferTarget/@memoryUsed)[1]', 'int') AS buffer_memory_used_bytes,
    ROUND(target_data.value('(RingBufferTarget/@memoryUsed)[1]', 'int')/1024., 1) AS buffer_memory_used_kb,
    ROUND(target_data.value('(RingBufferTarget/@memoryUsed)[1]', 'int')/1024/1024., 1) AS buffer_memory_used_MB,
    DATALENGTH(target_data) AS xml_length_bytes,
    ROUND(DATALENGTH(target_data)/1024., 1) AS xml_length_kb,
    ROUND(DATALENGTH(target_data)/1024./1024,1) AS xml_length_MB
FROM (
SELECT CAST(target_data AS XML) AS target_data  
FROM sys.dm_xe_sessions as s
INNER JOIN sys.dm_xe_session_targets AS st 
    ON s.address = st.event_session_address
WHERE s.name = N'Capture_Queries_RB'
 AND st.target_name = N'ring_buffer') as tab(target_data)


/*
	Alter session to stop collecting 
	the sp_statement_completed event
*/
ALTER EVENT SESSION [Capture_Queries_RB]
	ON SERVER
	DROP EVENT sqlserver.sp_statement_completed;
	GO


/*
	Query the ring_buffer again in a separate window
*/


/*
	Add event_file target, just because we can
*/
ALTER EVENT SESSION [Capture_Queries_RB]
	ON SERVER
	ADD TARGET package0.event_file (
		SET filename=N'C:\Temp\CaptureQueriesRB.xel'
	)
GO


/*
	Query the ring_buffer...
*/


/*
	Alter session to stop collecting rpc_completed
*/
ALTER EVENT SESSION [Capture_Queries_RB]
	ON SERVER
	DROP EVENT sqlserver.rpc_completed;
	GO


/*
	Query the ring_buffer yet again 
*/


/*
	Stop the event session
*/
ALTER EVENT SESSION [Capture_Queries_RB]
	ON SERVER
	STATE=STOP;
	GO


/*
	Query the ring_buffer one last time
*/


/*
	Clean up
*/
DROP EVENT SESSION [Capture_Queries_RB]
	ON SERVER;
GO
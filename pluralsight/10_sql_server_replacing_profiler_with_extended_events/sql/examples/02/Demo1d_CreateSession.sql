/*
	Create event session
*/
IF EXISTS (
		SELECT 1 FROM sys.server_event_sessions 
		WHERE name = 'XE_ReadsFilter_Trace')
	DROP EVENT SESSION [XE_ReadsFilter_Trace] ON SERVER;
GO

CREATE EVENT SESSION [XE_ReadsFilter_Trace]
ON SERVER
ADD EVENT sqlserver.rpc_completed(
	ACTION 
	(
		sqlserver.client_app_name	-- ApplicationName from SQLTrace
		, sqlserver.client_pid	-- ClientProcessID from SQLTrace
		, sqlserver.database_id	-- DatabaseID from SQLTrace
		, sqlserver.server_instance_name	-- ServerName from SQLTrace
		, sqlserver.server_principal_name	-- LoginName from SQLTrace
		, sqlserver.session_id	-- SPID from SQLTrace
		-- BinaryData not implemented in XE for this event
		-- EndTime implemented by another Action in XE already
		-- StartTime implemented by another Action in XE already
	)
	WHERE 
	(
			logical_reads >= 10000
	)
),
ADD EVENT sqlserver.sql_statement_completed(
	ACTION 
	(
			sqlserver.client_app_name	-- ApplicationName from SQLTrace
		, sqlserver.client_pid	-- ClientProcessID from SQLTrace
		, sqlserver.database_id	-- DatabaseID from SQLTrace
		, sqlserver.server_instance_name	-- ServerName from SQLTrace
		, sqlserver.server_principal_name	-- LoginName from SQLTrace
		, sqlserver.session_id	-- SPID from SQLTrace
		-- EndTime implemented by another Action in XE already
		-- StartTime implemented by another Action in XE already
	)
	WHERE 
	(
			logical_reads >= 10000
	)
)
ADD TARGET package0.event_file
(
	SET filename = 'C:\Temp\XE_ReadsFilter_Trace.xel',
		max_file_size = 100,
		max_rollover_files = 1
)

--remove reads filter before running workload!
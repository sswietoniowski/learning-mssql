CREATE EVENT SESSION [SQLAuthorityEE] ON SERVER 
ADD EVENT sqlserver.query_pre_execution_showplan(
    ACTION(sqlserver.database_name,sqlserver.nt_username,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'd:\data\SQLAuthorityEE')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO



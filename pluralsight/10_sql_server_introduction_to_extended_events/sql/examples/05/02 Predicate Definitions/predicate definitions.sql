-- Create the event session
CREATE EVENT SESSION [Pluralsight Predicates] ON SERVER 
ADD EVENT sqlserver.error_reported(
    WHERE ([error_number]=(50000) AND 
	[package0].[equal_int64]([severity],(16)) AND 
	[package0].[divides_by_uint64]([sqlserver].[session_id],(2)))) 
ADD TARGET package0.ring_buffer
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

-- Test the event session
RAISERROR('Test', 16, 1);

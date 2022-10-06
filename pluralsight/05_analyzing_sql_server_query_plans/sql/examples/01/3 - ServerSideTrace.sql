
exec sp_trace_setstatus 2, 1 -- Start the Trace
GO
exec sp_trace_setstatus 2, 0 -- Stop the Trace
GO
exec sp_trace_setstatus 2, 2 -- Delete the Trace
GO
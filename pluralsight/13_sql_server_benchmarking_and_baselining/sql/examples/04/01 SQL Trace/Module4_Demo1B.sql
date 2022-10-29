/*
	Module4_Demo1B.sql
	Use this script to schedule the stop of a SQL Trace
	Change the file location as appropriate
*/

DECLARE @TraceID int

SELECT @TraceID = traceid
FROM ::fn_trace_getinfo(0)
WHERE property = 2 and cast(value as varchar(100)) like 'C:\Pluralsight\SQLTrace%'

EXEC sp_trace_setstatus @TraceID, 0
EXEC sp_trace_setstatus @TraceID, 2
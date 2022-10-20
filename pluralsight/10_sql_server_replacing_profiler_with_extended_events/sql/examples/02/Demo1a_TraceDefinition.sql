/****************************************************/
/* Created by: SQL Server 2012  Profiler          */
/* Date: 05/17/2016  11:06:31 PM         */
/****************************************************/


-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 100 

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 0, N'C:\Pluralsight\XE\Demo1', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
												--eventid 10 = RPC: Completed
exec sp_trace_setevent @TraceID, 10, 1, @on		--columnid 1 = TextData
exec sp_trace_setevent @TraceID, 10, 9, @on		--columnid 9 = ClientProcessID
exec sp_trace_setevent @TraceID, 10, 10, @on	--columnid 10 = ApplicationName
exec sp_trace_setevent @TraceID, 10, 3, @on		--columnid 3 = DatabaseID
exec sp_trace_setevent @TraceID, 10, 11, @on	--columnid 11 = loginID
exec sp_trace_setevent @TraceID, 10, 12, @on	--columnid 12 = SPID
exec sp_trace_setevent @TraceID, 10, 13, @on	--columnid 13 = Duration
exec sp_trace_setevent @TraceID, 10, 14, @on	--columnid 14 = StartTime
exec sp_trace_setevent @TraceID, 10, 15, @on	--columnid 15 = EndTime
exec sp_trace_setevent @TraceID, 10, 16, @on	--columnid 16 = Reads
exec sp_trace_setevent @TraceID, 10, 17, @on	--columnid 17 = Writes
exec sp_trace_setevent @TraceID, 10, 18, @on	--columnid 18 = CPU
exec sp_trace_setevent @TraceID, 10, 26, @on	--columnid 26 = ServerName

												--eventid 41 = SQL:StatementCompleted
exec sp_trace_setevent @TraceID, 41, 1, @on	
exec sp_trace_setevent @TraceID, 41, 9, @on
exec sp_trace_setevent @TraceID, 41, 3, @on
exec sp_trace_setevent @TraceID, 41, 10, @on
exec sp_trace_setevent @TraceID, 41, 11, @on
exec sp_trace_setevent @TraceID, 41, 12, @on
exec sp_trace_setevent @TraceID, 41, 13, @on
exec sp_trace_setevent @TraceID, 41, 14, @on
exec sp_trace_setevent @TraceID, 41, 15, @on
exec sp_trace_setevent @TraceID, 41, 16, @on
exec sp_trace_setevent @TraceID, 41, 17, @on
exec sp_trace_setevent @TraceID, 41, 18, @on
exec sp_trace_setevent @TraceID, 41, 26, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 61a3cdc0-1d56-474e-b517-0dea8cd779db'

--reads filter
--remove reads filter before running workload!
set @bigintfilter = 10000
exec sp_trace_setfilter @TraceID, 16, 0, 4, @bigintfilter


-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1


-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go

/*
--select * from sys.fn_trace_getinfo(0)

-- exec sp_trace_setstatus 2, 0
-- exec sp_trace_setstatus 2, 2


--delete file before re-run script to create XE session
--remove filter before re-run when comparing
*/
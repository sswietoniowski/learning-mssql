-- Using the event_file target
IF EXISTS (SELECT 1 
			FROM sys.server_event_sessions 
			WHERE name = N'file_target_demo')
	-- Drop the Event Session to cleanup Demo
	DROP EVENT SESSION [file_target_demo]
	ON SERVER;
GO
-- Create an Event Session to capture Errors Reported
CREATE EVENT SESSION [file_target_demo]
ON SERVER
ADD EVENT [sqlserver].[module_start],
ADD EVENT [sqlserver].[module_end],
ADD EVENT [sqlserver].[sp_statement_starting],
ADD EVENT [sqlserver].[sp_statement_completed],
ADD EVENT [sqlserver].[lock_acquired]
ADD TARGET [package0].[event_file](
SET filename=N'C:\Pluralsight\file_target_demo.xel') ;
GO

-- ALTER the Event Session and Start it.
ALTER EVENT SESSION [file_target_demo]
ON SERVER
STATE=START;
GO

EXECUTE [AdventureWorks2012].[dbo].[ExecuteLotsOfStatements] @ExecutionLoopCount = 200;
GO 200

SELECT * 
FROM [AdventureWorks2012].[Sales].[SalesOrderDetail];
GO

ALTER EVENT SESSION [file_target_demo]
ON SERVER
STATE=STOP;


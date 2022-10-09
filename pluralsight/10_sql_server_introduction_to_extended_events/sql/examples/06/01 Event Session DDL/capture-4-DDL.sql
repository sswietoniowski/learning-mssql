-- Create event session to find the database with most SP Recompile Events
CREATE EVENT SESSION [SPStmtCompleted] 
ON SERVER 
ADD EVENT [sqlserver].[sp_statement_completed](
	SET collect_statement=0
    ACTION([sqlserver].[tsql_stack])
	WHERE ([sqlserver].[session_id]=50))
ADD TARGET [package0].[event_file](
	SET filename=N'C:\Pluralsight\SPStmtCompleted.xel')
WITH(STARTUP_STATE=ON);
GO

--Start the event session
ALTER EVENT SESSION [SPStmtCompleted]
ON SERVER
STATE=START;
GO

-- Add another event
ALTER EVENT SESSION [SPStmtCompleted] 
ON SERVER 
ADD EVENT [sqlserver].[sp_statement_starting](
	SET collect_statement=0
    ACTION([sqlserver].[tsql_stack])
	WHERE ([sqlserver].[session_id]=50));

-- Add another package
ALTER EVENT SESSION [SPStmtCompleted] 
ON SERVER 
ADD TARGET [package0].[ring_buffer];
GO

--Drop the event session
DROP EVENT SESSION [SPStmtCompleted]
ON SERVER;
GO

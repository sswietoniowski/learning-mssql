-- ring_buffer target usage
USE AdventureWorks2012;
GO

-- Create a test procedure 
IF OBJECT_ID('ExecuteLotsOfStatements') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[ExecuteLotsOfStatements]
    END
GO
CREATE PROCEDURE [dbo].[ExecuteLotsOfStatements]
(
 @ExecutionLoopCount INT = 100
)
AS 
DECLARE @Loop INT = 0 ;
WHILE @Loop < @ExecutionLoopCount 
    BEGIN
        DECLARE @Loop2 INT
        SELECT  @Loop2 = @Loop
	
        SET @Loop = @Loop + 1
    END

GO


/*************** General Usage ***************/
IF EXISTS ( SELECT  1
            FROM    [sys].[server_event_sessions]
            WHERE   [name] = 'ring_buffer_demo' )
	-- Drop the event session to cleanup Demo
    DROP EVENT SESSION [ring_buffer_demo]
	ON SERVER ;
GO

-- Create an event session to capture errors reported
CREATE EVENT SESSION [ring_buffer_demo] 
ON SERVER ADD EVENT sqlserver.error_reported 
ADD TARGET package0.ring_buffer 
WITH (MAX_DISPATCH_LATENCY = 1 SECONDS) ;
GO

-- ALTER the event session and start it.
ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
STATE=START ;
GO

-- SELECT from a non-existent table to create event
SELECT *
FROM master.schema_doesnt_exist.table_doesnt_exist;
GO

-- Drop the Event to halt Event collection
ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
DROP EVENT sqlserver.error_reported ;
GO

-- Wait for Event buffering to Target
WAITFOR DELAY '00:00:01' ;
GO

-- Create XML variable to hold Target Data
DECLARE @target_data XML
SELECT  @target_data = CAST([t].[target_data] AS XML)
FROM    [sys].[dm_xe_sessions] AS s
JOIN    [sys].[dm_xe_session_targets] AS t
        ON [t].[event_session_address] = [s].[address]
WHERE   [s].[name] = N'ring_buffer_demo' AND
        [t].[target_name] = N'ring_buffer' ;

-- Return the target data
SELECT @target_data;

-- Drop the event session to cleanup Demo
DROP EVENT SESSION [ring_buffer_demo]
ON SERVER ;
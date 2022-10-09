-- ring_buffer XML output
USE AdventureWorks2012;
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
ON SERVER ADD EVENT [sqlserver].[error_reported](
	ACTION ([sqlserver].[session_id]))
ADD TARGET [package0].[ring_buffer] 
WITH (MAX_DISPATCH_LATENCY = 1 SECONDS) ;
GO

-- ALTER the event session and start it.
ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
STATE=START ;
GO

-- SELECT from a non-existent table to create event
SELECT *
FROM [master].[schema_doesnt_exist].[table_doesnt_exist] ;
GO 3

-- Drop the Event to halt Event collection
ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
DROP EVENT [sqlserver].[error_reported] ;
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

-- Query XML variable to get event nodes separately
SELECT  n.query('.') AS event_XML
FROM    @target_data.nodes('RingBufferTarget/event') AS q (n) ;


-- Query XML variable to get event data    
SELECT  n.value('(@name)[1]', 'varchar(50)') AS event_name,
        n.value('(@package)[1]', 'varchar(50)') AS package_name,
        n.value('(@id)[1]', 'int') AS id,
        n.value('(@version)[1]', 'int') AS version,
        DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP),
                n.value('(@timestamp)[1]', 'datetime2')) AS [timestamp],
        n.value('(data[@name="error"]/value)[1]', 'int') AS error,
        n.value('(data[@name="severity"]/value)[1]', 'int') AS severity,
        n.value('(data[@name="duration"]/value)[1]', 'int') AS state,
        n.value('(data[@name="user_defined"]/value)[1]', 'varchar(5)') AS user_defined,
        n.value('(data[@name="message"]/value)[1]', 'varchar(max)') AS message
FROM    @target_data.nodes('RingBufferTarget/event') AS q (n) ;
GO

-- Drop the event session to cleanup Demo
DROP EVENT SESSION [ring_buffer_demo]
ON SERVER ;
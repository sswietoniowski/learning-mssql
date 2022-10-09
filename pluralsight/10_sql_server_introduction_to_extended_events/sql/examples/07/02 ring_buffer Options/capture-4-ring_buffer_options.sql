/*************** Target Options ***************/

-- Target Configurable Fields
SELECT  [oc].[name] AS column_name,
        [oc].[column_id],
        [oc].[type_name],
        [oc].[capabilities_desc],
        [oc].[description]
FROM    [sys].[dm_xe_packages] AS p
INNER JOIN [sys].[dm_xe_objects] AS o
        ON [p].[guid] = [o].[package_guid]
INNER JOIN [sys].[dm_xe_object_columns] AS oc
        ON [o].[name] = [oc].[object_name] AND
           [o].[package_guid] = [oc].[object_package_guid]
WHERE   ([p].[capabilities] IS NULL OR
         [p].[capabilities] & 1 = 0) AND
        ([o].[capabilities] IS NULL OR
         [o].[capabilities] & 1 = 0) AND
        [o].[object_type] = N'target' AND
        [o].[name] = N'ring_buffer' ;
GO

IF EXISTS ( SELECT  1
            FROM    [sys].[server_event_sessions]
            WHERE   name = N'ring_buffer_demo' )
	-- Drop the Event Session to cleanup Demo
    DROP EVENT SESSION [ring_buffer_demo]
	ON SERVER ;
GO
-- Create an Event Session to capture Errors Reported
CREATE EVENT SESSION [ring_buffer_demo] 
ON SERVER 
ADD EVENT [sqlserver].[module_start],
ADD EVENT [sqlserver].[module_end],
ADD EVENT [sqlserver].[sp_statement_starting],
ADD EVENT [sqlserver].[sp_statement_completed],
ADD EVENT [sqlserver].[lock_acquired] 
ADD TARGET package0.ring_buffer 
--(SET max_memory=128,
--	 occurrence_number=100)
WITH (MAX_DISPATCH_LATENCY = 1 SECONDS) ;
GO

-- ALTER the Event Session and Start it.
ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
STATE=START ;
GO

EXECUTE [AdventureWorks2012].[dbo].[ExecuteLotsOfStatements] @ExecutionLoopCount = 200 ;
GO 200

SELECT * 
FROM [AdventureWorks2012].[Sales].[SalesOrderDetail] ;
GO

ALTER EVENT SESSION [ring_buffer_demo]
ON SERVER
DROP EVENT [sqlserver].[module_start],
DROP EVENT [sqlserver].[module_end],
DROP EVENT [sqlserver].[sp_statement_starting],
DROP EVENT [sqlserver].[sp_statement_completed],
DROP EVENT [sqlserver].[lock_acquired] ;
GO

-- Create XML variable to hold Target Data
DECLARE @target_data XML
SELECT  @target_data = CAST([t].[target_data] AS XML)
FROM    [sys].[dm_xe_sessions] AS s
INNER JOIN [sys].[dm_xe_session_targets] AS t
        ON [t].[event_session_address] = [s].[address]
WHERE   [s].[name] = N'ring_buffer_demo' AND
        [t].[target_name] = N'ring_buffer' ;
  
-- Query XML variable to get Event data  
SELECT  [tab].[event_name],
        COUNT(*) AS occurence_count
FROM    (SELECT n.value('(@name)[1]', 'varchar(50)') AS event_name
         FROM   @target_data.nodes('RingBufferTarget/event') AS q (n)) AS tab
GROUP BY [tab].[event_name] ;
GO

-- Uncomment Target Options and Rerun to show the last 100
-- occurrences of the module and lock event are retained


-- Uncomment the SELECT statement and rerun to show the shift
-- of occurrences to sp_statement_starting/completed at 100
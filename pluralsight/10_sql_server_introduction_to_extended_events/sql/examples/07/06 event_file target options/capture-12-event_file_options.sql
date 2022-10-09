/*  Cleanup old files
EXECUTE sp_configure 'show advanced options', 1; RECONFIGURE;
EXECUTE sp_configure 'xp_cmdshell', 1; RECONFIGURE; 
EXEC xp_cmdshell 'DEL C:\Pluralsight\file_target_demo*';
EXECUTE sp_configure 'xp_cmdshell', 0; RECONFIGURE;
EXECUTE sp_configure 'show advanced options', 0; RECONFIGURE;
*/


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
        ON [o].[name] = [oc].[OBJECT_NAME] AND
           [o].[package_guid] = [oc].[object_package_guid]
WHERE   ([p].[capabilities] IS NULL OR
         [p].[capabilities] & 1 = 0) AND
        ([o].[capabilities] IS NULL OR
         [o].[capabilities] & 1 = 0) AND
        [o].[object_type] = N'target' AND
        [o].[name] = N'event_file' ;
  

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
SET filename=N'C:\Pluralsight\file_target_demo.xel',
    max_file_size=10,
    max_rollover_files=10,
    increment=5) ;
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


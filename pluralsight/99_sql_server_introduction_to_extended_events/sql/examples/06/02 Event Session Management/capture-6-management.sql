-- If the Event Session exists Drop it
IF EXISTS (SELECT 1 
			FROM [sys].[server_event_sessions] 
			WHERE [name] = 'LocksAquired')
	DROP EVENT SESSION [LocksAquired] ON SERVER;
GO
-- Create Event Session to find the database with most SP Recompile Events
CREATE EVENT SESSION [LocksAquired] ON SERVER 
ADD EVENT [sqlserver].[lock_acquired](
    ACTION([sqlserver].[query_hash])),
ADD EVENT [sqlserver].[sp_statement_starting](
    ACTION([sqlserver].[query_hash])),
ADD EVENT [sqlserver].[sp_statement_completed](
    ACTION([sqlserver].[query_hash]))
ADD TARGET [package0].[ring_buffer];
GO

--Start the Event Session
ALTER EVENT SESSION [LocksAquired]
ON SERVER
STATE=START;
GO
		
DECLARE @ManagerID int
SELECT TOP 1 @ManagerID = [BusinessEntityID] 
FROM [AdventureWorks2012].[HumanResources].[Employee]
WHERE JobTitle LIKE '%Manager%'
ORDER BY NEWID();

EXECUTE [AdventureWorks2012].[dbo].[uspGetManagerEmployees] @ManagerID;
EXECUTE [AdventureWorks2012].[dbo].[uspGetEmployeeManagers] @ManagerID;
GO


-- Query the target data
SELECT
	[event_data].[value]('(event/@name)[1]', 'varchar(50)') AS [event_name],
	DATEADD(hh, 
		DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP), 
		[event_data].[value]('(event/@timestamp)[1]', 'datetime2')) AS [timestamp],
	[event_data].[value]('(event/data[@name="mode"]/text)[1]', 'varchar(50)') as mode,
	[event_data].[value]('(event/data[@name="resource_type"]/text)[1]', 'varchar(50)') as resource_type,
	[event_data].[value]('(event/data[@name="statement"]/value)[1]', 'varchar(max)') as statement
FROM(	SELECT [evnt].[query]('.') AS [event_data]
		FROM
		(	SELECT CAST([target_data] AS xml) AS [TargetData]
			FROM [sys].[dm_xe_sessions] AS [s]
			JOIN [sys].[dm_xe_session_targets] AS [t]
				ON [s].[address] = [t].[event_session_address]
			WHERE [s].[name] = 'LocksAquired'
			  AND [t].[target_name] = 'ring_buffer'
		) AS tab
		CROSS APPLY [TargetData].[nodes]('RingBufferTarget/event') AS [split]([evnt]) 
	 ) AS [evts]([event_data]);
GO

-- Modify the event session 

-- Drop the events so we can add predicates back to them
ALTER EVENT SESSION [LocksAquired]
ON SERVER
DROP EVENT [sqlserver].[lock_acquired],
DROP EVENT [sqlserver].[sp_statement_starting],
DROP EVENT [sqlserver].[sp_statement_completed];
GO

-- Get the database_id for AdventureWorks2012
SELECT DB_ID('AdventureWorks2012');

-- Add the events back with predicates
-- on database_id and is_system
ALTER EVENT SESSION [LocksAquired]
ON SERVER
ADD EVENT [sqlserver].[lock_acquired](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0)),
ADD EVENT [sqlserver].[sp_statement_starting](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0)),
ADD EVENT [sqlserver].[sp_statement_completed](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0));
GO

-- Drop the ring_buffer target so it can be recreated
ALTER EVENT SESSION [LocksAquired]
ON SERVER
DROP TARGET [package0].[ring_buffer];
GO

-- Add the ring_buffer target with a better configuration
ALTER EVENT SESSION [LocksAquired]
ON SERVER
ADD TARGET [package0].[ring_buffer](
	SET occurrence_number=100, -- Per event FIFO
		max_events_limit=10000 -- Max of 10000 events
	);
		
/* We could have done this as we well

-- Drop the Event Session
DROP EVENT SESSION [LocksAquired] ON SERVER

-- Create Event Session to out about locks being acquired
CREATE EVENT SESSION [LocksAquired]
ON SERVER
ADD EVENT [sqlserver].[lock_acquired](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0)),
ADD EVENT [sqlserver].[sp_statement_starting](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0)),
ADD EVENT [sqlserver].[sp_statement_completed](
    ACTION([sqlserver].[query_hash])
	WHERE ([sqlserver].[database_id] = 7 AND
		   [sqlserver].[is_system] = 0))
ADD TARGET [package0].[ring_buffer](
	SET [occurrence_number]=100, -- Per event FIFO
		[max_events_limit]=10000 -- Max of 10000 events
	);
		
--Start the Event Session
ALTER EVENT SESSION [LocksAquired]
ON SERVER
STATE=START;

-- Do what makes the most sense in real life this is just a demo!  */


-- Retest a few times to see the impacts.
DECLARE @ManagerID int
SELECT TOP 1 @ManagerID = [BusinessEntityID] 
FROM [AdventureWorks2012].[HumanResources].[Employee]
WHERE JobTitle LIKE '%Manager%'
ORDER BY NEWID();

EXECUTE [AdventureWorks2012].[dbo].[uspGetManagerEmployees] @ManagerID;
EXECUTE [AdventureWorks2012].[dbo].[uspGetEmployeeManagers] @ManagerID;
GO


-- Query the target data
SELECT
	[event_data].[value]('(event/@name)[1]', 'varchar(50)') AS [event_name],
	DATEADD(hh, 
		DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP), 
		[event_data].[value]('(event/@timestamp)[1]', 'datetime2')) AS [timestamp],
	[event_data].[value]('(event/data[@name="mode"]/text)[1]', 'varchar(50)') as mode,
	[event_data].[value]('(event/data[@name="resource_type"]/text)[1]', 'varchar(50)') as resource_type,
	[event_data].[value]('(event/data[@name="statement"]/value)[1]', 'varchar(max)') as statement
FROM(	SELECT [evnt].[query]('.') AS [event_data]
		FROM
		(	SELECT CAST([target_data] AS xml) AS [TargetData]
			FROM [sys].[dm_xe_sessions] AS [s]
			JOIN [sys].[dm_xe_session_targets] AS [t]
				ON [s].[address] = [t].[event_session_address]
			WHERE [s].[name] = 'LocksAquired'
			  AND [t].[target_name] = 'ring_buffer'
		) AS tab
		CROSS APPLY [TargetData].[nodes]('RingBufferTarget/event') AS [split]([evnt]) 
	 ) AS [evts]([event_data]);
GO

-- Set the event session to track causality between events
ALTER EVENT SESSION [LocksAquired]
ON SERVER
WITH(TRACK_CAUSALITY=ON);


-- Stop the event session
ALTER EVENT SESSION [LocksAquired]
ON SERVER
STATE=STOP;

-- Set the event session to track causality between events
ALTER EVENT SESSION [LocksAquired]
ON SERVER
WITH(TRACK_CAUSALITY=ON);


--Start the event session
ALTER EVENT SESSION [LocksAquired]
ON SERVER
STATE=START;
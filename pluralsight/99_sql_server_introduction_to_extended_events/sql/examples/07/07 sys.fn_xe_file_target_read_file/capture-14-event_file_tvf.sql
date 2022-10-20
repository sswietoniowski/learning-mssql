/*********  Read the file **********/
DECLARE @path NVARCHAR(260),
    @mdpath NVARCHAR(260) ;
  
-- Get file path
SELECT  @path = REPLACE(CAST(value AS NVARCHAR(512)), '.xel', '*xel')
FROM    [sys].[server_event_sessions] AS ses
INNER JOIN [sys].[server_event_session_targets] AS sest
        ON [ses].[event_session_id] = [sest].[event_session_id]
INNER JOIN [sys].[server_event_session_fields] AS sesf
        ON [sest].[event_session_id] = [sesf].[event_session_id] AND
           [sest].[target_id] = [sesf].[object_id]
WHERE   [ses].[name] = N'file_target_demo' AND
        [sest].[name] = N'event_file' AND
        [sesf].[name] = N'filename' ;
  
-- Get metadata file path
SELECT  @mdpath = REPLACE(CAST(value AS NVARCHAR(512)), '.xem', '*xem')
FROM    [sys].[server_event_sessions] AS ses
INNER JOIN [sys].[server_event_session_targets] AS sest
        ON [ses].[event_session_id] = [sest].[event_session_id]
INNER JOIN [sys].[server_event_session_fields] AS sesf
        ON [sest].[event_session_id] = [sesf].[event_session_id] AND
           [sest].[target_id] = [sesf].[object_id]
WHERE   [ses].[name] = N'file_target_demo' AND
        [sest].[name] = N'event_file' AND
        [sesf].[name] = N'metadatafile' ;

-- Query the Event data from the Target
SELECT  [module_guid],
        [package_guid],
        [object_name],
        [event_data],
        [file_name],
        [file_offset]
FROM    [sys].[fn_xe_file_target_read_file](@path, 
											@mdpath, 
											NULL, 
											NULL) ;



-- Offset reading the file
/**** CHANGE THE INITIAL FILE NAME FIRST! ****/
SELECT  [module_guid],
        [package_guid],
        [object_name],
        [event_data],
        [file_name],
        [file_offset]
FROM    [sys].[fn_xe_file_target_read_file](N'C:\Pluralsight\file_target_demo*xel',
                                            NULL,
                                            N'C:\Pluralsight\file_target_demo_0_129626491430280000.xel',
                                            11534336) ;

-- Query the Event data from the Target.
SELECT  [n].[value]('(@name)[1]', 'varchar(50)') AS event_name,
        [n].[value]('(@package)[1]', 'varchar(50)') AS package_name,
        [n].[value]('(@id)[1]', 'int') AS id,
        [n].[value]('(@version)[1]', 'int') AS version,
        DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP),
                [n].[value]('(@timestamp)[1]', 'datetime2')) AS [timestamp],
        [n].[value]('(data[@name="database_id"]/value)[1]', 'int') AS database_id,
        [n].[value]('(data[@name="object_id"]/value)[1]', 'int') AS object_id,
        [n].[value]('(data[@name="duration"]/value)[1]', 'int') AS duration,
        [n].[value]('(data[@name="cpu"]/value)[1]', 'varchar(5)') AS cpu,
        [n].[value]('(data[@name="message"]/value)[1]', 'varchar(max)') AS message
FROM    (SELECT CAST([event_data] AS XML) AS event_data
         FROM   [sys].[fn_xe_file_target_read_file](N'C:\Pluralsight\file_target_demo*xel',
                                                    NULL, 
													NULL, 
													NULL)) AS tab
CROSS APPLY [event_data].[nodes]('event') AS [q] ([n]) ;


-- Using a temp table is faster

-- Drop Results tables if they exist
IF OBJECT_ID('tempdb..#XEResults') IS NOT NULL 
    DROP TABLE #XEResults ;
GO
IF OBJECT_ID('tempdb..#XEResultsParsed') IS NOT NULL 
    DROP TABLE #XEResultsParsed ;
GO

-- Create results table to load data from XE files
CREATE TABLE #XEResults
(
 [RowID] INT IDENTITY
             PRIMARY KEY,
 [event_data] XML
) ;
GO

-- Load the event data from the file target
INSERT  INTO #XEResults
        ([event_data])
SELECT  CAST([event_data] AS XML) AS event_data
FROM    [sys].[fn_xe_file_target_read_file](N'C:\Pluralsight\file_target_demo*xel',
                                            NULL, 
											NULL, 
											NULL) ;
		
-- Query the Event data from the Target.
SELECT  [event].[value]('(@name)[1]', 'varchar(50)') AS event_name,
        [event].[value]('(@package)[1]', 'varchar(50)') AS package_name,
        [event].[value]('(@id)[1]', 'int') AS id,
        [event].[value]('(@version)[1]', 'int') AS version,
        DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP),
                [event].[value]('(@timestamp)[1]', 'datetime2')) AS [timestamp],
        [event].[value]('(data[@name="database_id"]/value)[1]', 'int') AS database_id,
        [event].[value]('(data[@name="object_id"]/value)[1]', 'int') AS object_id,
        [event].[value]('(data[@name="duration"]/value)[1]', 'int') AS duration,
        [event].[value]('(data[@name="cpu"]/value)[1]', 'varchar(5)') AS cpu,
        [event].[value]('(data[@name="message"]/value)[1]', 'varchar(max)') AS message
FROM    #XEResults
CROSS APPLY [event_data].[nodes]('event') AS [q] ([event]) ;

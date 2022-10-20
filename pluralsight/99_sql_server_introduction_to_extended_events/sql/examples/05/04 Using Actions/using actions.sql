/*************** Side effecting actions ***************/

-- If the event session exists drop it
IF EXISTS ( SELECT  1
            FROM    [sys].[server_event_sessions]
            WHERE   [name] = N'Pluralsight_CollectMiniDump' ) 
    DROP EVENT SESSION [Pluralsight_CollectMiniDump] ON SERVER ;

-- Create event session to perform a memory dump on error
CREATE EVENT SESSION [Pluralsight_CollectMiniDump] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported](
	ACTION ([sqlserver].[create_dump_single_thread]) 
	WHERE ([error_number] = 50000 AND
			[severity] = 16 AND
			[state] = 1)) ;
GO

ALTER EVENT SESSION [Pluralsight_CollectMiniDump]
ON SERVER
STATE=START ;
GO

-- Open the ERRORLOG path in Windows 
RAISERROR('TestMessage', 16, 1)

ALTER EVENT SESSION [Pluralsight_CollectMiniDump]
ON SERVER
STATE=STOP ;
GO

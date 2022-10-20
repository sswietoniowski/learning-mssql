-- Create a test database for the demo
USE [master];
GO
IF DB_ID('XE_Basics') IS NOT NULL
BEGIN
	ALTER DATABASE [XE_Basics] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [XE_Basics];
END
GO
CREATE DATABASE [XE_Basics]
GO

USE [XE_Basics]
GO

-- Create a procedure to create an arithmetic overflow
CREATE PROCEDURE dbo.ArithOverflow
AS
BEGIN

DECLARE @smallint smallint = 1;

BEGIN TRY
	SET @smallint = 100000;
END TRY
BEGIN CATCH
	SET @smallint = 90000;
END CATCH

END
GO

-- Create an event session to track error 220 - Arithmetic overflow
IF EXISTS (SELECT 1
		   FROM sys.server_event_sessions
		   WHERE name = N'XE_Basics_error_reported')
BEGIN
	DROP EVENT SESSION [XE_Basics_error_reported] ON SERVER ;
END
GO

CREATE EVENT SESSION [XE_Basics_error_reported] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported](
    ACTION([sqlserver].[query_hash],
		   [sqlserver].[sql_text],
		   [sqlserver].[tsql_stack])
    WHERE ([error_number]=220)) 
ADD TARGET package0.event_file(
	SET filename=N'C:\Pluralsight\XE_Basics_error_reported.xel')
GO

-- Start the event session and view live data in the UI

-- Execute the procedure to test event sessions
EXECUTE dbo.ArithOverflow;

-- Offset parse the handle to get the text
DECLARE @handle VARBINARY(64) = handle;  -- Change to match tsql_stack 
DECLARE @offset_start INT =  offset_start;  -- Change to match tsql_stack 
DECLARE @offset_end INT = offset_end;  -- Change to match tsql_stack 

SELECT 
	[st].dbid,
	[st].objectid,
	OBJECT_NAME([st].objectid) AS ObjectName,
	OBJECT_DEFINITION([st].[objectid]) AS FullDefinition,
    SUBSTRING([st].[text], (@offset_start/2)+1, 
        ((CASE @offset_end
          WHEN -1 THEN DATALENGTH([st].[text])
         ELSE @offset_end
         END - @offset_start)/2) + 1) AS [statement_text]
FROM [sys].[dm_exec_sql_text](@handle) AS [st];
GO



-- Create data truncation procedure
CREATE PROCEDURE [dbo].[StringTrunc]
AS 
BEGIN

	DECLARE @source TABLE
	([RowValue] CHAR(100) NOT NULL DEFAULT(REPLICATE('A', 100)));

	INSERT INTO @source DEFAULT VALUES;

	DECLARE @truncated TABLE
	([RowValue] VARCHAR(50) NOT NULL);

	INSERT INTO @truncated([RowValue])
	SELECT [RowValue]
	FROM @source;

END
GO

-- Create an event session to track error message 
IF EXISTS (SELECT 1
		   FROM sys.server_event_sessions
		   WHERE name = N'XE_Basics_error_reported')
BEGIN
	DROP EVENT SESSION [XE_Basics_error_reported] ON SERVER ;
END
GO

CREATE EVENT SESSION [XE_Basics_error_reported] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported](
    ACTION([sqlserver].[query_hash],
		   [sqlserver].[sql_text],
		   [sqlserver].[tsql_stack])
    WHERE ([message] LIKE 'String or binary data would be truncated.')) 
ADD TARGET [package0].[event_file](
	SET filename=N'C:\Pluralsight\XE_Basics_error_reported.xel')
GO

-- Start the event session
ALTER EVENT SESSION [XE_Basics_error_reported] 
ON SERVER 
STATE=START;

-- Open the live data view for the event session

-- Execute the procedure to generate an error
EXECUTE [dbo].[StringTrunc];
GO


-- Drop the database to cleanup
USE [master];
GO
IF DB_ID('XE_Basics') IS NOT NULL
BEGIN
	ALTER DATABASE [XE_Basics] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [XE_Basics];
END
GO

-- Drop the event session to clean up
IF EXISTS (SELECT 1
		   FROM sys.server_event_sessions
		   WHERE name = N'XE_Basics_error_reported')
BEGIN
	DROP EVENT SESSION [XE_Basics_error_reported] ON SERVER ;
END
GO

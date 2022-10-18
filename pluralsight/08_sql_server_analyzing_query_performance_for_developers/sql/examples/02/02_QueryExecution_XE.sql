/*
	Create a stored procedure to use for testing
*/

USE [WideWorldImporters];
GO

DROP PROCEDURE IF EXISTS [Application].[usp_GetCountryInfo];
GO

CREATE PROCEDURE [Application].[usp_GetCountryInfo]
	@Country_Name NVARCHAR(60)
AS	

SELECT *
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = @Country_Name;
GO

/*
	Create XE session to capture sql_statement_completed
	and sp_statement_completed
*/
IF EXISTS (
	SELECT * 
	FROM sys.server_event_sessions
	WHERE [name] = 'QueryPerf')
BEGIN
	DROP EVENT SESSION [QueryPerf] ON SERVER;
END
GO

CREATE EVENT SESSION [QueryPerf] 
	ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(
	WHERE ([duration]>(1000))),
ADD EVENT sqlserver.sql_statement_completed(
	WHERE ([duration]>(1000)))
ADD TARGET package0.event_file(
	SET filename=N'C:\Temp\QueryPerf',max_file_size=(256))
WITH (
	MAX_MEMORY=16384 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF);
GO

/*
	Start session via UI
	Execute one WHILE loop in a separate window
*/
WHILE 1 = 1
BEGIN
	EXECUTE [Application].[usp_GetCountryInfo] N'United States';
END

WHILE 1 = 1
BEGIN
	SELECT 
		[s].[StateProvinceName], 
		[s].[SalesTerritory], 
		[s].[LatestRecordedPopulation], 
		[s].[StateProvinceCode]
	FROM [Application].[Countries] [c]
	JOIN [Application].[StateProvinces] [s]
		ON [s].[CountryID] = [c].[CountryID]
	WHERE [c].[CountryName] = 'United States';
END

/*
	Stop event session in UI when finished
*/
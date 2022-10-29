/*
	Module5_Demo3C.sql
	This script will create a stored procedure that can be run
	to list configuration settings that have changed between
	two data capture dates.
*/


USE [BaselineData];
GO

IF OBJECTPROPERTY(OBJECT_ID('usp_SysConfigReport'), 'IsProcedure') = 1
	DROP PROCEDURE usp_SysConfigReport;
GO

CREATE PROCEDURE dbo.usp_SysConfigReport 
(
	@RecentDate DATETIME,
	@OlderDate DATETIME
)
AS

BEGIN;

	IF
		@RecentDate IS NULL
		OR @OlderDate IS NULL
	BEGIN;
		RAISERROR('Input parameters cannot be NULL', 16, 1);
		RETURN;
	END;
	
	SELECT 
		[O].[Name], 
		[O].[Value] AS "OlderValue", 
		[O].[ValueInUse] AS"OlderValueInUse",
		[R].[Value] AS "RecentValue", 
		[R].[ValueInUse] AS "RecentValueInUse"

	FROM [dbo].[ConfigData] O
	JOIN
		(SELECT [ConfigurationID], [Value], [ValueInUse]
		FROM [dbo].[ConfigData]
		WHERE [CaptureDate] = @RecentDate) R on [O].[ConfigurationID] = [R].[ConfigurationID]
	WHERE [O].[CaptureDate] = @OlderDate
	AND (([R].[Value] <> [O].[Value]) OR ([R].[ValueInUse] <> [O].[ValueInUse]))

END;

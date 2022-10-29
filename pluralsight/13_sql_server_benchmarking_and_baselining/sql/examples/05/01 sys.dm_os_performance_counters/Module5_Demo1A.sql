/*
	Module5_Demo1A.sql
	This script creates a table to hold SQL Server performance monitor counters	
	captured from sys.dm_os_performance_counters
*/

USE [BaselineData];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[PerfMonData] (
	[Counter] NVARCHAR(770),
	[Value] DECIMAL(38,2),
	[CaptureDate] DATETIME,
	) ON [PRIMARY];
GO


CREATE CLUSTERED INDEX CI_PerfMonData ON [dbo].[PerfMonData] ([CaptureDate],[Counter]);
CREATE NONCLUSTERED INDEX IX_PerfMonData ON [dbo].[PerfMonData] ([Counter], [CaptureDate]) INCLUDE ([Value]);

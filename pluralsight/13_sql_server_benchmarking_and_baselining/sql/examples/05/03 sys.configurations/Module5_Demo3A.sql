/*
	Module5_Demo3A.sql
	This script creates a table to hold data
	captured from sys.configurations
*/

USE [BaselineData];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[ConfigData](
	[ConfigurationID] [int] NOT NULL,
	[Name] [nvarchar](35) NOT NULL,
	[Value] [sql_variant] NULL,
	[ValueInUse] [sql_variant] NULL,
	[CaptureDate] [datetime] --can change to datetime2 for SQL 2008 and higher
) ON [PRIMARY];

GO

CREATE CLUSTERED INDEX CI_ConfigData ON [dbo].[ConfigData] ([CaptureDate],[ConfigurationID]);





























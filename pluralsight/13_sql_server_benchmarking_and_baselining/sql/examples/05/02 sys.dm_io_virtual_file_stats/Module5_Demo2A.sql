/*
	Module5_Demo2A.sql
	This script creates a table to index-related information	
	captured from sys.dm_db_index_usage_stats
*/

USE [BaselineData];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[IndexUsage](
	[CaptureDate] DATETIME NOT NULL,
	[DatabaseName] NVARCHAR(128) NULL,
	[SchemaName] NVARCHAR(128) NULL,
	[ObjectName] NVARCHAR(128) NULL,
	[database_id] SMALLINT NOT NULL,
	[object_id] INT NOT NULL,
	[index_id] INT NOT NULL,
	[user_seeks] BIGINT NOT NULL,
	[user_scans] BIGINT NOT NULL,
	[user_lookups] BIGINT NOT NULL,
	[user_updates] BIGINT NOT NULL,
	[last_user_seek] DATETIME NULL,
	[last_user_scan] DATETIME NULL,
	[last_user_lookup] DATETIME NULL,
	[last_user_update] DATETIME NULL,
	[system_seeks] BIGINT NOT NULL,
	[system_scans] BIGINT NOT NULL,
	[system_lookups] BIGINT NOT NULL,
	[system_updates] BIGINT NOT NULL,
	[last_system_seek] DATETIME NULL,
	[last_system_scan] DATETIME NULL,
	[last_system_lookup] DATETIME NULL,
	[last_system_update] DATETIME NULL
	) ON [PRIMARY]
GO















--drop table dbo.indexusage
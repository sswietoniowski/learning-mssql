/*
	Module5_Demo2B.sql
	This script should be scheduled to run on a regular basis to 
	capture information	from sys.dm_db_index_usage_stats.
*/

USE [BaselineData];
GO

INSERT INTO [dbo].[IndexUsage] (
	[CaptureDate],
	[DatabaseName],
	[SchemaName],
	[ObjectName],
	[database_id],
	[object_id],
	[index_id],
	[user_seeks],
	[user_scans],
	[user_lookups],
	[user_updates],
	[last_user_seek],
	[last_user_scan],
	[last_user_lookup],
	[last_user_update],
	[system_seeks],
	[system_scans],
	[system_lookups],
	[system_updates],
	[last_system_seek],
	[last_system_scan],
	[last_system_lookup],
	[last_system_update]
	)
SELECT 
	getdate(),
	DB_NAME(i.database_id),
	OBJECT_SCHEMA_NAME (i.object_id, i.database_id),
	OBJECT_NAME(i.object_id, i.database_id),
	[i].[database_id],
	[i].[object_id],
	[i].[index_id],
	[i].[user_seeks],
	[i].[user_scans],
	[i].[user_lookups],
	[i].[user_updates],
	[i].[last_user_seek],
	[i].[last_user_scan],
	[i].[last_user_lookup],
	[i].[last_user_update],
	[i].[system_seeks],
	[i].[system_scans],
	[i].[system_lookups],
	[i].[system_updates],
	[i].[last_system_seek],
	[i].[last_system_scan],
	[i].[last_system_lookup],
	[i].[last_system_update]
FROM sys.dm_db_index_usage_stats i
WHERE i.object_id > 100;


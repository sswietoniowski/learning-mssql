/*
	Module5_Demo2B.sql
	These queries can be used to understand information
	captured from sys.dm_db_index_usage_stats.
*/

USE [BaselineData];
GO

SELECT [DatabaseName], [SchemaName], [ObjectName], [index_id], [user_seeks], [user_scans], [user_lookups], [user_updates], [last_user_update], [CaptureDate] 
FROM [dbo].[IndexUsage]
WHERE [DatabaseName] = 'AdventureWorks2012'
ORDER BY [DatabaseName], [ObjectName], [user_seeks], [CaptureDate]



SELECT [DatabaseName], [SchemaName], [ObjectName], [index_id], [user_updates], ([user_seeks] + [user_scans] + [user_lookups]) as "TotaledSeekScanLookUp", [CaptureDate] 
FROM [dbo].[IndexUsage]
WHERE [user_updates] > ([user_seeks] + [user_scans] + [user_lookups])
AND [DatabaseName] = 'AdventureWorks2012'
ORDER BY [DatabaseName], [ObjectName], [user_seeks], [CaptureDate]






/*
	Module5_Demo3B.sql
	This script should be scheduled to run on a regular 
	basis to capture information from sys.configurations.
*/


USE [BaselineData];
GO

INSERT INTO [dbo].[ConfigData]
           ([ConfigurationID]
           ,[Name]
           ,[Value]
           ,[ValueInUse]
           ,[CaptureDate])
SELECT [configuration_id]
           ,[name]
           ,[value]
           ,[value_in_use]
           ,GETDATE()
FROM [sys].[configurations];




/*
	Change some settings...

	sp_configure 'max degree of parallelism', 1;
	GO
	sp_configure 'max server memory (MB)', 512;
	GO
	RECONFIGURE WITH OVERRIDE;
	GO

*/
/*
	Module5_Demo3D.sql
	These scripts can be used to query captured configuration information,
	or run the stored procedure that will list changed configuration
	values based on	two different data capture dates.
*/

SELECT * FROM [dbo].[ConfigData] 
ORDER BY [ConfigurationID], [CaptureDate];


SELECT DISTINCT [CaptureDate]
FROM [dbo].[ConfigData]
ORDER BY [CaptureDate];


EXEC dbo.usp_SysConfigReport '<recent date>', '<older date>';



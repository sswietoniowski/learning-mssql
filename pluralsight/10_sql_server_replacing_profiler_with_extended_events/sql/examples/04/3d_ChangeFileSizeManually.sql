/*
	Increase the database file size for Charlie manually
*/
USE [master];
GO

ALTER DATABASE [Charlie] 
	MODIFY FILE ( NAME = N'AdventureWorks2014_Data', SIZE = 1048576KB );
GO
ALTER DATABASE [Charlie] 
	MODIFY FILE ( NAME = N'AdventureWorks2014_Log', SIZE = 524288KB );
GO

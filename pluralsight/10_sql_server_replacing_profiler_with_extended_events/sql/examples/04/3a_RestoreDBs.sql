/*
	Script assumes you have a backup of the 
	AdventureWorks2014 database in C:\Backups
	and you have database folders in C:\Databases
	Edit as necessary
*/
USE [master];
GO

RESTORE DATABASE [AdventureWorks2014] 
	FROM  DISK = N'C:\Backups\AW2014.bak' 
	WITH  FILE = 1,  
	NOUNLOAD,  
	REPLACE,
	STATS = 5;
GO

RESTORE DATABASE [Harry]
	FROM  DISK = N'C:\Backups\AW2014.bak' 
	WITH  FILE = 1,  
	MOVE N'AdventureWorks2014_Data' TO N'C:\Databases\Harry\Harry_Data.mdf',  
	MOVE N'AdventureWorks2014_Log' TO N'C:\Databases\Harry\Harry_Log.ldf',  
	NOUNLOAD, 
	REPLACE, 
	STATS = 5;
GO

RESTORE DATABASE [Charlie]
	FROM  DISK = N'C:\Backups\AW2014.bak' 
	WITH  FILE = 1,  
	MOVE N'AdventureWorks2014_Data' TO N'C:\Databases\Charlie\Charlie_Data.mdf',  
	MOVE N'AdventureWorks2014_Log' TO N'C:\Databases\Charlie\Charlie_Log.ldf',  
	NOUNLOAD,  
	REPLACE, 
	STATS = 5;
GO

RESTORE DATABASE [Violet]
	FROM  DISK = N'C:\Backups\AW2014.bak' 
	WITH  FILE = 1,  
	MOVE N'AdventureWorks2014_Data' TO N'C:\Databases\Violet\Violet_Data.mdf',  
	MOVE N'AdventureWorks2014_Log' TO N'C:\Databases\Violet\Violet_Log.ldf',  
	NOUNLOAD,  
	REPLACE, 
	STATS = 5;
GO

RESTORE DATABASE [AuntMarjorie]
	FROM  DISK = N'C:\Backups\AW2014.bak' 
	WITH  FILE = 1,  
	MOVE N'AdventureWorks2014_Data' TO N'C:\Databases\AuntMarjorie\AuntMarjorie_Data.mdf',  
	MOVE N'AdventureWorks2014_Log' TO N'C:\Databases\AuntMarjorie\AuntMarjorie_Log.ldf',  
	NOUNLOAD,  
	REPLACE, 
	STATS = 5;
GO


USE [master]
GO
ALTER DATABASE [AdventureWorks2014] MODIFY FILE ( NAME = N'AdventureWorks2014_Data', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [AdventureWorks2014] MODIFY FILE ( NAME = N'AdventureWorks2014_Log', FILEGROWTH = 1024KB )
GO

USE [master]
GO
ALTER DATABASE [AuntMarjorie] MODIFY FILE ( NAME = N'AdventureWorks2014_Data', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [AuntMarjorie] MODIFY FILE ( NAME = N'AdventureWorks2014_Log', FILEGROWTH = 1024KB )
GO

USE [master]
GO
ALTER DATABASE [Harry] MODIFY FILE ( NAME = N'AdventureWorks2014_Data', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [Harry] MODIFY FILE ( NAME = N'AdventureWorks2014_Log', FILEGROWTH = 1024KB )
GO

USE [master]
GO
ALTER DATABASE [Charlie] MODIFY FILE ( NAME = N'AdventureWorks2014_Data', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [Charlie] MODIFY FILE ( NAME = N'AdventureWorks2014_Log', FILEGROWTH = 1024KB )
GO

USE [master]
GO
ALTER DATABASE [Violet] MODIFY FILE ( NAME = N'AdventureWorks2014_Data', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [Violet] MODIFY FILE ( NAME = N'AdventureWorks2014_Log', FILEGROWTH = 1024KB )
GO
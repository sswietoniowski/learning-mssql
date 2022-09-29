USE master;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'inventory')
BEGIN
    ALTER DATABASE inventory SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
GO

DROP DATABASE IF EXISTS inventory;
GO

CREATE DATABASE inventory;
GO

USE inventory;
GO

SELECT * FROM sys.databases WHERE name = 'inventory';
GO

EXECUTE sp_helpfile;
GO

-- Other informations that might be of some use:
-- - working with files and filegroups,
-- - using schema for your objects.

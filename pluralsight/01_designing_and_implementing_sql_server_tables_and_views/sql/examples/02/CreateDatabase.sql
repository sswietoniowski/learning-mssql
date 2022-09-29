-- Create database for Bobs Shoes

-- Note: the script uses the file path
--       C:\SQLFiles\BobsShoes\
-- To run in your environment, either create the path or change the pathname in the code below

USE master;
GO
CREATE DATABASE BobsShoes;
GO

-- Show the entry for BobsShoes in the system tables
SELECT * FROM sys.databases WHERE name = 'BobsShoes';

-- Change to the new database context
USE BobsShoes;
GO

-- Show the layout of the files for the database
EXEC sp_helpfile;
GO

-- Create schema for Bobs Orders
CREATE SCHEMA Orders 
    AUTHORIZATION dbo;
GO

-- Create new filegroups for data and logs

ALTER DATABASE BobsShoes
    ADD FILEGROUP BobsData;
ALTER DATABASE BobsShoes
    ADD FILE (
       NAME = BobsData,
       FILENAME = 'C:\SQLFiles\BobsShoes\BobsData.mdf'
    )
    TO FILEGROUP BobsData;
 
ALTER DATABASE BobsShoes
    ADD LOG FILE ( 
        NAME = BobsLogs,
        FILENAME = 'C:\SQLFiles\BobsShoes\BobsLog.ldf'
    );

GO

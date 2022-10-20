-- Configure the blocked process threshold for 5 seconds
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'blocked process threshold', 5;
GO
RECONFIGURE;
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

-- Now start a event session collecting the blocked_process_report event in Live Data view


-- Now copy the following code into two query windows and run them together
USE AdventureWorks2012
GO
BEGIN TRANSACTION
SELECT *
FROM Person.Person WITH(XLOCK);

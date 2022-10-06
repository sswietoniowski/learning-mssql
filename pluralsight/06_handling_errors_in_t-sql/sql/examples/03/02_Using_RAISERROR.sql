-- Run this script to follow along with the demo


-- Start a new error log
-- Please do not run this in production
EXEC sp_cycle_errorlog;  
GO  





-- This will not work
RAISEERROR('There is something wrong here',16,1);
GO





-- Raise a message without the Id
RAISERROR('The row count does not match',16,1);
GO





-- Raise where message Id does not exist
RAISERROR(65000,16,1);
GO





-- Raise with a low severity
RAISERROR('This is a lower severity message',1,1);
GO





-- Will be logged to the error log
RAISERROR('This is a custom logged message',16,1) WITH LOG;
GO





-- Using a variable as the message text
DECLARE @MessageText nvarchar(500);
SET @MessageText = 'This is a custom error message';

RAISERROR(@MessageText,16,1);
GO





-- A way to check the error and log it
DECLARE @ErrorNumber int;
SELECT 1/0;

SET @ErrorNumber = @@ERROR;

IF (@ErrorNumber = 8134)
	BEGIN
		RAISERROR('Please stop dividing by zero',0,1) WITH LOG;
	END
GO





-- Will show the message right away
RAISERROR('I can not wait 10 seconds',16,1) WITH NOWAIT;
WAITFOR DELAY '00:00:10';
GO





EXEC sp_addmessage @msgnum=50010,@severity=16,
	@msgtext='Row count from the %s table does not match',
	@replace = 'replace';  
GO





-- Raise a message without the Id
DECLARE @TableName nvarchar(100) = 'SalesOrder';
RAISERROR(50010,16,1,@TableName);
GO





-- If the severity is over 19 our connection will terminate
RAISERROR('This is a fatal message',20,1) WITH LOG;
GO
-- Run this script to follow along with the demo

-- This will not work outside a catch
THROW;
GO





-- Raise a message without the Id
-- Notice we don't specify the severity
THROW 50010,'This is a great message',1;
GO




-- The syntax for throw is simple
-- Notice what line number is returned
BEGIN TRY
	
	SELECT 1/0;

END TRY

BEGIN CATCH

	THROW;
	PRINT 'Does this print?';

END CATCH
GO




-- Using a variable as the message text and number
DECLARE @MessageText nvarchar(500);
DECLARE @ErrorNumber int;
SET @MessageText = 'This is a custom error message';
SET @ErrorNumber = 65000;

THROW @ErrorNumber,@MessageText,1;
GO
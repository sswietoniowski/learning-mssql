USE Contacts;

DECLARE @RetVal INT;

EXEC @RetVal = dbo.InsertContactRole 
	@ContactId = 22,
	@RoleTitle = 'Actor';

PRINT 'RetVal = ' + CONVERT(VARCHAR(10), @RetVal);
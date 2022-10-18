USE Contacts;

EXEC dbo.InsertContactRole 
	@ContactId = 22,
	@RoleTitle = 'Comedian';

SELECT * FROM dbo.Roles;
SELECT * FROM dbo.ContactRoles CR INNER JOIN dbo.Roles R ON CR.RoleId = R.RoleId WHERE CR.ContactId = 22;

DELETE FROM dbo.Roles WHERE RoleTitle = 'Comedian';
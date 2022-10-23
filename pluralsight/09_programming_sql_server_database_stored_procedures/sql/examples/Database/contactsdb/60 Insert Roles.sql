USE Contacts;

IF ((SELECT COUNT(1) FROM dbo.Roles) = 0)
 BEGIN;
	INSERT INTO dbo.Roles(RoleTitle) 
		VALUES	('Developer'),
				('DBA'),
				('IT Support Specialist'),
				('Manager'),
				('Director');
 END;

GO

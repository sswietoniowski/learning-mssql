USE Contacts;

BULK INSERT dbo.ContactRoles
	FROM '$(path)\importfiles\05_ContactRoles.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\05_ContactRoles_Errors.csv',
	CHECK_CONSTRAINTS
);
	
GO



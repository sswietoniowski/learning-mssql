USE Contacts;

BULK INSERT dbo.Contacts
	FROM '$(path)importfiles\01_Contacts.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\01_Contacts_Errors.csv',
	CHECK_CONSTRAINTS
)
	
GO



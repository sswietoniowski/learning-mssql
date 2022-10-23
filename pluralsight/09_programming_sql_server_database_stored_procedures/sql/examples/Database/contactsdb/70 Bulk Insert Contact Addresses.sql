USE Contacts;
	
BULK INSERT dbo.ContactAddresses
	FROM '$(path)\importfiles\02_ContactAddresses.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\02_ContactAddresses_Errors.csv',
	CHECK_CONSTRAINTS
);

GO



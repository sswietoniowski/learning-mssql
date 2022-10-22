USE Contacts;

BULK INSERT dbo.ContactPhoneNumbers
	FROM '$(path)\importfiles\04_ContactPhoneNumbers.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\04_ContactPhoneNumbers_Errors.csv',
	CHECK_CONSTRAINTS
);
	
GO



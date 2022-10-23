USE Contacts;

BULK INSERT dbo.ContactVerificationDetails
	FROM '$(path)\importfiles\06_ContactVerificationDetails.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\06_ContactVerificationDetails_Errors.csv',
	CHECK_CONSTRAINTS
);
	
GO



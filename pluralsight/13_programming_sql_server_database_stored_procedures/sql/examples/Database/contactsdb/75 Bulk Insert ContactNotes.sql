USE Contacts;

BULK INSERT dbo.ContactNotes
	FROM '$(path)\importfiles\03_ContactNotes.csv'
WITH
(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	ERRORFILE = '$(path)\importfiles\03_ContactNotes_Errors.csv',
	CHECK_CONSTRAINTS
);
	
GO



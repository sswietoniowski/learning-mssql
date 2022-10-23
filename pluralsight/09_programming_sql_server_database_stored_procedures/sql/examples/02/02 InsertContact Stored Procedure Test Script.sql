USE Contacts;

DECLARE @ContactIdOut	INT;

EXEC dbo.InsertContact 
@FirstName = 'Stan',
@LastName = 'Laurel',
@DateOfBirth = '1890-06-17',
@AllowContactByPhone = 0,
@ContactId = @ContactIdOut OUTPUT;

SELECT * FROM dbo.Contacts WHERE LastName = 'Laurel';

SELECT * FROM dbo.Contacts WHERE ContactId = @ContactIdOut ORDER BY ContactId DESC;

SELECT @ContactIdOut AS ContactIdOut;
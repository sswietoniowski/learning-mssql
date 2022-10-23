USE Contacts;

IF NOT EXISTS (SELECT 1 FROM dbo.PhoneNumberTypes WHERE PhoneNumberType = 'Home')
 BEGIN;
	INSERT INTO dbo.PhoneNumberTypes(PhoneNumberType) VALUES ('Home');
 END;

IF NOT EXISTS (SELECT 1 FROM dbo.PhoneNumberTypes WHERE PhoneNumberType = 'Work')
 BEGIN;
	INSERT INTO dbo.PhoneNumberTypes(PhoneNumberType)
		SELECT 'Work';
 END;

IF NOT EXISTS (SELECT 1 FROM dbo.PhoneNumberTypes WHERE PhoneNumberType IN ('Mobile', 'Other'))
 BEGIN
	INSERT INTO dbo.PhoneNumberTypes(PhoneNumberType)
		VALUES ('Mobile'),
			   ('Other');
 END;

GO
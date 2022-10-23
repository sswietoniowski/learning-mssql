USE Contacts;

IF EXISTS
(
	SELECT 1 FROM sys.tables WHERE [Name] = 'PhoneNumberTypes'
)
BEGIN;
	DROP TABLE dbo.PhoneNumberTypes;
END;

CREATE TABLE dbo.PhoneNumberTypes
(
 PhoneNumberTypeId		TINYINT	IDENTITY(1,1)	NOT NULL,
 PhoneNumberType		VARCHAR(40)				NOT NULL,
 CONSTRAINT PK_PhoneNumberTypes PRIMARY KEY CLUSTERED (PhoneNumberTypeId)
);

GO
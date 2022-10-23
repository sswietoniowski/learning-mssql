USE Contacts;

IF EXISTS
(
	SELECT 1 FROM sys.tables WHERE [Name] = 'ContactPhoneNumbers'
)
BEGIN;
	DROP TABLE dbo.ContactPhoneNumbers;
END;

CREATE TABLE dbo.ContactPhoneNumbers
(
 PhoneNumberId		INT			NOT NULL IDENTITY(1,1),
 ContactId			INT			NOT NULL,
 PhoneNumberTypeId	TINYINT		NOT NULL,
 PhoneNumber		VARCHAR(30)	NOT NULL
 CONSTRAINT PK_ContactPhoneNumbers PRIMARY KEY CLUSTERED (PhoneNumberId),
 CONSTRAINT UQ_ContactIdPhoneNumber UNIQUE (ContactId, PhoneNumber)
);

ALTER TABLE dbo.ContactPhoneNumbers
	ADD CONSTRAINT FK_ContactPhoneNumbers_Contacts
		FOREIGN KEY (ContactId)
		REFERENCES dbo.Contacts (ContactId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;

ALTER TABLE dbo.ContactPhoneNumbers
	ADD CONSTRAINT FK_PhoneNumberTypes_ContactPhoneNumbers
		FOREIGN KEY (PhoneNumberTypeId)
		REFERENCES dbo.PhoneNumberTypes (PhoneNumberTypeId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;

GO
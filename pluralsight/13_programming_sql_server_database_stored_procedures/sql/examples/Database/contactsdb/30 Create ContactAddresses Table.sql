USE Contacts;

IF EXISTS
(
	SELECT 1 FROM sys.tables WHERE [Name] = 'ContactAddresses'
)
BEGIN;
	DROP TABLE dbo.ContactAddresses;
END;

CREATE TABLE dbo.ContactAddresses
(
 AddressId			INT	IDENTITY(1,1)	NOT NULL,
 ContactId			INT					NOT NULL,
 HouseNumber		VARCHAR(200)		NULL,
 Street				VARCHAR(200)		NULL,
 City				VARCHAR(200)		NULL,
 Postcode			VARCHAR(20)			NULL,
 CONSTRAINT PK_ContactAddresses PRIMARY KEY CLUSTERED (AddressId),
 CONSTRAINT CK_ContactAddresses_HouseNumberStreetCityPostcode CHECK (HouseNumber != '' AND Street != '' AND City != '' AND Postcode != '')
);

ALTER TABLE dbo.ContactAddresses
	ADD CONSTRAINT FK_ContactAddresses_Contacts
		FOREIGN KEY (ContactId)
		REFERENCES dbo.Contacts (ContactId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;

GO
USE Contacts;

IF EXISTS (SELECT 1 FROM sys.tables WHERE [Name] = 'ContactVerificationDetails')
 BEGIN;
	DROP TABLE dbo.ContactVerificationDetails;
 END;

CREATE TABLE dbo.ContactVerificationDetails
(
 ContactId				INT				NOT NULL,
 DrivingLicenseNumber	VARCHAR(40)		NULL,
 PassportNumber			VARCHAR(40)		NULL,
 ContactVerified		BIT				NOT NULL	CONSTRAINT DF_ContactVerificationDetails_ContactVerified DEFAULT 0
 CONSTRAINT PK_ContactVerificationDetails PRIMARY KEY CLUSTERED (ContactId)
);

ALTER TABLE dbo.ContactVerificationDetails
	ADD CONSTRAINT FK_ContactVerificationDetails_Contacts
		FOREIGN KEY (ContactId)
		REFERENCES dbo.Contacts (ContactId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;
		
GO

USE Contacts;

IF EXISTS (SELECT 1 FROM sys.tables WHERE [Name] = 'Contacts')
 BEGIN;
	DROP TABLE dbo.Contacts;
 END;

CREATE TABLE dbo.Contacts
(
 ContactId				INT IDENTITY(1,1)	NOT NULL,
 FirstName				VARCHAR(40)			NOT NULL,
 LastName				VARCHAR(40)			NOT NULL,
 DateOfBirth			DATE				NULL,
 AllowContactByPhone	BIT					NOT NULL	CONSTRAINT DF_Contacts_AllowContactByPhone DEFAULT 0,
 CreatedDate			DATETIME			NOT NULL	CONSTRAINT DF_Contacts_CreatedDate DEFAULT GETDATE(),
 CONSTRAINT PK_Contacts PRIMARY KEY CLUSTERED (ContactId),
 CONSTRAINT CK_Contacts_FirstNameLastName CHECK (FirstName != '' AND LastName != ''),
 CONSTRAINT CK_Contacts_DateOfBirth CHECK (DateOfBirth > '1850-01-01')
);

GO


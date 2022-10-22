USE Contacts;

IF EXISTS
(
	SELECT 1 FROM sys.tables WHERE [Name] = 'ContactNotes'
)
BEGIN;
	DROP TABLE dbo.ContactNotes;
END;

CREATE TABLE dbo.ContactNotes
(
 NoteId					INT IDENTITY(1,1)	NOT NULL,
 ContactId				INT					NOT NULL,
 Notes					VARCHAR(200)		NOT NULL,
 CONSTRAINT PK_ContactNotes PRIMARY KEY CLUSTERED (NoteId)
);

ALTER TABLE dbo.ContactNotes  
	WITH CHECK 
	ADD CONSTRAINT FK_ContactNotes_Contacts 
		FOREIGN KEY(ContactId)
		REFERENCES dbo.Contacts (ContactId);

GO
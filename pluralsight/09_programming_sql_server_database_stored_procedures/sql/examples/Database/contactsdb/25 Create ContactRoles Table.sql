USE Contacts;

IF EXISTS
(
	SELECT 1 FROM sys.tables WHERE [Name] = 'ContactRoles'
)
BEGIN;
	DROP TABLE dbo.ContactRoles;
END;

CREATE TABLE dbo.ContactRoles
(
 ContactId			INT		NOT NULL,
 RoleId				INT		NOT NULL,
 CONSTRAINT PK_ContactRoles PRIMARY KEY CLUSTERED (ContactId, RoleId)
);

ALTER TABLE dbo.ContactRoles
	ADD CONSTRAINT FK_ContactRoles_Contacts
		FOREIGN KEY (ContactId)
		REFERENCES dbo.Contacts (ContactId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;

ALTER TABLE dbo.ContactRoles
	ADD CONSTRAINT FK_ContactRoles_Roles
		FOREIGN KEY (RoleId)
		REFERENCES dbo.Roles (RoleId)
		ON UPDATE NO ACTION
		ON DELETE CASCADE;

GO
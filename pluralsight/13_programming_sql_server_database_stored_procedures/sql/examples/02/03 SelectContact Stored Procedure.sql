USE Contacts;

DROP PROCEDURE IF EXISTS dbo.SelectContact;

GO

CREATE PROCEDURE dbo.SelectContact
(
 @ContactId	INT
)
AS
BEGIN;

SET NOCOUNT ON;

SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone, CreatedDate
	FROM dbo.Contacts
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
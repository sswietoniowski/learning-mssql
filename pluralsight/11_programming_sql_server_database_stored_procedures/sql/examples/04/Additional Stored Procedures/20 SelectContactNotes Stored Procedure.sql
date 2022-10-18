USE Contacts;

GO

DROP PROCEDURE IF EXISTS dbo.SelectContactNotes;

GO

CREATE PROCEDURE dbo.SelectContactNotes
(
 @ContactId		INT
)
AS
BEGIN;

SET NOCOUNT ON;

SELECT	ContactId,
		Notes
	FROM dbo.ContactNotes
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
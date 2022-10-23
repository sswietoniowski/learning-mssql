USE Contacts;

IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactNotes')
 BEGIN;
	DROP PROCEDURE dbo.InsertContactNotes;
 END;

GO

CREATE PROCEDURE dbo.InsertContactNotes
(
 @ContactId		INT,
 @Notes			VARCHAR(MAX)
)
AS
BEGIN;

INSERT INTO dbo.ContactNotes (ContactId, Notes)
SELECT @ContactId, value
	FROM STRING_SPLIT(@Notes, ',');

SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;

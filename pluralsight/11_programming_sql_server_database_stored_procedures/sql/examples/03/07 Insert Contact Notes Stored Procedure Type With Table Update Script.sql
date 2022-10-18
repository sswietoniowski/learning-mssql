USE Contacts;

DROP PROCEDURE IF EXISTS dbo.InsertContactNotes;

GO

CREATE PROCEDURE dbo.InsertContactNotes
(
 @ContactId		INT,
 @Notes			ContactNote READONLY
)
AS
BEGIN;

DECLARE @TempNotes ContactNote;

INSERT INTO @TempNotes (Note)
SELECT Note FROM @Notes;

UPDATE @TempNotes SET Note = 'Pre: ' + Note;

INSERT INTO dbo.ContactNotes (ContactId, Notes)
	SELECT @ContactId, Note
		FROM @Notes;

SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;

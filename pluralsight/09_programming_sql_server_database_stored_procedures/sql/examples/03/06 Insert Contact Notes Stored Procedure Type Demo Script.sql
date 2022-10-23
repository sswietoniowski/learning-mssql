USE Contacts;

DECLARE @TempNotes	ContactNote;

INSERT INTO @TempNotes (Note)
VALUES
('Hi, Peter called.'),
('Quick note to let you know Jo wants you to ring her. She rang at 14:30.'),
('Terri asked about the quote, I have asked her to ring back tomorrow.');

EXEC dbo.InsertContactNotes
	@ContactId = 23,
	@Notes = @TempNotes;

USE Contacts;

GO

DROP PROCEDURE IF EXISTS dbo.SelectContactPhoneNumbers;

GO

CREATE PROCEDURE dbo.SelectContactPhoneNumbers
(
 @ContactId		INT
)
AS
BEGIN;

SET NOCOUNT ON;

SELECT	P.ContactId,
		P.PhoneNumber,
		T.PhoneNumberType
	FROM dbo.ContactPhoneNumbers P
		INNER JOIN dbo.PhoneNumberTypes T
			ON P.PhoneNumberTypeId = T.PhoneNumberTypeId
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
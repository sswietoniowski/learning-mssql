USE Contacts;

GO

DROP PROCEDURE IF EXISTS dbo.SelectContactAddresses;

GO

CREATE PROCEDURE dbo.SelectContactAddresses
(
 @ContactId		INT
)
AS
BEGIN;

SET NOCOUNT ON;

SELECT	ContactId,
		HouseNumber,
		Street,
		City,
		Postcode
	FROM dbo.ContactAddresses
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;
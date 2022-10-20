USE Contacts;

GO

DROP PROCEDURE IF EXISTS dbo.SelectPhoneNumberTypes;

GO

CREATE PROCEDURE dbo.SelectPhoneNumberTypes
AS
BEGIN;

SET NOCOUNT ON;

SELECT	PhoneNumberTypeId,
		PhoneNumberType
FROM dbo.PhoneNumberTypes;

SET NOCOUNT OFF;

END;
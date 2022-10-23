USE Contacts;

GO

CREATE TRIGGER trgContactAddressTestTrigger 
ON dbo.Contacts
AFTER INSERT
AS
INSERT INTO dbo.ContactAddresses (ContactId, HouseNumber, Street, City, Postcode)
SELECT i.ContactId, 'Cotchford Farm', 'Cotchford Lane', 'Hartfield', 'TN7 4DN'
FROM inserted i;

GO
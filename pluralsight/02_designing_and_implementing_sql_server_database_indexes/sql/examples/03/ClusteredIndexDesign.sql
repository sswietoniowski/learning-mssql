CREATE OR ALTER PROCEDURE InsertRow 
AS

INSERT INTO dbo.TransactionsClusteredAmount
(
    ReferenceShipmentID,
    ClientID,
    TransactionDate,
    TransactionType,
    Amount,
    InvoiceNumber
)
SELECT 1,1,GETDATE(), 'T', RAND(CHECKSUM(NEWID()))*5000, '';
GO


CREATE OR ALTER PROCEDURE UpdateRow 
AS

DECLARE @i INT = FLOOR(RAND(CHECKSUM(NEWID())) * 25000000)

UPDATE dbo.TransactionsClusteredAmount
	SET Amount = RAND(CHECKSUM(NEWID()))*5000
	WHERE TransactionID = @i;
GO

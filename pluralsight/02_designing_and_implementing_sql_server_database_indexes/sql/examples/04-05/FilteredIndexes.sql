-- filtered indexes

SELECT TransactionID, ClientID, TransactionType FROM dbo.Transactions
	WHERE ClientID = 3014 AND TransactionType = 'D'

GO

DECLARE @ClientID INT = 3014, @TransactionType CHAR(1) = 'D'

SELECT TransactionID, ClientID, TransactionType FROM dbo.Transactions
	WHERE ClientID = @ClientID AND TransactionType = @TransactionType
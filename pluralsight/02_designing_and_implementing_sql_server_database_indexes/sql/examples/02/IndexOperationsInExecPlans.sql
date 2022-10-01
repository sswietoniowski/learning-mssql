CREATE NONCLUSTERED INDEX idx_Transactions_TransactionTypeAmount
	ON dbo.Transactions (TransactionType, Amount)
GO

-- Seek

SELECT TransactionID, TransactionType, Amount 
	FROM dbo.Transactions 
	WHERE TransactionType = 'D' AND Amount = 1724.45

-- scan

SELECT SUM(Amount) 
	FROM dbo.Transactions

-- scan with predicate

SELECT SUM(Amount) 
	FROM dbo.Transactions
	WHERE Amount > 2500


	
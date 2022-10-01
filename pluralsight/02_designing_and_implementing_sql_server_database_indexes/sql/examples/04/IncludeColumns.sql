-- include columns

SELECT TransactionID, ClientID, TransactionType, Amount, TransactionDate FROM dbo.Transactions
	WHERE ClientID = 3014 AND TransactionType = 'D'
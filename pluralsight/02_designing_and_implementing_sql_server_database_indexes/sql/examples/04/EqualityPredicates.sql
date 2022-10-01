-- WHERE clause with equality predicates

SELECT TransactionID, ClientID FROM dbo.Transactions
	WHERE ClientID = 2487 

SELECT TransactionID, TransactionType FROM dbo.Transactions
	WHERE TransactionType = 'W'

SELECT TransactionID, ClientID, TransactionType FROM dbo.Transactions
	WHERE ClientID = 2487 AND TransactionType = 'W'

-- 28 logical reads

---------------------------------------------------


CREATE NONCLUSTERED INDEX idx_Transactions_ClientID ON dbo.Transactions (ClientID)
--CREATE NONCLUSTERED INDEX idx_Transactions_TransactionType ON dbo.Transactions (TransactionType)
--DROP INDEX idx_Transactions_TransactionType ON dbo.Transactions
CREATE NONCLUSTERED INDEX idx_Transactions_TransactionTypeClientID ON dbo.Transactions (TransactionType, ClientID)

--DROP INDEX idx_Transactions_ClientID ON dbo.Transactions
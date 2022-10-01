SELECT TransactionID, Amount FROM dbo.Transactions
	WHERE Amount > 4500

SELECT TransactionID, ClientID, Amount FROM dbo.Transactions
	WHERE Amount > 4500 AND ClientID = 637

SELECT TransactionID, Amount, TransactionDate FROM dbo.Transactions
	WHERE Amount > 4500 AND TransactionDate < '2450-03-01'

--------------------------------------------------------

CREATE NONCLUSTERED INDEX idx_Transactions_AmountTransactionDate ON dbo.Transactions (Amount, TransactionDate)
-- 10 reads

CREATE NONCLUSTERED INDEX idx_Transactions_TransactionDateAmount ON dbo.Transactions (TransactionDate, Amount)
-- 15 reads


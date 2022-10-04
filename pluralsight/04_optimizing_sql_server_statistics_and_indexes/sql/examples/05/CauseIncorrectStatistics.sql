ALTER DATABASE InterstellarTransport SET AUTO_UPDATE_STATISTICS OFF
GO

UPDATE dbo.Transactions
	SET TransactionDate = DATEADD(MONTH, 6, TransactionDate)
	WHERE TransactionID IN (SELECT TOP (50) PERCENT TransactionID FROM dbo.Transactions ORDER BY NEWID())




-- OR predicates


SELECT TransactionID, ReferenceShipmentID, InvoiceNumber FROM dbo.Transactions 
	WHERE ReferenceShipmentID = 452 OR InvoiceNumber = 'BBBC20425'

SELECT TransactionID, ClientID, Amount, TransactionType FROM dbo.Transactions 
	WHERE ClientID = 2875 AND (Amount > 2500 OR TransactionType = 'S')
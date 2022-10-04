SET STATISTICS IO, TIME ON
GO

DBCC FREEPROCCACHE
GO

SELECT s.ReferenceNumber,
       s.Priority,
       t.TransactionDate,
       t.TransactionType,
       t.Amount,
       t.InvoiceNumber 
FROM dbo.Transactions t
	INNER JOIN dbo.Shipments s ON s.ShipmentID = t.ReferenceShipmentID
WHERE TransactionDate > '2451-01-02'


/*
(15298 rows affected)
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Shipments'. Scan count 1, logical reads 254, physical reads 1, read-ahead reads 252, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Transactions'. Scan count 1, logical reads 166, physical reads 1, read-ahead reads 164, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 46 ms,  elapsed time = 261 ms.
*/

/*
Table 'Shipments'. Scan count 0, logical reads 13260, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Transactions'. Scan count 1, logical reads 13278, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 47 ms,  elapsed time = 119 ms.
*/
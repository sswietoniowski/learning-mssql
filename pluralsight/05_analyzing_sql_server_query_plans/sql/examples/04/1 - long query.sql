USE WideWorldImporters
GO

-- Long Query
SELECT *
FROM [Sales].[InvoiceLines] il 
INNER JOIN [Sales].[Invoices] i ON i.InvoiceID = il.InvoiceID
INNER JOIN [Sales].[OrderLines] ol ON ol.OrderID = i.OrderID
INNER JOIN [Sales].[Orders] o ON o.OrderID = ol.OrderID
GO

-- Long Query
SELECT *
FROM [Sales].[InvoiceLines] il 
INNER JOIN [Sales].[Invoices] i ON i.InvoiceID = il.InvoiceID
WHERE il.StockItemID > 100
GO

-- Long Query
SELECT *
FROM [Sales].[InvoiceLines] il 
INNER JOIN [Sales].[Invoices] i ON i.InvoiceID = il.InvoiceID
WHERE i.ConfirmedReceivedBy  = 'Alinne Matos'
GO

-- Query with Insert
CREATE TABLE #Test (ID INT)
INSERT INTO #Test (ID)
SELECT OrderID
FROM [Sales].[Orders]
GO
DROP TABLE #Test
GO

-- Estimated Execution Plan
SET SHOWPLAN_ALL ON
SET SHOWPLAN_XML ON

SET SHOWPLAN_ALL OFF
SET SHOWPLAN_XML OFF
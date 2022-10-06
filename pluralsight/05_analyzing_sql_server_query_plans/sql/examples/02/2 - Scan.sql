USE WideWorldImporters
GO
SET STATISTICS IO, TIME ON
GO


SELECT i.AccountsPersonID, il.Description, o.OrderID
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
GO



CREATE NONCLUSTERED INDEX [IX_Invoices_Cols]
ON [Sales].[Invoices] ([BillToCustomerID])
INCLUDE ([OrderID],[AccountsPersonID])
GO




SELECT i.AccountsPersonID, il.Description, o.OrderID
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
GO





CREATE NONCLUSTERED INDEX [IX_InvoiceLines_Cols]
ON [Sales].[InvoiceLines] ([InvoiceID],[Description])
GO



DROP INDEX [IX_Invoices_Cols] ON [Sales].[Invoices] 
GO

DROP INDEX [IX_InvoiceLines_Cols] ON [Sales].[InvoiceLines] 
GO
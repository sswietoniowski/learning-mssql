USE WideWorldImporters
GO
SET STATISTICS IO, TIME ON
GO



SELECT i.AccountsPersonID, il.Description, o.OrderID, il.LastEditedWhen
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
ORDER BY il.LastEditedWhen
GO




SELECT i.AccountsPersonID, il.Description, o.OrderID, il.LastEditedWhen
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
ORDER BY il.LastEditedWhen
OPTION (MAXDOP 1)
GO




CREATE NONCLUSTERED INDEX [IX_InvoiceLines_Cols]
ON [Sales].[InvoiceLines] ([LastEditedWhen],[InvoiceID],[Description])
GO




SELECT i.AccountsPersonID, il.Description, o.OrderID, il.LastEditedWhen
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
ORDER BY il.LastEditedWhen
GO



DROP INDEX [IX_InvoiceLines_Cols] ON [Sales].[InvoiceLines] 
GO
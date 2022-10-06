USE WideWorldImporters
GO
SET STATISTICS IO, TIME ON
GO



SELECT i.AccountsPersonID, i.CustomerPurchaseOrderNumber, il.LastEditedWhen
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
WHERE i.CustomerPurchaseOrderNumber = 17500
GO




SELECT i.AccountsPersonID, i.CustomerPurchaseOrderNumber, il.LastEditedWhen
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
WHERE i.CustomerPurchaseOrderNumber = '17500'
GO



CREATE NONCLUSTERED INDEX [IX_Invoices_CustomerPurchaseOrderNumber]
ON [Sales].[Invoices] ([CustomerPurchaseOrderNumber])
GO



DROP INDEX [IX_Invoices_CustomerPurchaseOrderNumber] ON [Sales].[Invoices] 
GO
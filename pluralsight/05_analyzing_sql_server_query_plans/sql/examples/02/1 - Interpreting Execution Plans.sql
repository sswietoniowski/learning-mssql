USE WideWorldImporters
GO

SELECT *
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE BillToCustomerID > 100
GO
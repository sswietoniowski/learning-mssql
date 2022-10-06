USE WideWorldImporters
GO
SELECT *
FROM Sales.Invoices;
GO
SELECT *
FROM Sales.Orders;
GO
SELECT *
FROM Sales.CustomerTransactions;
GO
SELECT *
FROM Sales.SpecialDeals;
GO
SELECT *
FROM Purchasing.PurchaseOrderLines;
GO
SELECT *
FROM Purchasing.PurchaseOrders;
GO
SELECT *
FROM Sales.Invoices;
GO
SELECT *
FROM Sales.Orders;
GO
SELECT *
FROM Sales.CustomerTransactions;
GO
SELECT *
FROM Sales.SpecialDeals;
GO
SELECT *
FROM Purchasing.PurchaseOrderLines;
GO
SELECT *
FROM Purchasing.PurchaseOrders;
GO
SELECT *
FROM Sales.Invoices;
GO
SELECT *
FROM Sales.Orders;
GO
SELECT *
FROM Sales.CustomerTransactions;
GO
SELECT *
FROM Sales.SpecialDeals;
GO
SELECT *
FROM Purchasing.PurchaseOrderLines;
GO
SELECT *
FROM Purchasing.PurchaseOrders;
GO
SELECT *
FROM Sales.Invoices;
GO
SELECT *
FROM Sales.Orders;
GO
SELECT *
FROM Sales.CustomerTransactions;
GO
SELECT *
FROM Sales.SpecialDeals;
GO
SELECT *
FROM Purchasing.PurchaseOrderLines;
GO
SELECT *
FROM Purchasing.PurchaseOrders;
GO
SELECT *
FROM Sales.Invoices;
GO
SELECT *
FROM Sales.Orders;
GO
SELECT *
FROM Sales.CustomerTransactions;
GO
SELECT *
FROM Sales.SpecialDeals;
GO
SELECT *
FROM Purchasing.PurchaseOrderLines;
GO
SELECT *
FROM Purchasing.PurchaseOrders;
GO

SELECT i.AccountsPersonID, il.Description, o.OrderID
FROM Sales.Invoices i
INNER JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
INNER JOIN Sales.Orders o ON o.OrderID = i.OrderID
WHERE i.BillToCustomerID > 100
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

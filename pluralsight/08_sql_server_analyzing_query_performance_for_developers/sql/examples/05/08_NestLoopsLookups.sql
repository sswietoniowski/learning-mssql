USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO


/*
	What's are the inner and outer 
	data sets?
*/
SELECT 
	[ol].[OrderLineID],
	[o].[CustomerID]
FROM [Sales].[OrderLines] [ol] 
INNER JOIN [Sales].[Orders] [o] 
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [o].[CustomerID] = 185;
GO


/*
	What if we reverse the OUTER/INNER
	*do not recommend this hint
*/
SELECT 
	[ol].[OrderLineID],
	[o].[CustomerID]
FROM [Sales].[OrderLines] [ol] 
INNER JOIN [Sales].[Orders] [o] 
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [o].[CustomerID] = 185
OPTION (FORCE ORDER);
GO


/*
	Force the order AND force a loop
	*also do not recommend this hint
*/
SELECT 
	[ol].[OrderLineID],
	[o].[CustomerID]
FROM [Sales].[OrderLines] [ol] 
INNER LOOP JOIN [Sales].[Orders] [o] 
	ON [ol].[OrderID] = [o].[OrderID]
WHERE [o].[CustomerID] = 185
OPTION (FORCE ORDER);
GO


/*
	Run all three together and compare IO and cost
*/


/*
	Pay attention to scans in the inner table
*/
SELECT 
	[ol].[OrderLineID],
	[ol].[Quantity],
	[s].[StockItemName]
FROM [Warehouse].[StockItems] [s]
INNER JOIN [Sales].[OrderLines] [ol] 
	ON [s].[StockItemID] = [ol].[StockItemID]
WHERE [ol].[StockItemID] = 185;
GO


/*
	There's a nonclustered index on OrderLines
	that leads on StockitemID...
	If we try to force using it, how does this affect the cost?
	What's another way to try and improve the query?
*/
SELECT 
	[ol].[OrderLineID],
	[ol].[Quantity],
	[s].[StockItemName]
FROM [Warehouse].[StockItems] [s]
INNER JOIN [Sales].[OrderLines] [ol] WITH (INDEX (IX_Sales_OrderLines_AllocatedStockItems))
	ON [s].[StockItemID] = [ol].[StockItemID]
WHERE [ol].[StockItemID] = 185;
GO


/*
	Modify existing NCI to try and improve it
*/
CREATE NONCLUSTERED INDEX [IX_Sales_OrderLines_AllocatedStockItems] 
	ON [Sales].[OrderLines] (
		[StockItemID] ASC
		)
	INCLUDE (
		[PickedQuantity], [Quantity]
		) 
WITH (DROP_EXISTING = ON) 
ON [USERDATA];
GO


/*
	Did we improve performance?
*/
SELECT 
	[ol].[OrderLineID],
	[ol].[Quantity],
	[s].[StockItemName]
FROM [Warehouse].[StockItems] [s]
INNER JOIN [Sales].[OrderLines] [ol] 
	ON [s].[StockItemID] = [ol].[StockItemID]
WHERE [ol].[StockItemID] = 185;
GO


/*
	Change NCI back
*/
CREATE NONCLUSTERED INDEX [IX_Sales_OrderLines_AllocatedStockItems] 
	ON [Sales].[OrderLines] (
		[StockItemID] ASC
		)
	INCLUDE (
		[PickedQuantity]
		) 
WITH (DROP_EXISTING = ON) 
ON [USERDATA];
GO


/*
	Create a copy of Orders and one nonclustered index
*/
SELECT *
INTO [Sales].[Copy_Orders]
FROM [Sales].[Orders];
GO

CREATE NONCLUSTERED INDEX [NCI_Copy_Orders_ContactPersonID] 
	ON [Sales].[Copy_Orders] (
		[ContactPersonID]
		);
GO


/*
	Index Seek + RID Lookup (Heap)
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Copy_Orders]
WHERE [ContactPersonID] = 3144;
GO


/*
	Index Seek + Key Lookup (CI)
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Orders]
WHERE [ContactPersonID] = 3144;
GO


/*
	Change the NCI to cover the query
	(Not a solution ALL the time!)
*/
CREATE NONCLUSTERED INDEX [FK_Sales_Orders_ContactPersonID] 
	ON [Sales].[Orders] (
		[ContactPersonID] ASC
		)
	INCLUDE (
		[OrderDate], [CustomerPurchaseOrderNumber]
		)
WITH (DROP_EXISTING = ON) 
ON [USERDATA];
GO


/*
	Re-run the query with the covering index
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Orders]
WHERE [ContactPersonID] = 3144;
GO


/*
	Change NCI back
*/
CREATE NONCLUSTERED INDEX [FK_Sales_Orders_ContactPersonID] 
	ON [Sales].[Orders] (
		[ContactPersonID] ASC
		)
WITH (DROP_EXISTING = ON) 
ON [USERDATA];
GO


/*
	Clean up
*/
DROP TABLE [Sales].[Copy_Orders];
GO
USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO


/*
	Query with a hash join
*/
SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Warehouse].[StockItems] [si]	
JOIN [Sales].[OrderLines] [ol]
	ON [si].[StockItemID] = [ol].[StockItemID];
GO


/*
	What if we reversed build/probe?
	Compare the following two queries side-by-side
*/
DBCC FREEPROCCACHE;
GO

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID]
OPTION (FORCE ORDER);
GO


/*
	How can we address the hash match?
*/
EXEC sp_SQLskills_helpindex 'Sales.OrderLines'
GO
EXEC sp_SQLskills_helpindex 'Warehouse.StockItems'
GO


/*
	We have an index that leads on StockItemID
	and has everything we need...
*/

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol] WITH (INDEX (IX_Sales_OrderLines_Perf_20160301_02))
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO


/*
	Compare
*/
SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO


/*
	Create a new index with just what we need?
*/
CREATE NONCLUSTERED INDEX [IX_OrderLines_StockItemID] 
	ON [Sales].[OrderLines](
		[StockItemID] ASC,
		[PickedQuantity] ASC,
		[OrderID])
ON [PRIMARY];
GO


/*
	Check again
*/
SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID]
OPTION (RECOMPILE);
GO


/*
	Create second index, compressed
*/
CREATE NONCLUSTERED INDEX [IX_OrderLines_StockItemID_Compressed] 
	ON [Sales].[OrderLines](
		[StockItemID] ASC,
		[PickedQuantity] ASC,
		[OrderID])
WITH (DATA_COMPRESSION = PAGE)
ON [PRIMARY];
GO


/*
	Check again
*/
SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID]
OPTION (RECOMPILE);
GO


/*
	Final compare
*/
SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol]
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID]
OPTION (RECOMPILE);
GO

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol] WITH (INDEX (IX_Sales_OrderLines_Perf_20160301_02))
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol] WITH (INDEX (IX_OrderLines_StockItemID))
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO

SELECT 
	[ol].[OrderID],
	[ol].[OrderLineID],
	[ol].[StockItemID],
	[ol].[PickedQuantity],
	[si].[StockItemName],
	[si].[UnitPrice]
FROM [Sales].[OrderLines] [ol] WITH (INDEX (IX_OrderLines_StockItemID_Compressed))
JOIN [Warehouse].[StockItems] [si]	
	ON [ol].[StockItemID] = [si].[StockItemID];
GO


/*
	Clean up
*/
DROP INDEX [IX_OrderLines_StockItemID] ON [Sales].[OrderLines];
GO
DROP INDEX [IX_OrderLines_StockItemID_Compressed] ON [Sales].[OrderLines];
GO
USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO


/*
	review of what's in the index
*/
EXEC sp_SQLskills_helpindex 'Sales.Orders';
GO


/*
	What do we see in the plan?
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] = 890;
GO


/*
	Edit existing index
*/
CREATE NONCLUSTERED INDEX [FK_Sales_Orders_CustomerID]
	ON [Sales].[Orders](
		[CustomerID]
	)
	INCLUDE (
		[OrderDate],
		[ExpectedDeliveryDate], 
 		[SalespersonPersonID]
	)
WITH (DROP_EXISTING = ON) 
ON [PRIMARY];
GO


/*
	Re-run the query
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] = 890;
GO


/*
	What if someone adds on to our WHERE clause?
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] = 890
AND [OrderDate] BETWEEN '2016-05-01 00:00:00.000' AND '2016-05-31 00:00:00.000';
GO


/*
	USE TF 9130 (undocumented) to push this out to a filter to see it better
	(don't use in production code)
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] = 890
AND [OrderDate] BETWEEN '2016-05-01 00:00:00.000' AND '2016-05-31 00:00:00.000'
OPTION (QUERYTRACEON 9130);
GO


/*
	We could change the index
*/
CREATE NONCLUSTERED INDEX [FK_Sales_Orders_CustomerID]
	ON [Sales].[Orders](
		[CustomerID],
		[OrderDate]
	)
	INCLUDE (
		[ExpectedDeliveryDate], 
 		[SalespersonPersonID]
	)
WITH (DROP_EXISTING = ON) 
ON [PRIMARY];
GO


/*
	Now what do predicates look like?
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] = 890
AND [OrderDate] BETWEEN '2016-05-01 00:00:00.000' AND '2016-05-31 00:00:00.000';
GO


/*
	Look at a range
*/
SELECT 
	[CustomerID],
	[OrderDate], 
	[ExpectedDeliveryDate], 
 	[SalespersonPersonID]
FROM [Sales].[Orders] 
WHERE [CustomerID] BETWEEN 800 AND 900
AND [OrderDate] BETWEEN '2016-05-01 00:00:00.000' AND '2016-05-31 00:00:00.000';
GO


/*
	Residuals can appear in lookups...  
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Orders]
WHERE [ContactPersonID] = 3144;
GO


/*
	Add on to predicate
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Orders]
WHERE [ContactPersonID] = 1179
AND [OrderDate] > '20160101';
GO


/*
	Can use TF 9130 to see this better
*/
SELECT 
	[ContactPersonID], 
	[OrderDate], 
	[CustomerPurchaseOrderNumber]
FROM [Sales].[Orders]
WHERE [ContactPersonID] = 1179
AND [OrderDate] > '20160101'
OPTION (QUERYTRACEON 9130);
GO



/*
	They can also exist in hash joins
*/

DECLARE @StartDate DATETIME2(7) = '20160801';
DECLARE @EndDate DATETIME2(7) = '20160831';

DECLARE @ItemHx TABLE (
	[StockItemID] INT, 
	[StockItemName] NVARCHAR(100)
	);

INSERT INTO @ItemHx (
	[StockItemID], 
	[StockItemName]
	)
SELECT 
	[s].[StockItemID], 
	[s].[StockItemName]
FROM [Warehouse].[StockItemTransactions] [st] 
JOIN [Warehouse].[StockItems] [s]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN @StartDate AND @EndDate;

SELECT 
	[ol].[StockItemID],
	[i].[StockItemName], 
	[h].[LastCostPrice],
	[h].[QuantityOnHand], 
	[h].[ReorderLevel]
FROM [Sales].[OrderLines] [ol] 
JOIN [Warehouse].[StockItemHoldings] [h] 
	ON [ol].[StockItemID] = [h].[StockItemID] 
JOIN @ItemHx [i] 
	ON [i].[StockItemID] = [h].[StockItemID]
WHERE [h].[LastCostPrice] > 50.00
AND [ol].[Quantity]  > 5
OPTION (RECOMPILE);
GO


/*
	Reset
*/
CREATE NONCLUSTERED INDEX [FK_Sales_Orders_CustomerID]
	ON [Sales].[Orders](
		[CustomerID]
	)
WITH (DROP_EXISTING = ON) 
ON [PRIMARY];
GO







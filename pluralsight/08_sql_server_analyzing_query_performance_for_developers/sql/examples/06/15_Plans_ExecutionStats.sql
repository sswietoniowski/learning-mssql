USE [WideWorldImporters]
GO

SET STATISTICS IO ON;
GO

SET STATISTICS TIME ON;
GO

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
AND [ol].[Quantity]  > 5;
GO


USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO

/*
	Query that returns a lot of data
*/
SELECT 
	[o].[OrderID], 
	[o].[CustomerID],
	[ol].[Quantity], 
	[s].[StockItemID], 
	[s].[StockItemName],
	(([ol].[Quantity]*[ol].[UnitPrice]) + [ol].[TaxRate]) [TotalItemCost], 
 	[s].[Brand]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
JOIN [Warehouse].[StockItems] [s]
	ON [ol].[StockItemID] = [s].[StockItemID]
JOIN [Warehouse].[StockItemTransactions] [st]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN '20160101' AND '20160131'
AND [ol].[Quantity] > 50
ORDER BY [s].[StockItemName];
GO


/*
	Create a function to calculate sales price
*/
CREATE FUNCTION Sales.TotalCost(
	@Quantity INT,
	@UnitPrice DECIMAL(18,2),
	@TaxRate DECIMAL(18,3))
	RETURNS DECIMAL(18,3)
	AS
	BEGIN
	
		DECLARE @PreTaxCost DECIMAL(18,3) = @UnitPrice * @Quantity;

		RETURN (@PreTaxCost + @TaxRate)

	END
GO


/*
	Same query, but function in the SELECT
	What changes in the plan?
*/
SELECT 
	[o].[OrderID], 
	[o].[CustomerID],
	[ol].[Quantity], 
	[s].[StockItemID], 
	[s].[StockItemName],
	Sales.TotalCost([ol].[Quantity], [ol].[UnitPrice], [ol].[TaxRate]) [TotalItemCost], 
 	[s].[Brand]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
JOIN [Warehouse].[StockItems] [s]
	ON [ol].[StockItemID] = [s].[StockItemID]
JOIN [Warehouse].[StockItemTransactions] [st]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN '20160101' AND '20160131'
AND [ol].[Quantity] > 50
ORDER BY [s].[StockItemName];
GO


/*
	Add an undocumented TF
	(use only for testing)
*/
SELECT 
	[o].[OrderID], 
	[o].[CustomerID],
	[ol].[Quantity], 
	[s].[StockItemID], 
	[s].[StockItemName],
	Sales.TotalCost([ol].[Quantity], [ol].[UnitPrice], [ol].[TaxRate]) [TotalItemCost], 
 	[s].[Brand]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID]
JOIN [Warehouse].[StockItems] [s]
	ON [ol].[StockItemID] = [s].[StockItemID]
JOIN [Warehouse].[StockItemTransactions] [st]
	ON [s].[StockItemID] = [st].[StockItemID]
WHERE [st].[TransactionOccurredWhen] BETWEEN '20160101' AND '20160131'
AND [ol].[Quantity] > 50
ORDER BY [s].[StockItemName]
OPTION (RECOMPILE, QUERYTRACEON 8649);
GO


/*
	Clean up
*/
DROP FUNCTION Sales.TotalCost;
GO
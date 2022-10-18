USE [WideWorldImporters];
GO

/*
	What trace flags enabled for instance?
*/
DBCC TRACESTATUS;
GO

/*
	Run a query, what do we see?
*/
SELECT
	[si].[StockItemName],
	[si].[SupplierID],
	[sh].[ReorderLevel],
	[sh].[QuantityOnHand]
FROM [Warehouse].[StockItems] [si]
JOIN [Warehouse].[StockItemHoldings] [sh]
	ON [si].[StockItemID] = [sh].[StockItemID]
WHERE [sh].[ReorderLevel] <= 10
AND [sh].[QuantityOnHand] BETWEEN 10 and 25; 
GO


/*
	Add a query hint, does this show up?
	Understand trace flags before implementing!
*/
SELECT
	[si].[StockItemName],
	[si].[SupplierID],
	[sh].[ReorderLevel],
	[sh].[QuantityOnHand]
FROM [Warehouse].[StockItems] [si]
JOIN [Warehouse].[StockItemHoldings] [sh]
	ON [si].[StockItemID] = [sh].[StockItemID]
WHERE [sh].[ReorderLevel] <= 10
AND [sh].[QuantityOnHand] BETWEEN 10 and 25
OPTION (QUERYTRACEON 9130); 
GO


/*
	What if enable TF for the session?
	Understand trace flags before implementing!
*/
DBCC TRACEON (1224);
GO

SELECT
	[si].[StockItemName],
	[si].[SupplierID],
	[sh].[ReorderLevel],
	[sh].[QuantityOnHand]
FROM [Warehouse].[StockItems] [si]
JOIN [Warehouse].[StockItemHoldings] [sh]
	ON [si].[StockItemID] = [sh].[StockItemID]
WHERE [sh].[ReorderLevel] <= 10
AND [sh].[QuantityOnHand] BETWEEN 10 and 25; 
GO

DBCC TRACEOFF (1224);
GO


/*
	What's in the plan cache?
*/
SELECT
	[qs].[last_execution_time],
	[qs].[execution_count],
	[t].[text],
	[p].[query_plan],
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats [qs]
CROSS APPLY sys.dm_exec_sql_text([qs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([qs].[plan_handle]) [p]
WHERE [t].[text] LIKE '%StockItemHoldings%';
GO
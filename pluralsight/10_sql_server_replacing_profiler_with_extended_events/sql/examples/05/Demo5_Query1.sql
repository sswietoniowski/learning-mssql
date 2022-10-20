USE [AdventureWorks2014];
GO

	
SELECT  TOP 1 [h].[SalesOrderID],
        [d].[SalesOrderDetailID],
        [d].[OrderQty],
		[d].[UnitPrice],
        [d].[LineTotal],
        [h].[OrderDate],
		[h].[SubTotal],
		[h].[TotalDue]
FROM    [Sales].[SalesOrderHeader] [h]
INNER LOOP JOIN [Sales].[SalesOrderDetail] [d]
        ON [h].[SalesOrderID] = [d].[SalesOrderID]
OPTION  (FORCE ORDER);
GO 10000000

USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO


/*
	check out our data first
*/
EXEC sp_SQLskills_helpindex 'Purchasing.PurchaseOrders';
GO
EXEC sp_SQLskills_helpindex 'Purchasing.PurchaseOrderLines';
GO


/*
	What is the join type?
*/
SELECT 
	[p].[PurchaseOrderID], 
	[pl].[PurchaseOrderLineID]
FROM [Purchasing].[PurchaseOrders] [p]
JOIN [Purchasing].[PurchaseOrderLines] [pl] 
	ON [p].[PurchaseOrderID] = [pl].[PurchaseOrderID];
GO

/*
	Sometimes the optimizer will scan a smaller index
*/
EXEC sp_SQLskills_helpindex 'Sales.Orders';
GO
EXEC sp_SQLskills_helpindex 'Sales.OrderLines';
GO

SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Change from WHERE the OrderID columns is selected
*/
SELECT 
	[ol].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Create a copy of Orders and OrderLines
	Change the primary key slightly for OrderLines
*/

SELECT *
INTO [Sales].[Copy_Orders]
FROM [Sales].[Orders];
GO

ALTER TABLE [Sales].[Copy_Orders] 
ADD  CONSTRAINT [PK_Copy_Orders_OrderID] 
PRIMARY KEY CLUSTERED (
	[OrderID] ASC
	)
GO

SELECT *
INTO [Sales].[Copy_OrderLines]
FROM [Sales].[OrderLines];
GO

ALTER TABLE [Sales].[Copy_OrderLines] 
ADD CONSTRAINT [PK_Copy_OrderLines_OrderID_OrderLineID] 
PRIMARY KEY CLUSTERED (
	[OrderID] DESC,
	[OrderLineID] DESC
	);
GO


/*
	Same query as before, but CI
	for OrderLines leads on Orders,
	and index ordered in reverse 
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Drop constraint
*/
ALTER TABLE [Sales].[Copy_Orders] 
	DROP CONSTRAINT [PK_Copy_Orders_OrderID];
GO


/*
	Re-run the query...
	what type of join and why?
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO

/*
	Re-run the query and force the merge
	How does the data get ordered?
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
OPTION (MERGE JOIN);
GO


/*
	Recreate the clustered index on Copy_Orders,
	but not defined as primary key
*/
CREATE CLUSTERED INDEX [CI_Copy_Orders_OrderID] 
	ON [Sales].[Copy_Orders] (
		[OrderID] ASC
		);
GO


/*
	Re-run again...
	What's the join type?
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Drop constraint and re-create clustered index 
*/
ALTER TABLE [Sales].[Copy_OrderLines] 
	DROP CONSTRAINT [PK_Copy_OrderLines_OrderID_OrderLineID];
GO

CREATE CLUSTERED INDEX [CI_Copy_OrderLines] 
	ON [Sales].[Copy_OrderLines](
		[OrderID] ASC, [OrderLineID] ASC
		);
GO


/*
	Re-run again
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Force the merge
*/
SELECT 
	[o].[OrderID], 
	[ol].[OrderLineID]
FROM [Sales].[Copy_Orders] [o]
JOIN [Sales].[Copy_OrderLines] [ol] 
	ON [o].[OrderID] = [ol].[OrderID]
OPTION (MERGE JOIN);
GO

/*
	Drop our tables
*/
DROP TABLE [Sales].[Copy_Orders];
GO
DROP TABLE [Sales].[Copy_OrderLines];
GO


/*
	How else can SQL Server 
	order the data?
*/
SELECT *
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	SELECT query with a TOP 
*/
SELECT TOP 1000 * 
FROM [Sales].[OrderLines];
GO


/*
	SELECT query with a TOP, 
	AND an ORDER BY...
*/
SELECT TOP 1000 * 
FROM [Sales].[OrderLines]
ORDER BY [Description];
GO


SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders];
GO

SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
ORDER BY [CustomerID];
GO

SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders] WITH (INDEX (FK_Sales_Orders_CustomerID))
ORDER BY [CustomerID];
GO


/*
	Run last two together and look at statistics
*/

/*
	Add a covering index to support the query
*/
CREATE NONCLUSTERED INDEX [IX_Sales_Orders_CustomerID_Dates] 
	ON [Sales].[Orders](
		[CustomerID] ASC
		) 
	INCLUDE (
		[OrderDate], [ExpectedDeliveryDate]
		)
ON [USERDATA];
GO


/*
	SELECT query with an ORDER BY, 
	now with an index to support
*/
SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
ORDER BY [CustomerID];
GO


/*
	What's the IO improvement?
*/
SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders] WITH (INDEX (PK_Sales_Orders))
ORDER BY [CustomerID];
GO

SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders] WITH (INDEX (FK_Sales_Orders_CustomerID))
ORDER BY [CustomerID];
GO

SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
ORDER BY [CustomerID];
GO


/*
	SELECT query with an ORDER BY, 
	change the order to DESC
*/
SELECT 
	[CustomerID],
	[OrderDate],
	[ExpectedDeliveryDate]
FROM [Sales].[Orders]
ORDER BY [CustomerID] DESC;
GO

/*
	Clean up
*/
DROP INDEX [IX_Sales_Orders_CustomerID_Dates] ON [Sales].[Orders];
GO

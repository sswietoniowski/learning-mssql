USE [WideWorldImporters]
GO

/****** Object:  View [Sales].[ViewPowerBISalesOrdersConsolidated]    Script Date: 4/30/2020 10:09:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[ViewPowerBISalesOrdersConsolidated]
AS
	SELECT
		o.OrderID,
		o.CustomerID,
		o.OrderDate,
		so.OrderLineID,
		so.StockItemID,
		so.[Description],
		so.Quantity,
		so.UnitPrice,
		so.PickedQuantity,
		c.CustomerName,
		c.PhoneNumber
	FROM 
		Sales.Orders o 
			INNER JOIN Sales.OrderLines so 
				ON o.OrderID = so.OrderID
			INNER JOIN Sales.Customers c 
				ON o.CustomerID = c.CustomerID
GO



USE [WideWorldImportersDW]
GO

/****** Object:  UserDefinedFunction [dbo].[udfSalesAnchor]    Script Date: 6/6/2020 6:49:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udfSalesAnchor] (@year int, @month int)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
	WITH myCTE AS 
	(
		SELECT 
			dw.[Stock Item Key], 
			dw.[Stock Item], 
			[Calendar Year], 
			[Calendar Month Number], 
			SUM(Quantity) AS Quantity
		FROM dbo.ViewPowerBISalesDW dw	
		GROUP BY dw.[Stock Item Key], dw.[Stock Item], [Calendar Year], [Calendar Month Number]
	)
	SELECT 
		myCTE.[Stock Item Key] AS StockItemKey, 
		myCTE.[Stock Item] AS StockItem, 
		myCTE.[Calendar Year] AS [Year], 
		myCTE.[Calendar Month Number] AS [Month], 
		myCTE.Quantity AS Quantity, 
		(myCTE.quantity - dbo.GetSumQuantityPerStockItemAnchored(@year, @month, myCTE.[Stock Item Key])) AS QtyAnchorDiff
	FROM myCTE
)
GO



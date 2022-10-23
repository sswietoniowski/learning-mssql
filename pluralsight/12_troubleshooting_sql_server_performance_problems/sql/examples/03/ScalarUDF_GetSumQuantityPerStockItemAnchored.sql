USE [WideWorldImportersDW]
GO

/****** Object:  UserDefinedFunction [dbo].[GetSumQuantityPerStockItemAnchored]    Script Date: 6/7/2020 2:20:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetSumQuantityPerStockItemAnchored](@yeardiff int, @month int, @stockitemid int) RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	RETURN (SELECT SUM(s.Quantity) FROM Fact.Sale s INNER JOIN Dimension.[Date] ON 
		s.[Invoice Date Key] = [Date].[Date]			
	WHERE [Date].[Calendar Year] = DATEPART(year, DATEADD(year, @yeardiff, GETDATE())) 
		AND [Date].[Calendar Month Number] = @month 
		AND s.[Stock Item Key] = @stockitemid		
	GROUP BY [Date].[Calendar Year], [Date].[Calendar Month Number])
END
GO



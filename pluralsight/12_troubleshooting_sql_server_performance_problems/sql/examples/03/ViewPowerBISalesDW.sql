USE [WideWorldImportersDW]
GO

/****** Object:  View [dbo].[ViewPowerBISalesDW]    Script Date: 6/7/2020 2:16:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[ViewPowerBISalesDW]
WITH SCHEMABINDING
AS
SELECT 
	[Date].[Date],
	[Date].[Calendar Year],
	[Date].[Calendar Month Number],
	dc.[Sales Territory], 
	dc.City,
	dc.[Latest Recorded Population],
	cust.Customer,
	emp.[Is Salesperson],
	st.[Stock Item],
	st.[Stock Item Key],
	st.Size,
	fs.[Tax Amount],
	fs.Quantity,
	fs.[Sale Key]
FROM Fact.Sale fs INNER JOIN Dimension.Customer cust ON
		fs.[Customer Key] = cust.[Customer Key]
	INNER JOIN Dimension.City dc ON
		fs.[City Key] = dc.[City Key]	
	INNER JOIN Dimension.Employee emp ON
		fs.[Salesperson Key] = emp.[Employee Key]
	INNER JOIN Dimension.[Date] ON
		fs.[Invoice Date Key] = [Date].[Date]
	INNER JOIN Dimension.[Stock Item] st ON
		fs.[Stock Item Key] = st.[Stock Item Key]
GO



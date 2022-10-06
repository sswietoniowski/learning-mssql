
-- Actual Execution Plans

-- Graphical Execution Plans
-- CTRL+M
SELECT *
FROM WideWorldImporters.Sales.Invoices
GO




-- Text Execution Plans
SET STATISTICS PROFILE ON
GO
SELECT *
FROM WideWorldImporters.Sales.Invoices
GO
SET STATISTICS PROFILE OFF
GO







-- XML Execution Plans
SET STATISTICS XML ON
GO
SELECT *
FROM WideWorldImporters.Sales.Invoices
GO
SET STATISTICS XML OFF
GO
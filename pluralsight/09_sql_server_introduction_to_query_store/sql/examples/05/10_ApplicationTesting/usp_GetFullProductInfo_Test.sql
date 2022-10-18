USE [TEST_WideWorldImporters];

SET NOCOUNT ON;

DECLARE @StockItemID INT;

WHILE 1=1
BEGIN

	SELECT @StockItemID = (
		SELECT TOP 1 [StockItemID]
		FROM [Sales].[OrderLines]
		ORDER BY NEWID());

	EXEC [Sales].[usp_GetFullProductInfo] @StockItemID;

END
GO
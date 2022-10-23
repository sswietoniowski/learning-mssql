USE [TEST_WideWorldImporters];

SET NOCOUNT ON;
SET ARITHABORT ON;

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;

WHILE 1=1
BEGIN

	SELECT @StartDate = (
		SELECT TOP 1 [TransactionOccurredWhen]
		FROM [Warehouse].[StockItemTransactions]
		ORDER BY NEWID());

	SET @EndDate = DATEADD(DAY, 30, @StartDate)

	EXEC [Warehouse].[usp_GetCustomerStockItemHistory] @StartDate, @EndDate;

END
GO
USE [WideWorldImporters];

SET NOCOUNT ON;
SET ARITHABORT ON;

DECLARE @CustomerID INT;

WHILE 1=1
BEGIN

	SELECT @CustomerID = (
		SELECT TOP 1 [CustomerID] 
		FROM [Sales].[CustomerTransactions]
		ORDER BY NEWID());

	EXEC [Sales].[usp_CustomerTransactionInfo] @CustomerID;

END
GO
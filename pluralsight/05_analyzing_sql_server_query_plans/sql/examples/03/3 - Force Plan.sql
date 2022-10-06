USE WideWorldImporters
GO

SELECT COUNT(AccountsPersonID) TotAccountsPersonID, AccountsPersonID
FROM Sales.Invoices
GROUP BY AccountsPersonID 
ORDER BY TotAccountsPersonID
GO

CREATE OR ALTER PROCEDURE usp_GetAccounts (@AccountPersonID INT)
AS 
BEGIN
	SELECT [CustomerID],[BillToCustomerID],[OrderID],
			[DeliveryMethodID],[ContactPersonID]
	FROM  Sales.Invoices
	WHERE AccountsPersonID = @AccountPersonID
	ORDER BY AccountsPersonID
END
GO

DBCC FREEPROCCACHE
GO

SET STATISTICS IO, TIME ON
GO
-- Small Account
EXEC usp_GetAccounts 3260
GO
-- Huge Account
EXEC usp_GetAccounts 1001
GO

DBCC FREEPROCCACHE
GO

SET STATISTICS IO, TIME ON
GO
-- Huge Account
EXEC usp_GetAccounts 1001
GO
-- Small Account
EXEC usp_GetAccounts 3260
GO


CREATE NONCLUSTERED INDEX [IX_Invoices_AccountsPersonID]
ON [Sales].[Invoices] ([AccountsPersonID])
GO

CREATE NONCLUSTERED INDEX [IX_Invoices_AccountsPersonID_incl]
ON [Sales].[Invoices] ([AccountsPersonID])
INCLUDE ([CustomerID],[BillToCustomerID],
[OrderID],[DeliveryMethodID],[ContactPersonID])
GO






DROP INDEX [IX_Invoices_AccountsPersonID] ON [Sales].[Invoices]
GO
DROP INDEX [IX_Invoices_AccountsPersonID_incl] ON [Sales].[Invoices]
GO
DROP PROCEDURE usp_GetAccounts
GO
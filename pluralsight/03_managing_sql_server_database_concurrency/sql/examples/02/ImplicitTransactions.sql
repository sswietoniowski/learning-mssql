USE BobsShoes;
GO

-- Check setting of implicit transactions
SELECT IIF(2 & @@OPTIONS = 2, 'ON', 'OFF') AS ImplicitTransactions;
SET IMPLICIT_TRANSACTIONS ON;

SELECT @@TRANCOUNT AS TranCount;

SELECT * FROM Orders.CityState;

SELECT @@TRANCOUNT AS TranCount;

COMMIT;

SELECT @@TRANCOUNT AS TranCount;

SET IMPLICIT_TRANSACTIONS OFF;
SELECT IIF(2 & @@OPTIONS = 2, 'ON', 'OFF') AS ImplicitTransactions;
GO

/*
  Create a simple ITVF to return the total sum of a
  customer's transaction amount.
*/
CREATE OR ALTER FUNCTION dbo.SaleTransactionAmount(@CustomerID INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN(
		SELECT SUM(TransactionAmount) AS TransactionAmount  FROM [Sales].[CustomerTransactions] WHERE CustomerID=@CustomerID
	);
GO


/*
  Clear the cache of all plans to make sure we don't get an
  old plan for this run.
*/
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;

/*
   Index Scan
*/
SELECT * FROM dbo.SaleTransactionAmount(401);


/*
  Index seek
*/
SELECT * FROM dbo.SaleTransactionAmount(976);


/*
  Now run them both in a row, seeing what plan gets cached
  and used for all executions
*/
DECLARE @Id INT = 401;
SELECT * FROM dbo.SaleTransactionAmount(@Id) STC;
GO
 
DECLARE @Id INT = 976
SELECT * FROM dbo.SaleTransactionAmount(@Id) STC;
GO



/*
  How do we fix it?

  The most common method is to force the plan to recompile.

*/
DECLARE @Id INT = 401;
SELECT * FROM dbo.SaleTransactionAmount(@Id) STC
OPTION (RECOMPILE);
GO
 
DECLARE @Id INT = 976
SELECT * FROM dbo.SaleTransactionAmount(@Id) STC
OPTION (RECOMPILE);
GO



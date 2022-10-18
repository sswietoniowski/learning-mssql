USE [WideWorldImporters]
GO

SET STATISTICS IO ON;
GO


/*
	Query with different input parameters
*/
SELECT 
	[CustomerID], 
	SUM([AmountExcludingTax])
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] = 1050
GROUP BY [CustomerID];
GO

SELECT 
	[CustomerID], 
	SUM([AmountExcludingTax])
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] = 401
GROUP BY [CustomerID];
GO


/*
	Check the distribution of data
*/
SELECT 
	[CustomerID], 
	COUNT([AmountExcludingTax])
FROM [Sales].[CustomerTransactions]
GROUP BY [CustomerID]
ORDER BY COUNT([AmountExcludingTax]) DESC;
GO


/*
	Put this into a stored procedure
*/
DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerTransactionInfo];
GO

CREATE PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	

	SELECT 
		[CustomerID], 
		SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
GO


/*
	Run it with non-unique value
*/
EXEC [Sales].[usp_CustomerTransactionInfo] 401;
GO


/*
	Same plan with other values
*/
EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 910;
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 814;
GO


/*
	Can run it with a recompile
*/
EXEC [Sales].[usp_CustomerTransactionInfo] 1050 WITH RECOMPILE;
GO


/*
	Retrieve it from cache and check input parameters
*/
SELECT
	[qs].[last_execution_time],
	[qs].[execution_count],
	[qs].[total_logical_reads]/[qs].[execution_count] [AvgLogicalReads],
	[qs].[min_logical_reads],
	[qs].[max_logical_reads],
	[t].[text],
	[p].[query_plan],
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats [qs]
CROSS APPLY sys.dm_exec_sql_text([qs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([qs].[plan_handle]) [p]
WHERE [t].[text] LIKE '%usp_CustomerTransactionInfo%';
GO

/*
	Remove from cache and re-run to get NL plan
*/
DBCC FREEPROCCACHE (
	0x0500050048F2E3498091805AA401000001000000000000000000000000000000000000000000000000000000);
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 910;
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 814;
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 401;
GO


/*
	Check cache and variability in plan now
*/
SELECT
	[qs].[last_execution_time],
	[qs].[execution_count],
	[qs].[total_logical_reads]/[qs].[execution_count] [AvgLogicalReads],
	[qs].[min_logical_reads],
	[qs].[max_logical_reads],
	[t].[text],
	[p].[query_plan],
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats [qs]
CROSS APPLY sys.dm_exec_sql_text([qs].sql_handle) [t]
CROSS APPLY sys.dm_exec_query_plan([qs].[plan_handle]) [p]
WHERE [t].[text] LIKE '%usp_CustomerTransactionInfo%';
GO
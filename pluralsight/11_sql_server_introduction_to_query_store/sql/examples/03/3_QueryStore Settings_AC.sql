USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE,
		/*	
			READ_WRITE = data collection
				(default)
			READ_ONLY = no data collection 
		*/
	QUERY_CAPTURE_MODE = ALL,
		/* 
			are ALL queries captured, 
			or only "relevant" ones? 
			ALL = every query executed 
				(default)
			AUTO = infrequent & insignificant
			NONE = nothing new added
		*/
	MAX_PLANS_PER_QUERY = 200);
		/*
			INT data type
		*/
GO

/*
	Remove everything from Query Store
*/
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE CLEAR;
GO

/*
	Run our stored procedure
*/
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 808;
GO

/*
	Verify what's in Query Store
*/
SELECT
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO


/*
	Set Query Store to READ-ONLY
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_ONLY);
GO


/*
	Run a different query
*/
USE [WideWorldImporters];
GO
SELECT *
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] >= 800;
GO



/*
	Check to see if it's been added
*/
SELECT
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO



/*
	Set Query Store back READ_WRITE
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE);
GO



/*
	Re-run and check again
*/
USE [WideWorldImporters];
GO
SELECT *
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] >= 800;
GO

SELECT
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO


/*
	Change QUERY_CAPTURE_MODE to NONE
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	QUERY_CAPTURE_MODE = NONE);
GO

/*
	Run a new query
*/
USE [WideWorldImporters];
GO
SELECT COUNT(*)
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] < 400;
GO

/*
	Is it added to Query Store?
*/
SELECT
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO

/*
	What if we run our stored procedure?
*/
EXEC [Sales].[usp_CustomerTransactionInfo] 1031;
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 708;
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 492;
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 623;
GO


SELECT
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qst].[query_sql_text],
	[rs].[count_executions],
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[runtime_stats_id],
	[rs].[runtime_stats_interval_id],
	[rsi].[start_time],
	[rsi].[end_time]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
	ON [rsi].[runtime_stats_interval_id] = [rs].[runtime_stats_interval_id]
ORDER BY [qsq].[query_id], [rs].[runtime_stats_id];
GO

/*
	Enable active collection again
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	QUERY_CAPTURE_MODE = ALL);
GO


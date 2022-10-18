/*
	Start with a clean copy of WWI
*/
USE [master];
GO
RESTORE DATABASE [WideWorldImporters] 
FROM  DISK = N'C:\Backups\WideWorldImportersEnlarged.bak' 
WITH  FILE = 1,  
MOVE N'WWI_Primary' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters.mdf',  
MOVE N'WWI_UserData' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters_UserData.ndf',  
MOVE N'WWI_Log' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters.ldf',  
MOVE N'WWI_InMemory_Data_1' 
	TO N'C:\Databases\WideWorldImporters\WideWorldImporters_InMemory_Data_1',  
NOUNLOAD, 
REPLACE, 
STATS = 5;
GO

/*
	Enable Query Store with settings we want
*/
USE [master];
GO

ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE = ON;
GO

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE, 
	CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), 
	DATA_FLUSH_INTERVAL_SECONDS = 60,  
	INTERVAL_LENGTH_MINUTES = 5, 
	MAX_STORAGE_SIZE_MB = 100, 
	QUERY_CAPTURE_MODE = ALL, 
	SIZE_BASED_CLEANUP_MODE = AUTO, 
	MAX_PLANS_PER_QUERY = 200)
GO

/*
	Clear out any old data, just in case
*/
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE CLEAR;
GO


/*
	Create procedures for testing
*/
USE [WideWorldImporters];
GO

DROP PROCEDURE IF EXISTS [Sales].[usp_GetFullProductInfo];
GO

CREATE PROCEDURE [Sales].[usp_GetFullProductInfo]
	@StockItemID INT
AS	

	SELECT 
		[o].[CustomerID], 
		[o].[OrderDate], 
		[ol].[StockItemID], 
		[ol].[Quantity],
		[ol].[UnitPrice]
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	ORDER BY [o].[OrderDate] DESC;

	SELECT
		[o].[CustomerID], 
		SUM([ol].[Quantity]*[ol].[UnitPrice])
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	GROUP BY [o].[CustomerID]
	ORDER BY [o].[CustomerID] ASC;
GO


DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerTransactionInfo];
GO


CREATE PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	

	SELECT [CustomerID], SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
GO


DROP PROCEDURE IF EXISTS [Application].[usp_GetPersonInfo];
GO

CREATE PROCEDURE [Application].[usp_GetPersonInfo] (@PersonID INT)
AS

	SELECT 
		[p].[FullName], 
		[p].[EmailAddress], 
		[c].[FormalName]
	FROM [Application].[People] [p]
	LEFT OUTER JOIN [Application].[Countries] [c] 
		ON [p].[PersonID] = [c].[LastEditedBy]
	WHERE [p].[PersonID] = @PersonID;
GO

/*
	Run queries outside of SSMS
*/

/*
	Copy code to another window to run
*/
USE [WideWorldImporters];

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


/*
	Create NCIs to support queries
*/
USE [WideWorldImporters];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_PS] 
	ON [Sales].[OrderLines] ([Description])
	INCLUDE ([OrderID],[StockItemID], [UnitPrice])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_Orders_PS] 
	ON [Sales].[Orders] ([OrderID])
	INCLUDE ([CustomerID], [SalespersonPersonID])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_InvoiceLines_PS] 
	ON [Sales].[InvoiceLines] ([Description])
	INCLUDE ([InvoiceLineID], [InvoiceID], [UnitPrice])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_Invoices_PS] 
	ON [Sales].[Invoices] ([InvoiceID])
	INCLUDE ([CustomerID], [SalespersonPersonID])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_PurchaseOrderLines_PS]
	ON [Purchasing].[PurchaseOrderLines] ([Description])
	INCLUDE ([PurchaseOrderID], [PurchaseOrderLineID], [LastEditedWhen])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_PurchaseOrders_PS]
	ON [Purchasing].[PurchaseOrders] ([PurchaseOrderID])
	INCLUDE ([OrderDate], [ExpectedDeliveryDate])
ON [USERDATA];
GO

CREATE NONCLUSTERED INDEX [NCI_OrderLines_StockItemID]
	ON [Sales].[OrderLines] ([StockItemID])
	INCLUDE ([OrderID],[Quantity],[UnitPrice])
ON [USERDATA];
GO


/*
	Free procedure cache so new indexes get used
	*Not for production use
*/
DBCC FREEPROCCACHE;
GO


/*
	Check resource use through the UI
*/

/*
	Find top resource consumers with TSQL
	Longest execution times in the last hour
*/
SELECT 
	TOP 10 [rs].[avg_duration], 
    [qst].[query_text_id],
	[qsq].[query_id],  
	[qst].[query_sql_text], 
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsp].[plan_id], 
	GETUTCDATE() AS CurrentUTCTime,   
    [rs].[last_execution_time],
	(DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
	[rs].[last_execution_time])) AS [LocalLastExecutionTime]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id] 
WHERE [rs].[last_execution_time] > DATEADD(hour, -1, GETUTCDATE())  
ORDER BY [rs].[avg_duration] DESC;  
GO

/*
	Highest logical IO in last 8 hours
*/
SELECT 
	TOP 10 [rs].[avg_logical_io_reads], 
    [qst].[query_text_id],
	[qsq].[query_id],  
	[qst].[query_sql_text], 
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsp].[plan_id], 
	GETUTCDATE() AS CurrentUTCTime,   
    [rs].[last_execution_time],
	(DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
	[rs].[last_execution_time])) AS [LocalLastExecutionTime]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id] 
WHERE [rs].[last_execution_time] > DATEADD(HOUR, -8, GETUTCDATE())  
ORDER BY [rs].[avg_logical_io_reads] DESC; 
GO

/*
	Most executions...make sure you understand
	the intervals first!
	*remember that plan_id, execution_type, and
	runtime_stats_interval_id identify a unique row
*/
SELECT
	[rs].[plan_id],
	[rs].[execution_type],
	[rs].[runtime_stats_interval_id],
	[rsi].[start_time],
	[rsi].[end_time],
	SUM([rs].[count_executions]) AS [ExecutionCount]
FROM [sys].[query_store_runtime_stats] [rs]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
	ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [rs].[execution_type] = 0
AND [rsi].[start_time] > DATEADD(HOUR, -1, GETUTCDATE())  
GROUP BY [rs].[plan_id], [rs].[execution_type], [rs].[runtime_stats_interval_id], 
	[rsi].[start_time],	[rsi].[end_time]
ORDER BY [rs].[plan_id], [rs].[execution_type], [rs].[runtime_stats_interval_id];
GO


/*
	Wrap this into something bigger
*/
SELECT 
	TOP 10 [qst].[query_text_id],
	[qsq].[query_id],  
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsp].[plan_id],
	[ExecCount].[ExecutionCount],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN ( 
	SELECT
		[rs].[plan_id],
		SUM([rs].[count_executions]) AS [ExecutionCount]
	FROM [sys].[query_store_runtime_stats] [rs]
	JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
	WHERE [rs].[execution_type] = 0
	AND [rsi].[start_time] > DATEADD(HOUR, -1, GETUTCDATE())  
	GROUP BY [rs].[plan_id]) ExecCount
		ON [qsp].[plan_id] = [ExecCount].[plan_id]
ORDER BY [ExecCount].[ExecutionCount] DESC;
GO


/*
	Why does the same SP show up multiple times?
*/
SELECT 
	TOP 10 [qst].[query_text_id],
	[qsq].[query_id],  
 	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsq].[context_settings_id],
	[qsp].[plan_id],
	[ExecCount].[ExecutionCount],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN ( 
	SELECT
		[rs].[plan_id],
		SUM([rs].[count_executions]) AS [ExecutionCount]
	FROM [sys].[query_store_runtime_stats] [rs]
	JOIN [sys].[query_store_runtime_stats_interval] [rsi]
		ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
	WHERE [rs].[execution_type] = 0
	AND [rsi].[start_time] > DATEADD(HOUR, -1, GETUTCDATE())  
	GROUP BY [rs].[plan_id]) ExecCount
		ON [qsp].[plan_id] = [ExecCount].[plan_id]
ORDER BY [ExecCount].[ExecutionCount] DESC;
GO


/*
	Find queries with different context settings
*/
SELECT 
    [qst].[query_text_id],
	[qsq].[query_id],  
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [ObjectName],
	[qsq].[context_settings_id],
	[cs].[set_options],
	[qsp].[plan_id],
	TRY_CONVERT(XML, [qsp].[query_plan]),
	[qst].[query_sql_text]	
FROM [sys].[query_store_query] [qsq]
JOIN [sys].[query_context_settings] [cs]
	ON [qsq].[context_settings_id] = [cs].[context_settings_id]
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN (
	SELECT [qsq].[query_text_id], COUNT([qsq].[context_settings_id]) [ContextCount]
	FROM [sys].[query_store_query] [qsq]
	GROUP BY [qsq].[query_text_id]
	HAVING COUNT([qsq].[context_settings_id]) > 1) MultContext
		ON [qsq].[query_text_id] = [MultContext].[query_text_id]
ORDER BY [qst].[query_text_id], [qsq].[context_settings_id];
GO
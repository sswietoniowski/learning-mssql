/*
	Restore database
	*you may need to change the backup
	and restore locations
*/
USE [master]
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
	Enable query store and clear anything that may be in there

*/
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE = ON;
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE CLEAR;
GO

/*
	Create stored procedures for testing
*/
USE [WideWorldImporters]
GO

CREATE PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	

	SELECT [CustomerID], SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
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
	Run the query below to ensure the
	appropriate plan is in cache for demo
*/
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO


/*
	Start workload using these two files
	(external to SSMS):
	
	0_Prep__create_2_clients_usp_CustomerTransactionInfo.cmd
	0_Prep__create_2_clients_usp_GetPersonInfo.cmd
	
	Let workload run for 2-3 minutes
*/


/*
	Add some data to the table
	to simulate data being added during a
	normal work day
*/
USE [WideWorldImporters];
GO

INSERT INTO [Sales].[CustomerTransactions](
	[CustomerTransactionID], 
	[CustomerID],
	[TransactionTypeID],
	[InvoiceID],
	[PaymentMethodID],
	[TransactionDate], 
	[AmountExcludingTax],
	[TaxAmount],
	[TransactionAmount],
	[OutstandingBalance],
	[FinalizationDate],
	[LastEditedBy],
	[LastEditedWhen]
	)
SELECT 
	[CustomerTransactionID] + 385500, [CustomerID], 
	[TransactionTypeID], 1, [PaymentMethodID], 
	[TransactionDate], ([CustomerID] + 5) * 2, 
	(([CustomerID] + 5) * 2) * .05, 
	(([CustomerID] + 5) * 2) + ((([CustomerID] + 5) * 2) * .05), 
	[OutstandingBalance],[FinalizationDate],[LastEditedBy],
	[LastEditedWhen]
FROM [WideWorldImporters].[Sales].[CustomerTransactions] 
WHERE [AmountExcludingTax] = 0;


/*
	Query to run after loading data
	to force the "bad" plan for the demo
*/
DBCC FREEPROCCACHE;
GO
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 401;
GO


/*
	Query to confirm the plan in cache
	currently is the clustered index scan
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].execution_count, 
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[cp].[size_in_bytes]/1024 AS [PlanSizeKB], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats AS [qs]
CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
CROSS APPLY sys.dm_exec_sql_text([qs].[plan_handle]) AS [s]
INNER JOIN sys.dm_exec_cached_plans AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

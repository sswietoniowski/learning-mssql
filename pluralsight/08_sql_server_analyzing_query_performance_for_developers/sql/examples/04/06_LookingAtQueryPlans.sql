/*
	Enable actual execution plan
*/
USE [WideWorldImporters];
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO

/*
	Get the plan from cache
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT	[cp].[size_in_bytes],
		[cp].[cacheobjtype],
		[cp].[objtype],
		[cp].[plan_handle],
		[dest].[text], 
		[plan].[query_plan]
FROM [sys].[dm_exec_cached_plans] [cp]
CROSS APPLY [sys].[dm_exec_sql_text]([cp].[plan_handle]) [dest]
CROSS APPLY [sys].[dm_exec_query_plan]([cp].[plan_handle]) [plan]
WHERE [dest].[text] LIKE '%StateProvinces%'
OPTION(MAXDOP 1, RECOMPILE);

/*
	Open plan in separate window, then re-run first query
	Compare actual vs. estimated plan
*/


/*
	A second query...
	After running, look at plan in XML format
	Viewing the schema:
	http://schemas.microsoft.com/sqlserver/2004/07/showplan/
*/
SELECT
	[o].[OrderID],
	[ol].[OrderLineID],
	[o].[OrderDate],
	[o].[CustomerID],
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID];
GO



/*
	Run both together and look at cost
*/
USE [WideWorldImporters];
GO

SELECT 
	[CustomerID], 
	[TransactionAmount]
FROM [Sales].[CustomerTransactions]
WHERE [CustomerID] = 1056;
GO


SELECT
	[o].[OrderID],
	[ol].[OrderLineID],
	[o].[OrderDate],
	[o].[CustomerID],
	[ol].[Quantity],
	[ol].[UnitPrice]
FROM [Sales].[Orders] [o]
JOIN [Sales].[OrderLines] [ol]
	ON [o].[OrderID] = [ol].[OrderID];
GO


/*
	Clear buffer pool
	*not for production*
*/
DBCC DROPCLEANBUFFERS;
GO


/*
	Clustered Index Seek -> 1 Row
	What's the Estimated I/O cost?
	0.003125
*/
SELECT 
	[FullName], 
	[PhoneNumber]
FROM [Application].[People]
WHERE [PersonID] = 10;
GO


/*
	Find the Page ID so we can check the cache
	NOTE: fn_PhysLocFormatter is undocumented (thus unsupported)
*/

SELECT  
	[FullName], 
	[PhoneNumber],
	sys.fn_PhysLocFormatter(%%physloc%%)
FROM [Application].[People]
WHERE [PersonID] = 10;
GO


SELECT *
FROM sys.dm_os_buffer_descriptors
WHERE [page_id] = 30604 AND
	[database_id] = DB_ID();
GO


/*
	Since it's now cached, does cost change?
*/
SELECT 
	[FullName], 
	[PhoneNumber]
FROM [Application].[People]
WHERE [PersonID] = 10;
GO


/*
	Remove it from cache
*/
DBCC DROPCLEANBUFFERS;
GO


/*
	What about a Clustered Index Scan?
	What's the estimated I/O?
	0.0609
*/
SELECT
	[PersonID], 
	[PhoneNumber]
FROM [Application].[People];
GO


/*
	How many pages in the table?
*/
SELECT [in_row_data_page_count]
FROM [sys].[dm_db_partition_stats]
WHERE [object_id] = OBJECT_ID('Application.People') AND [index_id] = 1;
GO


/*
	Random I/O - 0.003125
	Sequential - 0.000740741
	Compare the output below to the estimated I/O value in the plan
*/
SELECT	0.003125 + (0.000740741 * (79-1));
GO


/*
	Estimated CPU Cost = 0.0609
	Estimated I/O Cost = 0.0013
	
	verify page and row count
*/
SELECT
	[PersonID], 
	[FullName],
	[PhoneNumber]
FROM [Application].[People]
OPTION (RECOMPILE);
GO


SELECT [in_row_data_page_count], [row_count]
FROM [sys].[dm_db_partition_stats]
WHERE [object_id] = OBJECT_ID('Application.People') AND [index_id] = 1;
GO


/*
	Now let's change the statistics 
	** Don't do this in production, please **
	Inflate page count, but not row count
*/
UPDATE STATISTICS [Application].[People]
WITH ROWCOUNT = 1117, PAGECOUNT = 79000;
GO


/*
	What's the new estimated I/O?
	58.5209
*/
SELECT
	[PersonID], 
	[FullName],
	[PhoneNumber]
FROM [Application].[People]
OPTION (RECOMPILE);
GO


/*
	Check the math...	
*/
SELECT	0.003125 +
		0.000740741 * (79000-1)
GO


/*
	Inflate row count, but not page count
*/
UPDATE STATISTICS [Application].[People]
WITH ROWCOUNT = 111700, PAGECOUNT = 79;
GO


/*
	What's the new estimated CPU cost?
	0.123
*/
SELECT
	[PersonID], 
	[FullName],
	[PhoneNumber]
FROM [Application].[People]
OPTION (RECOMPILE);
GO


/*
	Reset the numbers
*/
UPDATE STATISTICS [Application].[People]
WITH ROWCOUNT = 1117, PAGECOUNT = 79;
GO




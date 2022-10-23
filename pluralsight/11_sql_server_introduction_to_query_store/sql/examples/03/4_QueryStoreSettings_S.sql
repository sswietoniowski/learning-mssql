/*
	Make sure query store is enabled
	and clear anything that may be in there

*/
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE = ON;
GO
ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE CLEAR;
GO

/*
	Reminder, these are defaults for storage
	related settings
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),  
		/*	
			INT data type
			(default is 30)
		*/
	MAX_STORAGE_SIZE_MB = 100,
		/*	
			INT data type
			(default is 100MB)
			When the max is hit, 
			status changes to READ_ONLY
		*/
	SIZE_BASED_CLEANUP_MODE = AUTO);
		/* 
			AUTO = query store will go into 
				clean up mode as usage gets 
				close to MAX_STORAGE_SIZE_MB
				(default)
			OFF = clean up will not occur
		*/
GO

/*
	Check settings for Query Store
*/
USE [WideWorldImporters];
GO

SELECT 
	[actual_state_desc], 
	[readonly_reason], 
	[desired_state_desc], 
	[current_storage_size_mb], 
    [max_storage_size_mb], 
	[size_based_cleanup_mode_desc]
FROM [sys].[database_query_store_options];
GO

/*
	Set MAX_STORAGE_SIZE_MB ridiculously low
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	MAX_STORAGE_SIZE_MB = 3);
GO

/*
	Turn off size based cleanup
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	SIZE_BASED_CLEANUP_MODE = OFF);
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

/*
	Start workload using this file
	(external to SSMS):
	
	4_create_2_clients_GenerateDifferentQueryStrings.cmd
	
	Let workload run for 2-3 minutes
*/

/*
	Check to see what's in Query Store
*/
USE [WideWorldImporters];
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
	Check storage and status
*/
SELECT 
	[actual_state_desc], 
	[readonly_reason], 
	[desired_state_desc], 
	[current_storage_size_mb], 
    [max_storage_size_mb], 
	[size_based_cleanup_mode_desc]
FROM [sys].[database_query_store_options];
GO

/*
	Are new queries being added?
*/
SELECT COUNT(*)
FROM [sys].[query_store_query];
GO

/*
	Manually flush data to disk
*/
EXECUTE [sp_query_store_flush_db];
GO

/*
	find readonly_reason values:
	https://msdn.microsoft.com/en-us/library/dn818146.aspx

	65536 = Query Store has reached the size limit

*/

/*
	Adjust Query Store settings and
	then re-enable
	
*/
USE [master];
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (
	MAX_STORAGE_SIZE_MB = 500,
	SIZE_BASED_CLEANUP_MODE = AUTO);
GO


ALTER DATABASE [WideWorldImporters] 
	SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO


/*
	Check storage and status settings again
*/
USE [WideWorldImporters];
GO

SELECT 
	[actual_state_desc], 
	[readonly_reason], 
	[desired_state_desc], 
	[current_storage_size_mb], 
    [max_storage_size_mb], 
	[size_based_cleanup_mode_desc]
FROM [sys].[database_query_store_options];
GO

/*
	Confirm new queries are being added
*/
SELECT COUNT(*)
FROM [sys].[query_store_query];
GO

SELECT *
FROM [Application].[Cities];
GO

/*
	Clean up
*/
DROP INDEX [NCI_OrderLines_PS] 
	ON [Sales].[OrderLines];
GO 

DROP INDEX [NCI_Orders_PS] 
	ON [Sales].[Orders];
GO

DROP INDEX [NCI_InvoiceLines_PS] 
	ON [Sales].[InvoiceLines];
GO

DROP INDEX [NCI_Invoices_PS] 
	ON [Sales].[Invoices];
GO

DROP INDEX [NCI_PurchaseOrderLines_PS]
	ON [Purchasing].[PurchaseOrderLines];
GO

DROP INDEX [NCI_PurchaseOrders_PS]
	ON [Purchasing].[PurchaseOrders];
GO
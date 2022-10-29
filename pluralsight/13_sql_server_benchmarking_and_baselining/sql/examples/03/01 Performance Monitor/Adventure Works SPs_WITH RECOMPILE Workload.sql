/*
	Adventure Works SPs_WITH RECOMPILE Workload.sql
	This script requires four stored procedures to be first created
	in a copy of the AdventureWorks 2012 OLTP database.	
*/
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602
GO  
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-12-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-01 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-04-26 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-28 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-01-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-12-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-12-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-08-26 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-09-28 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-07-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-12-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-11-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-10-26 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-03-28 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-01-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-03-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-05-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-01 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-02-26 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-28 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-19 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-10-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-03-01 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-10 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-05-10 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-11-05 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-06-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-05-17 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-22 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-12-17 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-08-10 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-09-26 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 58950  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 61487 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-07-28 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17790  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 67100  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 18874 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-03-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 56165
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 84321
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 51112
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 23156
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 21111
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 78913
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 21354
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 12123
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 45457
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14180  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46602 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-12-11 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000' WITH RECOMPILE  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047 WITH RECOMPILE
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000' WITH RECOMPILE  
GO

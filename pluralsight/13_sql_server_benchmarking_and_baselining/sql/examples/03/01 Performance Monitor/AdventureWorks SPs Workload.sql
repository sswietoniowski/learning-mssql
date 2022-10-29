/*
	AdventureWorks SPs Workload.sql
	This script requires four stored procedures to be first created
	in a copy of the AdventureWorks 2012 OLTP database.	
*/
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2007-12-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-01 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-04-26 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-28 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-01-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2007-12-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-12-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-08-26 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-09-28 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-07-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2005-12-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-11-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-10-26 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-03-28 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-01-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-03-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2008-05-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-07-01 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-02-26 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-28 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_GetSalesOrderInfo 69442  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_FindWorkOrders '2005-07-19 00:00:00.000'  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_FindWorkOrders '2006-10-14 00:00:00.000'  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_ListPurchaseOrders  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_GetSalesOrderInfo 43659  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_GetPersonInfo 15476  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_GetPersonInfo 14180  
GO
USE AdventureWorks2012;
GO
------
exec dbo.usp_GetSalesOrderInfo 46602  
GO
USE AdventureWorks2012;
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-03-01 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-10 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
USE AdventureWorks2012;
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-05-10 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-11-05 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-06-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-05-17 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-02-22 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2005-12-17 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-08-10 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 57068  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2006-09-26 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 61487  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 63477  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2007-07-28 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 17787  
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
exec dbo.usp_GetPersonInfo 18874  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 69442  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-03-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000'  
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
exec dbo.usp_GetSalesOrderInfo 56189
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
exec dbo.usp_GetSalesOrderInfo 89973
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
exec dbo.usp_GetSalesOrderInfo 22134
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
exec dbo.usp_GetSalesOrderInfo 68874
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 325
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43311
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
exec dbo.usp_GetSalesOrderInfo 98643
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
exec dbo.usp_GetSalesOrderInfo 43104
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
exec dbo.usp_GetSalesOrderInfo 12354
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
exec dbo.usp_GetSalesOrderInfo 32465
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 32164
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
exec dbo.usp_GetSalesOrderInfo 98465
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 13425
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
exec dbo.usp_GetSalesOrderInfo 21121
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
exec dbo.usp_GetSalesOrderInfo 64324
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 13234
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
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 43659  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 15476  
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
exec dbo.usp_FindWorkOrders '2006-12-11 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 46607  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 19566  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1024  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 1027  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2005-07-15 00:00:00.000'  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 49604  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 53465  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetSalesOrderInfo 55197  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 11956  
GO
------
USE AdventureWorks2012;
GO
select * from Sales.CreditCard  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 332  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 12241  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 14226  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_ListPurchaseOrders  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_GetPersonInfo 16047  
GO
------
USE AdventureWorks2012;
GO
exec dbo.usp_FindWorkOrders '2008-04-14 00:00:00.000'  
GO

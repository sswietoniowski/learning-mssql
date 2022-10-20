/*
	This script creates four custom, user stored procedures 
	in a the AdventureWorks 2014 OLTP database.	
*/

USE [AdventureWorks2014];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID ( 'dbo.usp_FindWorkOrders', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_FindWorkOrders];
GO

CREATE PROCEDURE [dbo].[usp_FindWorkOrders] (@date DATETIME)
AS
	
	SELECT * 
	FROM [Production].[WorkOrder] wo
	LEFT OUTER JOIN [Production].[WorkOrderRouting] wor ON wo.WorkOrderID=wor.WorkOrderID
	WHERE wo.DueDate BETWEEN @date AND @date + 6;
GO



IF OBJECT_ID ( 'dbo.usp_GetPersonInfo', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_GetPersonInfo];
GO

CREATE PROCEDURE [dbo].[usp_GetPersonInfo] (@ID VARCHAR(10))
AS

	SELECT *
	FROM [Person].[Person] 
	JOIN [Person].[BusinessEntity] ON [Person].[Person].[BusinessEntityID] = [Person].[BusinessEntity].[BusinessEntityID]
	WHERE [Person].[Person].[BusinessEntityID] = @ID;


	SELECT [p].[FirstName], [p].[LastName], [a].[AddressLine1], [a].[City], [a].[PostalCode], [a].[ModifiedDate]
	FROM [Person].[Person] [p]
	JOIN [Person].[BusinessEntityAddress] [b] ON [p].[BusinessEntityID] = [b].[BusinessEntityID]
	JOIN [Person].[Address] [a] on [b].[AddressID] = [a].[AddressID]
GO



IF OBJECT_ID ( 'dbo.usp_GetSalesOrderInfo', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_GetSalesOrderInfo];
GO

CREATE PROCEDURE [dbo].[usp_GetSalesOrderInfo] (@ID INT)
AS

	SELECT * 
	FROM [Sales].[SalesOrderDetail] sod
	LEFT OUTER JOIN [Sales].[SalesOrderHeader] soh ON [sod].[SalesOrderID]=[soh].[SalesOrderID]
	WHERE [soh].[SalesOrderID] = @ID;
GO



IF OBJECT_ID ( 'dbo.usp_ListPurchaseOrders', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_ListPurchaseOrders];
GO

CREATE PROCEDURE [dbo].[usp_ListPurchaseOrders] 
AS

	SELECT * 
	FROM [Purchasing].[PurchaseOrderDetail] pod
	JOIN [Purchasing].[PurchaseOrderHeader] poh ON [pod].[PurchaseOrderID] = [poh].[PurchaseOrderID];
GO



IF OBJECT_ID ( 'Sales.usp_GetProductInfo', 'P' ) IS NOT NULL 
    DROP PROCEDURE [Sales].[usp_GetProductInfo];
GO

CREATE PROCEDURE [Sales].[usp_GetProductInfo]
	@ProductID INT
AS	

	SELECT [ProductID], [OrderQty]
	FROM [Sales].[SalesOrderDetail]
	WHERE [ProductID] = @ProductID
	ORDER BY [ProductID];
GO
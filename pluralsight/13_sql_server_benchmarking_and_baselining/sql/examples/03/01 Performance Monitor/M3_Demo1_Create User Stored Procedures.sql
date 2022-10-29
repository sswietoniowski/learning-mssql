USE [AdventureWorks2012]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_FindWorkOrders] (@date DATETIME)
AS

	
SELECT * 
FROM [Production].[WorkOrder] wo
LEFT OUTER JOIN [Production].[WorkOrderRouting] wor ON wo.WorkOrderID=wor.WorkOrderID
WHERE wo.DueDate BETWEEN @date AND @date + 6

GO





CREATE PROCEDURE [dbo].[usp_GetPersonInfo] (@ID VARCHAR(10))
AS

SELECT *
FROM [Person].[Person] 
JOIN [Person].[BusinessEntity] ON [Person].[Person].[BusinessEntityID] = [Person].[BusinessEntity].[BusinessEntityID]
WHERE [Person].[Person].[BusinessEntityID] = @ID

GO


CREATE PROCEDURE [dbo].[usp_GetSalesOrderInfo] (@ID INT)
AS

SELECT * 
FROM [Sales].[SalesOrderDetail] sod
LEFT OUTER JOIN [Sales].[SalesOrderHeader] soh ON [sod].[SalesOrderID]=[soh].[SalesOrderID]
WHERE [soh].[SalesOrderID] = @ID


GO


CREATE PROCEDURE [dbo].[usp_ListPurchaseOrders] 
AS

SELECT * 
FROM [Purchasing].[PurchaseOrderDetail] pod
JOIN [Purchasing].[PurchaseOrderHeader] poh ON [pod].[PurchaseOrderID] = [poh].[PurchaseOrderID]


GO





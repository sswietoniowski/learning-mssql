-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Add a new column and populate
ALTER TABLE [Sales].[SalesPerson] 
ADD [IsActive] bit NOT NULL
DEFAULT 1
WITH VALUES;
GO



-- Let's set one of our sales people to inactive
UPDATE Sales.SalesPerson SET IsActive = 0 
WHERE Id = 2;
GO



-- We don't want sales orders added with inative sales people
CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
	@SalesPerson int,
	@SalesAmount decimal(36,2),
	@SalesDate date,
	@SalesTerritory int,
	@OrderDescription nvarchar(max)
AS

BEGIN TRY
	
	SET NOCOUNT ON;

	SET XACT_ABORT ON;

	BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM Sales.SalesPerson WHERE IsActive = 0 and Id = @SalesPerson)
			BEGIN
				;THROW 65001, 'Please select an active sales person',1;
			END
			ELSE

		INSERT INTO Sales.SalesOrder (SalesPerson,SalesAmount,SalesDate,SalesTerritory,OrderDescription)
			VALUES (@SalesPerson,@SalesAmount,@SalesDate,@SalesTerritory,@OrderDescription);
	
	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;

		THROW;

END CATCH
GO



-- We are using an inactive sales person here
EXECUTE Sales.Insert_SalesOrder @SalesPerson = 2, @SalesAmount = 7500, @SalesDate = '6/1/2019', @SalesTerritory = 2, @OrderDescription = 'An older order Sally made';
GO



-- Did that sales order get added
SELECT * 
FROM Sales.SalesOrder;
GO
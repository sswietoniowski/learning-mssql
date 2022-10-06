-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Adding a new column
ALTER TABLE [Sales].[SalesPerson]
ADD [LastSalesDate] date NULL;
GO




-- We don't have any error handling
-- Create or alter is new in SQL 2016 SP1
CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
	@SalesPerson int,
	@SalesAmount decimal(36,2),
	@SalesDate date,
	@SalesTerritory int,
	@OrderDescription nvarchar(max)
AS

BEGIN

	SET NOCOUNT ON;

		INSERT INTO Sales.SalesOrder (SalesPerson,SalesAmount,SalesDate,SalesTerritory,OrderDescription)
			VALUES (@SalesPerson,@SalesAmount,@SalesDate,@SalesTerritory,@OrderDescription);

		UPDATE Sales.SalesPerson 
		SET LastSalesDate = GETDATE() WHERE Id = @SalesPerson;
	
END
GO




-- This will fail
EXECUTE Sales.Insert_SalesOrder @SalesPerson = 1, @SalesAmount = 7500, @SalesDate = '6/1/2019', @SalesTerritory = 88, @OrderDescription = 'First sale of the month. Ship ASAP!';
GO




-- Did the last sales date get updated
SELECT * 
FROM Sales.SalesPerson WHERE Id = 1;
GO




-- Let's clean up
UPDATE Sales.SalesPerson
SET LastSalesDate = NULL WHERE Id = 1;
GO




-- Here is a basic template with error handling
CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
	@SalesPerson int,
	@SalesAmount decimal(36,2),
	@SalesDate date,
	@SalesTerritory int,
	@OrderDescription nvarchar(max)
AS
BEGIN

	BEGIN TRY
	
		SET NOCOUNT ON;

		SET XACT_ABORT ON;

		BEGIN TRANSACTION;

			INSERT INTO Sales.SalesOrder (SalesPerson,SalesAmount,SalesDate,SalesTerritory,OrderDescription)
				VALUES (@SalesPerson,@SalesAmount,@SalesDate,@SalesTerritory,@OrderDescription);

			UPDATE Sales.SalesPerson 
			SET LastSalesDate = GETDATE() WHERE Id = @SalesPerson;
	
		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		IF (@@TRANCOUNT > 0)

			ROLLBACK TRANSACTION;

			THROW;

	END CATCH

END
GO




-- This will fail
EXECUTE Sales.Insert_SalesOrder @SalesPerson = 1, @SalesAmount = 7500, @SalesDate = '6/1/2019', @SalesTerritory = 88, @OrderDescription = 'First sale of the month. Ship ASAP!';
GO




-- The last sales date should be null
SELECT * 
FROM Sales.SalesPerson WHERE Id = 1;
GO
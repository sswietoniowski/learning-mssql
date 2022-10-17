-- Run this script to follow along with the demo
USE [ABCCompany];
GO




-- Adding our business key
ALTER TABLE [Sales].[SalesPerson] 
ADD [EmployeeNumber] nvarchar(10) NULL;




-- Setting the business key
UPDATE Sales.SalesPerson
SET EmployeeNumber = CASE
						WHEN Id = 1 THEN '0001'
						WHEN Id = 2 THEN '0002'
						WHEN Id = 3 THEN '0003'
						WHEN Id = 4 THEN '0004'
						WHEN Id = 5 THEN '0005'
						WHEN Id = 6 THEN '0006'
						WHEN Id = 7 THEN '0007'
						WHEN Id = 8 THEN '0008'
						WHEN Id = 9 THEN '0009'
						WHEN Id = 10 THEN '0010'
						WHEN Id = 11 THEN '0010'
						WHEN Id = 12 THEN '0012'
					 END;
GO




-- Procedure for setting an employee to inactive
CREATE OR ALTER PROCEDURE [Sales].[Update_SalesPerson_Inactive]
	@EmployeeNumber nvarchar(10)
AS
BEGIN

	BEGIN TRY
	
		SET NOCOUNT ON;

		SET XACT_ABORT ON;

		DECLARE @RowCount int;
		
		BEGIN TRANSACTION;

			UPDATE Sales.SalesPerson 
			SET IsActive = 0 WHERE EmployeeNumber = @EmployeeNumber;
	
			SET @RowCount = @@ROWCOUNT;
		
			IF (@RowCount > 1)
				BEGIN
					;THROW 65002,'Trying to update more than one row',1;
				END
		
		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		IF (@@TRANCOUNT > 0)

			ROLLBACK TRANSACTION;

			THROW;

	END CATCH

END
GO




-- Let's try setting a sales person to inactive
EXECUTE Sales.Update_SalesPerson_Inactive @EmployeeNumber = '0010';
GO
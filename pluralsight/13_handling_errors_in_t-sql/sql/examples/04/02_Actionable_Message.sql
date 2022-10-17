-- Run this script to follow along with the demo
USE [ABCCompany];
GO



SELECT * FROM
Sales.SalesPerson;
GO 



-- Add a check constraint on sales person start date
ALTER TABLE Sales.SalesPerson WITH CHECK
	ADD CONSTRAINT CK_SalesPerson_StartDate CHECK(StartDate <= GETDATE());
GO



-- Not a clear error message
BEGIN TRY

	BEGIN TRANSACTION;

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
		INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(13,'Tony','Stark',750,1,2,'Tony.Stark@ABCCorp.com','1/1/2020');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	
	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;
	
		THROW;

END CATCH
GO



-- This message will make more sense to the end user
BEGIN TRY
	
	DECLARE @CurrentDate date = GETDATE();

	BEGIN TRANSACTION;

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
		INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(13,'Tony','Stark',750,1,2,'Tony.Stark@ABCCorp.com','1/1/2020');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	-- Can't we just use the error number
	IF (ERROR_MESSAGE() = 'The INSERT statement conflicted with the CHECK constraint "CK_SalesPerson_StartDate". The conflict occurred in database "ABCCompany", table "Sales.SalesPerson", column ''StartDate''.' AND @@TRANCOUNT > 0)
		BEGIN		
			DECLARE @Message nvarchar(500);
			SET @Message = CONCAT('Please enter a start date before ',@CurrentDate);
			
			ROLLBACK TRANSACTION;
			
			THROW 65000,@Message,1;
		END

	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;
	
		THROW;

END CATCH
GO


-- Using XACT_ABORT to rollback
BEGIN TRY
	
	SET XACT_ABORT ON;
	
	DECLARE @CurrentDate date = GETDATE();

	BEGIN TRANSACTION;

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
		INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(13,'Tony','Stark',750,1,2,'Tony.Stark@ABCCorp.com','1/1/2020');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	IF (ERROR_MESSAGE() = 'The INSERT statement conflicted with the CHECK constraint "CK_SalesPerson_StartDate". The conflict occurred in database "ABCCompany", table "Sales.SalesPerson", column ''StartDate''.' AND @@TRANCOUNT > 0)
		BEGIN		
			DECLARE @Message nvarchar(500);
			SET @Message = CONCAT('Please enter a start date before ',@CurrentDate);

			THROW 65000,@Message,1;
		END

	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;
	
		THROW;

END CATCH
GO



-- Did our new sales person get inserted
SELECT * FROM
Sales.SalesPerson;
GO
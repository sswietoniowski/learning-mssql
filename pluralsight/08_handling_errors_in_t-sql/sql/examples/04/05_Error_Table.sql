-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Drop if the error log table already exists
DROP TABLE IF EXISTS [dbo].[ErrorLog];
GO



-- This will create our error log table
CREATE TABLE [dbo].[ErrorLog] (
	[Id] int identity(1,1) NOT NULL,
	[MessageId] int NOT NULL,
	[MessageText] nvarchar(2047) NULL,
	[SeverityLevel] int NOT NULL,
	[State] int NOT NULL,
	[LineNumber] int NOT NULL,
	[ProcedureName] nvarchar(2500) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_ErrorLogId] PRIMARY KEY CLUSTERED ([Id]));
GO



-- Logging a message to the error log table
BEGIN TRY

	SET XACT_ABORT ON;
	
	BEGIN TRANSACTION;

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
		INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	
	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;
	
		INSERT INTO dbo.ErrorLog (MessageId,MessageText,SeverityLevel,[State],LineNumber,
							 ProcedureName)
		VALUES (ERROR_NUMBER(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_LINE(),
				ERROR_PROCEDURE());
		
		THROW;

END CATCH
GO



-- Let's check the error log table now
SELECT * 
FROM dbo.ErrorLog;
GO



-- Procedure to log the error message
CREATE OR ALTER PROCEDURE [dbo].[Log_Error_Message] 
AS
BEGIN TRY

	SET NOCOUNT ON;

	SET XACT_ABORT ON;

	BEGIN TRANSACTION;

		INSERT INTO dbo.ErrorLog (MessageId,MessageText,SeverityLevel,[State],LineNumber,
								 ProcedureName)
			VALUES (ERROR_NUMBER(),ERROR_MESSAGE(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_LINE(),
					ERROR_PROCEDURE());

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;
		
		THROW;

END CATCH
GO



-- Using the error log procedure
BEGIN TRY

	SET XACT_ABORT ON;
	
	BEGIN TRANSACTION;

		SET IDENTITY_INSERT Sales.Salesperson ON;
	
		INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
			VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

		SET IDENTITY_INSERT Sales.Salesperson OFF;

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	IF (@@TRANCOUNT > 0)
		
		ROLLBACK TRANSACTION;

		EXECUTE dbo.Log_Error_Message;

		THROW;

END CATCH
GO



-- Let's check the error log table again
SELECT * 
FROM dbo.ErrorLog;
GO



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

		EXECUTE dbo.Log_Error_Message;

		THROW;

END CATCH
GO



-- We are using an inactive sales person here
EXECUTE Sales.Insert_SalesOrder @SalesPerson = 2, @SalesAmount = 7500, @SalesDate = '6/1/2019', @SalesTerritory = 2, @OrderDescription = 'An older order Sally made';
GO



-- Let's check the error log table again
SELECT * 
FROM dbo.ErrorLog;
GO
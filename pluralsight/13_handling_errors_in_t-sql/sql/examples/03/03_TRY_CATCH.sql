-- Run this script to follow along with the demo
USE [ABCCompany];
GO


-- Let's check and see how many rows we have
SELECT *
FROM Sales.SalesPerson;
GO




-- This insert should succeed 
-- We should not enter the catch
BEGIN TRY 
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,1,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

END TRY

BEGIN CATCH

	PRINT 'Does this execute?';

END CATCH
GO




-- Let's remove so we can try again
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- The second insert will not work
-- Will the third row be inserted
BEGIN TRY 
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

END TRY

BEGIN CATCH

	PRINT 'Start Catch';

END CATCH
GO




-- Did either row get inserted
SELECT * 
FROM Sales.SalesPerson;
GO



-- Let's clean up
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- The second insert will not work
-- Is this the error we want to see
BEGIN TRY 

	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

END TRY

BEGIN CATCH

	RAISERROR('Something went really wrong',16,1);

END CATCH
GO



-- Let's clean up
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- This is more like it
BEGIN TRY 
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;
	
END TRY

BEGIN CATCH

	DECLARE @ErrorMessage nvarchar(250);
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorLine int;
	
	SELECT	@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()
			,@ErrorLine = ERROR_LINE();

	RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState,@ErrorLine);

END CATCH
GO
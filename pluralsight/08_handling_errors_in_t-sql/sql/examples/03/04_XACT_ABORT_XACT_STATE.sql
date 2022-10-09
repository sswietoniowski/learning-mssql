-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Let's remove these
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- Let's check and see how many rows we have
SELECT *
FROM Sales.SalesPerson;
GO



-- Using XACT_ABORT ON without an explicit transaction
-- Are any of the rows inserted
SET XACT_ABORT ON;
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;
GO




-- Which rows were inserted
SELECT * 
FROM Sales.SalesPerson;
GO




-- Let's remove so we can try again
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- Using XACT_ABORT ON with an explicit transaction
-- Will any rows be inserted
SET XACT_ABORT ON;

BEGIN TRANSACTION;
	
	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

COMMIT TRANSACTION;
GO




-- Did either row get inserted
SELECT * 
FROM Sales.SalesPerson;
GO




-- Let's clean up
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO



-- XACT_ABORT OFF & XACT_STATE
SET XACT_ABORT OFF;

BEGIN TRY

BEGIN TRANSACTION;
	
	SELECT XACT_STATE(); -- Should be 1

	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	SELECT XACT_STATE();

	IF (XACT_STATE() = -1)
		BEGIN
			PRINT 'Things are not looking good';
			ROLLBACK TRANSACTION;
		END

	IF (XACT_STATE() = 1)
		BEGIN
			PRINT 'At least something works';
			COMMIT TRANSACTION;
		END

END CATCH
GO




-- Did either row get inserted
SELECT * 
FROM Sales.SalesPerson;
GO




-- Let's clean up
DELETE FROM Sales.SalesPerson WHERE Id IN (13,14,15);
GO




-- XACT_ABORT ON & XACT_STATE
SET XACT_ABORT ON;

BEGIN TRY

BEGIN TRANSACTION;
	
	SELECT XACT_STATE(); -- Should be 1

	SET IDENTITY_INSERT Sales.Salesperson ON;
	
	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(13,'Bruce','Wayne',125,1,1,'Bruce.Wayne@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(14,'Drake','Mallard',300,1,99,'Drake.Mallard@ABCCorp.com','7/1/2019');

	INSERT INTO Sales.SalesPerson (Id,FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
		VALUES	(15,'Clark','Kent',300,1,2,'Clark.Kent@ABCCorp.com','7/1/2019');

	SET IDENTITY_INSERT Sales.Salesperson OFF;

COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	
	SELECT XACT_STATE();
	
	IF (XACT_STATE() = -1)
		BEGIN
			PRINT 'Things are not looking good';
			ROLLBACK TRANSACTION;
		END

	IF (XACT_STATE() = 1)
		BEGIN
			PRINT 'At least something works';
			COMMIT TRANSACTION;
		END

END CATCH
GO




-- Did either row get inserted
SELECT * 
FROM Sales.SalesPerson;
GO
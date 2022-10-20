-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Examine SalesPerson table 10 rows
SELECT * 
FROM Sales.SalesPerson;
GO


-- Autocommit - default mode of SQL Server
INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Susan','Jobes',300,1,2,'Susan.Jobes@ABCCorp.com','6/5/2019');

INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Harry','Martin',300,1,2,'Harry.Martin@ABCCorp.com','6/5/2019');

INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Karen','Wright',300,1,4,'Karen.Wright@ABCCorp.com','6/5/2019');
GO





-- Will any value be inserted
INSERT INTO Sales.SalesPerson (FirstName,LastName,SalaryHr,ManagerId,LevelId,Email,StartDate) 
	VALUES	('Susan','Jobes',300,1,2,'Susan.Jobes@ABCCorp.com','6/5/2019')
			,('Harry','Martin',300,1,2,'Harry.Martin@ABCCorp.com','6/5/2019')
			,('Karen','Wright',300,1,4,'Karen.Wright@ABCCorp.com','6/5/2019');
GO



-- Our original count was 10
SELECT COUNT(1) 
FROM Sales.SalesPerson;
GO



-- Implicit transaction
SET IMPLICIT_TRANSACTIONS ON;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Staff');

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Director');
GO


-- Check our open transactions
-- Method 1
DBCC OPENTRAN;
GO

-- Method 2
SELECT	s.session_id
		,s.open_transaction_count
FROM [sys].[dm_exec_sessions] s
ORDER BY last_request_start_time DESC;
GO

-- Session options 2 indicates implicit transactions
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2005/ms176031(v=sql.90)
SELECT @@OPTIONS & 2;
GO


ROLLBACK TRANSACTION;
GO

SET IMPLICIT_TRANSACTIONS OFF;
GO



-- Explicit transaction
BEGIN TRANSACTION;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Staff');

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Sr Director');

COMMIT TRANSACTION;
GO


-- Can we rollback DDL statements
BEGIN TRANSACTION;

	ALTER TABLE Sales.SalesPersonLevel ADD isActive bit NOT NULL DEFAULT 1;

	TRUNCATE TABLE Sales.SalesOrder;

ROLLBACK TRANSACTION;
GO


-- let's check!
SELECT * 
FROM Sales.SalesPersonLevel;
GO

SELECT *
FROM Sales.SalesOrder;
GO
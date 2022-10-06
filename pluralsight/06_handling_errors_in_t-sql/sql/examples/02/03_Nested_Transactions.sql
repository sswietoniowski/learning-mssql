-- Run this script to follow along with the demo
USE [ABCCompany];
GO


-- Check our current transaction count
SELECT @@TRANCOUNT;
GO

-- Currently 7 rows
SELECT * 
FROM Sales.SalesPersonLevel;
GO


-- Let's check out how @@TRANCOUNT works
BEGIN TRANSACTION;

	UPDATE Sales.SalesOrder SET OrderDescription = NULL;

ROLLBACK TRANSACTION;
GO



-- Now let's nest a transaction
BEGIN TRANSACTION Level_1;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES	('Vice President');

BEGIN TRANSACTION Level_2;

	INSERT INTO Sales.SalesPersonLevel (LevelName)
		VALUES ('CIO');

BEGIN TRANSACTION Level_3;

	INSERT INTO sales.SalesPersonLevel (LevelName)
		VALUES ('Intern');

GO



-- Check our current transaction count
SELECT @@TRANCOUNT;
GO



-- Will this work
ROLLBACK TRANSACTION Level_3;
GO



-- I only want to commit the level 2
COMMIT TRANSACTION Level_2;
GO



-- Do I have the intern
SELECT * 
FROM Sales.SalesPersonLevel;
GO



-- A rollback must be applied to the outermost
ROLLBACK TRANSACTION Level_1;
GO



-- Microsoft article on nested transactions
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms189336(v=sql.105)
-- Paul Randal
-- https://www.sqlskills.com/blogs/paul/a-sql-server-dba-myth-a-day-2630-nested-transactions-are-real/
-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Using save points
BEGIN TRANSACTION;

	SAVE TRANSACTION Level_1;

		INSERT INTO Sales.SalesPersonLevel (LevelName)
			VALUES	('Vice President');

	SAVE TRANSACTION Level_2;

		INSERT INTO Sales.SalesPersonLevel (LevelName)
			VALUES ('CIO');

	SAVE TRANSACTION Level_3;

		INSERT INTO sales.SalesPersonLevel (LevelName)
			VALUES ('Intern');

	SAVE TRANSACTION Level_4;
GO


-- Let's check our transaction count
SELECT @@TRANCOUNT;
GO


-- now we can remove the intern
ROLLBACK TRANSACTION Level_3;
GO


-- Only commit up to save point 3
COMMIT TRANSACTION Level_3;
GO


-- Let's check the transaction count now
SELECT @@TRANCOUNT;
GO



-- Check out level names
SELECT * 
FROM Sales.SalesPersonLevel;
GO




-- Microsoft article on save points
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/save-transaction-transact-sql?view=sql-server-2017
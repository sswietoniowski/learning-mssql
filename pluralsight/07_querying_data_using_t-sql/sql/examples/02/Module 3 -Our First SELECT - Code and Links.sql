-- Pluralsight Course -----------
-- Querying Data with T-SQL -----
-- Module 3 - Our First SELECT --
---------------------------------
-- Ami Levin 2019 ---------------
---------------------------------
-- PRINT THIS ONE AND HANG IN YOUR WORK SPACE
-- https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-type-precedence-transact-sql
---------------------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/data-types/constants-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/expressions-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/operators-transact-sql
-- https://docs.microsoft.com/en-us/sql/relational-databases/databases/database-identifiers
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/mathematical-functions-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql
-- https://docs.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support

SELECT 'X';
-- FROM Dual (Oracle)

SELECT X;
-- Error

SELECT 2 * 7, SQRT(2);

SELECT 2 * 7 AS Easy, SQRT(2) AS PythagorasConstant;

SELECT 7 / 2;

SELECT 7 / 2 * 1.000 AS DivideFirst, (7 / (2 * 1.00)) AS MultiplyFirst;

SELECT CAST(7 AS DECIMAL(5,2)) / 2;

SELECT '4' + 4 AS Foolish;

SELECT '4A' + 4 AS Foolisher;

SELECT '4' + '4';

SELECT	CAST('20190101' AS DATE) AS JanuaryFirst;

SELECT 	CAST('2019-21-01' AS DATE) AS January22;

SELECT	CAST('2019-01-21' AS DATE) AS RealJanuary22;

-- END

 


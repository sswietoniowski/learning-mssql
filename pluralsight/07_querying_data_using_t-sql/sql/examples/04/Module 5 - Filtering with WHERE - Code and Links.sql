------------------------------
-- Pluralsight Course --------
-- Querying Data with T-SQL --
-- Module 5 - WHERE ----------
------------------------------
-- Ami Levin 2019 ------------
------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/null-and-unknown-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/predicates
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/search-condition-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/like-transact-sql
-- Fabian Pascal's paper
-- http://www.dbdebunk.com/2013/07/the-final-null-in-coffin-relational.html

USE TSQLDemoDB;

SELECT	*
FROM	Customers
WHERE	Country = NULL;

SELECT	*
FROM	Customers
WHERE	Country IS NULL;

SELECT	*
FROM	Customers
WHERE	Country IS NOT NULL;

SELECT	*
FROM	Orders 
WHERE	OrderDate BETWEEN '20190101' AND '20190115';

SELECT	*
FROM	Customers
WHERE	Country BETWEEN 'A' AND 'Z';

SELECT	*
FROM	Items
WHERE	Item IN ('Turntable', 'Amplifier');

SELECT	*
FROM	Items
WHERE	Item NOT IN ('Turntable', 'Amplifier');

SELECT	*
FROM	Items
WHERE	Item IN ('Turntable', 'Amplifier', NULL);

SELECT	*
FROM	Items
WHERE	Item NOT IN ('Turntable', 'Amplifier', NULL);

SELECT	*
FROM	Items
WHERE	Item NOT IN (SELECT Item FROM OrderItems);

SELECT	*
FROM	Items 
WHERE	Item LIKE 'A%';

SELECT	*
FROM	Items 
WHERE	Item LIKE '%n%';

-- END
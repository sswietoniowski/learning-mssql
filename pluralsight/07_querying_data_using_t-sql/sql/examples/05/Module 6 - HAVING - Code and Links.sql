-- Pluralsight Course --------
-- Querying Data with T-SQL --
-- Module 6 - HAVING ---------
------------------------------
-- Ami Levin 2019 ------------
------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-having-transact-sql

USE TSQLDemoDB;

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
GROUP BY Country
HAVING COUNT(*) > 1;
 
SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
WHERE	COUNT(*) > 1
GROUP BY Country;

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
GROUP BY Country
HAVING	Country IS NOT NULL;

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
WHERE	Country IS NOT NULL
GROUP BY Country;

-- END
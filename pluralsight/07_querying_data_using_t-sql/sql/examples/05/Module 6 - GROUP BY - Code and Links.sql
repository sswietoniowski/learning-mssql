-- Pluralsight Course --------
-- Querying Data with T-SQL --
-- Module 6 - GROUP BY -------
------------------------------
-- Ami Levin 2019 ------------
------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/aggregate-functions-transact-sql

USE TSQLDemoDB;

SELECT	* 
FROM	Customers;

SELECT	* 
FROM	Customers
WHERE	Country IS NOT NULL;

SELECT	*
FROM	Customers
WHERE   Country IS NOT NULL
GROUP BY Country;

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
WHERE   Country IS NOT NULL
GROUP BY Country;

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
GROUP BY Country;

INSERT INTO Customers(Customer, Country)
VALUES ('Jane', NULL);

SELECT	Country, COUNT(*) AS NumberOfCustomers
FROM	Customers
GROUP BY Country;

-- END
-- Pluralsight Course ------------------
-- Querying Data with T-SQL ------------
-- Module 7 - NULLs and DISTINCT -------
----------------------------------------
-- Ami Levin 2019 ----------------------
----------------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-clause-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-examples-transact-sql

SELECT	Country 
FROM	Customers;

SELECT	ALL Country 
FROM	Customers;

SELECT	DISTINCT Country
FROM	Customers;

SELECT	Country 
FROM	Customers
GROUP BY Country;

SELECT	DISTINCT Country, Customer
FROM	Customers;

SELECT	DISTINCT Customer, ISNULL(Country, 'Country Unknown')
FROM	Customers;

SELECT	DISTINCT Customer, ISNULL(Country, 'Country Unknown') AS Country
FROM	Customers;

-- END
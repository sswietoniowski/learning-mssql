-- Pluralsight Course -------------
-- Querying Data with T-SQL -------
-- Module 4 - FROM single source --
-----------------------------------
-- Ami Levin 2019 -----------------
-----------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql
-- Why you shouldn't use SELECT * in production
-- https://www.youtube.com/watch?v=04fHJwYE9RE

USE TSQLDemoDB;

SELECT	*
FROM	Customers;

SELECT	'Pluralsight' AS BestTraining
FROM	Customers;

SELECT	*, 'Pluralsight' AS BestTraining
FROM	Customers;

SELECT	OrderID,
        OrderDate,
        Customer
FROM	Orders;

SELECT	OrderID + 0,
        OrderDate,
        Customer
FROM	Orders;

SELECT	OrderID + 0 AS OrderNumber,
        OrderDate,
        Customer
FROM	Orders;

SELECT	OrderID + 0 AS OrderNumber,
        OrderDate,
        Customer AS Client
FROM	Orders;

-- END
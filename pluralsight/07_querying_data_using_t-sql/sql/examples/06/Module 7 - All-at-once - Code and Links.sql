-- Pluralsight Course --------
-- Querying Data with T-SQL --
-- Module 7 - All-at-once ----
------------------------------
-- Ami Levin 2019 ------------
------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-clause-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-examples-transact-sql

USE TSQLDemoDB;

SELECT	OrderID, Item, Quantity, Price
FROM	OrderItems;

SELECT	OrderID, Item, Quantity * Price
FROM	OrderItems;

SELECT	OrderID, Item, (Quantity * Price) AS Amount
FROM	OrderItems;

SELECT	OrderID, Item, (Quantity * Price) AS Amount, Amount * 0.9 AS DiscuntedAmount 
FROM	OrderItems;


-- END
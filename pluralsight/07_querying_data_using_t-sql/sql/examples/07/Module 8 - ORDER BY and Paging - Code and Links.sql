-- Pluralsight Course --------------
-- Querying Data with T-SQL --------
-- Module 8 - ORDER BY and Paging --
------------------------------------
-- Ami Levin 2019 ------------------
------------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql

-- Order by 

SELECT	*
FROM	Orders 
ORDER BY OrderDate DESC;

SELECT	*
FROM	OrderItems
ORDER BY Item ASC;

-- Order by columns not in select
SELECT	OrderID, Item
FROM	OrderItems
ORDER BY Quantity;

-- Determinism and tie breakers
SELECT	*
FROM	OrderItems
ORDER BY OrderID;

SELECT	*
FROM	OrderItems
ORDER BY OrderID, Item;

-- TOP
-- Show top 3 items based on total number sold
SELECT	TOP (3) Item, SUM(quantity) AS NumberOfItemsSold 
FROM	OrderItems
GROUP BY Item
ORDER BY NumberOfItemsSold DESC;

-- Paging
SELECT	Item, SUM(quantity) AS NumberOfItemsSold 
FROM	OrderItems
GROUP BY Item
ORDER BY NumberOfItemsSold DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

SELECT	Item, SUM(quantity) AS NumberOfItemsSold 
FROM	OrderItems
GROUP BY Item
ORDER BY NumberOfItemsSold DESC
OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY;

-- END 
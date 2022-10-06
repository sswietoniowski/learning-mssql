-- Pluralsight Course -------------
-- Querying Data with T-SQL -------
-- Module 4 - FROM single source --
-----------------------------------
-- Ami Levin 2019 -----------------
-----------------------------------
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql

USE TSQLDemoDB;

SELECT	*
FROM	Orders;

SELECT	* 
FROM	Customers
		CROSS JOIN 
		Orders;

SELECT	* 
FROM	Customers AS C
		INNER JOIN 
		Orders AS O
		ON C.Customer = O.Customer;

SELECT	*
FROM	Customers AS C
		INNER JOIN 
		Orders AS O 
		ON 1=1;

SELECT	* 
FROM	Customers AS C
		LEFT OUTER JOIN 
		Orders AS O
		ON C.Customer = O.Customer;

-- END
-- Run this script to follow along with the demo
USE [ABCCompany];
GO



-- Can we perform a select
SELECT * 
FROM Sales.SalesOrder;
GO


-- How about on the record we are updating
SELECT *
FROM Sales.SalesOrder WHERE Id = 1;
GO



-- What about a different row
SELECT *
FROM Sales.SalesOrder WHERE Id = 2;
GO



-- Using NOLOCK
SELECT *
FROM Sales.SalesOrder WITH (NOLOCK) WHERE Id = 1;
GO


-- Change isolation level read uncommitted
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT *
FROM Sales.SalesOrder WHERE Id = 1;
GO


-- Let's set this back
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO
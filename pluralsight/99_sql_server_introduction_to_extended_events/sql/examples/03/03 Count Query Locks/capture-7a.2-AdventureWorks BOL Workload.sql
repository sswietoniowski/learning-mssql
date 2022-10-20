--http://msdn.microsoft.com/en-us/library/ms345405(SQL.90).aspx
USE AdventureWorks2012
GO
SELECT CustomerID, SalesOrderNumber, SubTotal
FROM Sales.SalesOrderHeader
WHERE ShipMethodID > 2
AND SubTotal > 500.00
AND Freight < 15.00
AND TerritoryID = 5;
GO

------

--http://msdn.microsoft.com/en-us/library/bb677202.aspx

USE AdventureWorks2012;
GO
DECLARE @CurrentEmployee hierarchyid
SELECT @CurrentEmployee = OrganizationNode 
FROM HumanResources.Employee
WHERE LoginID = 'adventure-works\david0'

SELECT OrganizationNode.ToString() AS Text_OrganizationNode, *
FROM HumanResources.Employee
WHERE OrganizationNode.GetAncestor(1) = @CurrentEmployee ;
GO

DECLARE @CurrentEmployee hierarchyid
SELECT @CurrentEmployee = OrganizationNode 
FROM HumanResources.Employee
WHERE LoginID = 'adventure-works\ken0'

SELECT OrganizationNode.ToString() AS Text_OrganizationNode, *
FROM HumanResources.Employee
WHERE OrganizationNode.GetAncestor(2) = @CurrentEmployee ;
GO

DECLARE @CurrentEmployee hierarchyid
SELECT @CurrentEmployee = OrganizationNode 
FROM HumanResources.Employee
WHERE LoginID = 'adventure-works\david0'

SELECT OrganizationNode.ToString() AS Text_OrganizationNode, *
FROM HumanResources.Employee
WHERE OrganizationNode.GetAncestor(0) = @CurrentEmployee ;
GO

DECLARE @CurrentEmployee hierarchyid ;
DECLARE @TargetEmployee hierarchyid ;
SELECT @CurrentEmployee = '/2/3/1.2/5/3/' ;
SELECT @TargetEmployee = @CurrentEmployee.GetAncestor(2) ;
SELECT @TargetEmployee.ToString(), @TargetEmployee ;
GO

------

-- http://msdn.microsoft.com/en-us/library/ms187731.aspx

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
A. Using SELECT to retrieve rows and columns 
The following example shows three code examples. This first code 
example returns all rows (no WHERE clause is specified) and all
columns (using the *) from the Product table in the 
AdventureWorks2012 database.
*/

USE AdventureWorks2012;
GO
SELECT *
FROM Production.Product
ORDER BY Name ASC;
-- Alternate way.
USE AdventureWorks2012;
GO
SELECT p.*
FROM Production.Product AS p
ORDER BY Name ASC;
GO

/*
This example returns all rows (no WHERE clause is specified), and 
only a subset of the columns (Name, ProductNumber, ListPrice) from 
the Product table in the AdventureWorks2012 database. Additionally, 
a column heading is added.
*/

USE AdventureWorks2012;
GO
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
ORDER BY Name ASC;
GO


/*
This example returns only the rows for Product that have a product 
line of R and that have days to manufacture that is less than 4.
*/

USE AdventureWorks2012;
GO
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
WHERE ProductLine = 'R' 
AND DaysToManufacture < 4
ORDER BY Name ASC;
GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
B. Using SELECT with column headings and calculations 
The following examples return all rows from the Product table. The 
first example returns total sales and the discounts for each product. 
In the second example, the total revenue is calculated for each 
product.
*/

--USE AdventureWorks2012;
--GO
--SELECT p.Name AS ProductName, 
--NonDiscountSales = (OrderQty * UnitPrice),
--Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
--FROM Production.Product AS p 
--INNER JOIN Sales.SalesOrderDetail AS sod
--ON p.ProductID = sod.ProductID 
--ORDER BY ProductName DESC;
--GO


/*
This is the query that calculates the revenue for each product in 
each sales order.
*/

--USE AdventureWorks2012;
--GO
--SELECT 'Total income is', ((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)), ' for ',
--p.Name AS ProductName 
--FROM Production.Product AS p 
--INNER JOIN Sales.SalesOrderDetail AS sod
--ON p.ProductID = sod.ProductID 
--ORDER BY ProductName ASC;
--GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
C. Using DISTINCT with SELECT 
The following example uses DISTINCT to prevent the retrieval 
of duplicate titles.
*/

USE AdventureWorks2012;
GO
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle;
GO


------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
T. Using the INDEX optimizer hint 
The following example shows two ways to use the INDEX 
optimizer hint. The first example shows how to force the 
optimizer to use a nonclustered index to retrieve rows from 
a table, and the second example forces a table scan by using 
an index of 0.
*/

USE AdventureWorks2012;
GO
SELECT pp.FirstName, pp.LastName, e.NationalIDNumber
FROM HumanResources.Employee AS e WITH (INDEX(AK_Employee_NationalIDNumber))
JOIN Person.Person AS pp on e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO

-- Force a table scan by using INDEX = 0.
USE AdventureWorks2012;
GO
SELECT pp.LastName, pp.FirstName, e.JobTitle
FROM HumanResources.Employee AS e WITH (INDEX = 0) JOIN Person.Person AS pp
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
U. Using OPTION and the GROUP hints 
The following example shows how the OPTION (GROUP) clause
is used with a GROUP BY clause.
*/

USE AdventureWorks2012;
GO
SELECT ProductID, OrderQty, SUM(LineTotal) AS Total
FROM Sales.SalesOrderDetail
WHERE UnitPrice < $5.00
GROUP BY ProductID, OrderQty
ORDER BY ProductID, OrderQty
OPTION (HASH GROUP, FAST 10);
GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
V. Using the UNION query hint 
The following example uses the MERGE UNION query hint.
*/

USE AdventureWorks2012;
GO
SELECT *
FROM HumanResources.Employee AS e1
UNION
SELECT *
FROM HumanResources.Employee AS e2
OPTION (MERGE UNION);
GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
W. Using a simple UNION 
In the following example, the result set includes the contents
of the ProductModelID and Name columns of both the ProductModel
and Gloves tables.
*/

USE AdventureWorks2012;
GO
IF OBJECT_ID ('dbo.Gloves', 'U') IS NOT NULL
DROP TABLE dbo.Gloves;
GO
-- Create Gloves table.
SELECT ProductModelID, Name
INTO dbo.Gloves
FROM Production.ProductModel
WHERE ProductModelID IN (3, 4);
GO

-- Here is the simple union.
USE AdventureWorks2012;
GO
SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves
ORDER BY Name;
GO

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
X. Using SELECT INTO with UNION 
In the following example, the INTO clause in the second SELECT
statement specifies that the table named ProductResults holds
the final result set of the union of the designated columns 
of the ProductModel and Gloves tables. Note that the Gloves 
table is created in the first SELECT statement.
*/

USE AdventureWorks2012;
GO
IF OBJECT_ID ('dbo.ProductResults', 'U') IS NOT NULL
DROP TABLE dbo.ProductResults;
GO
IF OBJECT_ID ('dbo.Gloves', 'U') IS NOT NULL
DROP TABLE dbo.Gloves;
GO
-- Create Gloves table.
SELECT ProductModelID, Name
INTO dbo.Gloves
FROM Production.ProductModel
WHERE ProductModelID IN (3, 4);
GO

USE AdventureWorks2012;
GO
SELECT ProductModelID, Name
INTO dbo.ProductResults
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves;
GO

SELECT * 
FROM dbo.ProductResults;

------

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
  Y. Using UNION of two SELECT statements with ORDER BY 
The order of certain parameters used with the UNION clause 
is important. The following example shows the incorrect and 
correct use of UNION in two SELECT statements in which a 
column is to be renamed in the output.
*/

USE AdventureWorks2012;
GO
IF OBJECT_ID ('dbo.Gloves', 'U') IS NOT NULL
DROP TABLE dbo.Gloves;
GO
-- Create Gloves table.
SELECT ProductModelID, Name
INTO dbo.Gloves
FROM Production.ProductModel
WHERE ProductModelID IN (3, 4);
GO

--/* INCORRECT */
--USE AdventureWorks2012;
--GO
--SELECT ProductModelID, Name
--FROM Production.ProductModel
--WHERE ProductModelID NOT IN (3, 4)
--ORDER BY Name
--UNION
--SELECT ProductModelID, Name
--FROM dbo.Gloves;
--GO

/* CORRECT */
USE AdventureWorks2012;
GO
SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves
ORDER BY Name;
GO


------


/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
Z. Using UNION of three SELECT statements to show the 
	effects of ALL and parentheses 
The following examples use UNION to combine the results 
of three tables that all have the same 5 rows of data. 
The first example uses UNION ALL to show the duplicated 
records, and returns all 15 rows. The second example uses 
UNION without ALL to eliminate the duplicate rows from the 
combined results of the three SELECT statements, and 
returns 5 rows. The third example uses ALL with the first 
UNION and parentheses enclose the second UNION that is not 
using ALL. The second UNION is processed first because it 
is in parentheses, and returns 5 rows because the ALL option 
is not used and the duplicates are removed. These 5 rows are 
combined with the results of the first SELECT by using the 
UNION ALL keywords. This does not remove the duplicates 
between the two sets of 5 rows. The final result has 10 rows.
*/

USE AdventureWorks2012;
GO
IF OBJECT_ID ('dbo.EmployeeOne', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeOne;
GO
IF OBJECT_ID ('dbo.EmployeeTwo', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeTwo;
GO
IF OBJECT_ID ('dbo.EmployeeThree', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeThree;
GO

SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeOne
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO
SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeTwo
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO
SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeThree
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO

-- Union ALL
SELECT LastName, FirstName, JobTitle
FROM dbo.EmployeeOne
UNION ALL
SELECT LastName, FirstName ,JobTitle
FROM dbo.EmployeeTwo
UNION ALL
SELECT LastName, FirstName,JobTitle 
FROM dbo.EmployeeThree;
GO

SELECT LastName, FirstName,JobTitle
FROM dbo.EmployeeOne
UNION 
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeTwo
UNION 
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeThree;
GO

SELECT LastName, FirstName,JobTitle 
FROM dbo.EmployeeOne
UNION ALL
(
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeTwo
UNION
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeThree
);
GO

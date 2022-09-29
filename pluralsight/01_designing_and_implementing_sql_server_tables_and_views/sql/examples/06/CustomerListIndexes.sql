USE BobsShoes;
GO 

-- Customer List view
CREATE OR ALTER VIEW Orders.CustomerList 
WITH SCHEMABINDING
AS
  SELECT
    cust.CustID               AS CustomerID,
    cust.CustName             AS Name, 
    sal.Salutation            AS Salutation,
    cust.CustStreet           AS Street, 
    city.CityStateCity        AS City, 
    city.CityStateProv        AS StateProv,
    city.CityStatePostalCode  AS PostalCode,
    city.CityStateCountry     AS Country
  FROM orders.Customers cust
    INNER JOIN Orders.CityState city
      ON cust.CityStateID = city.CityStateID
    INNER JOIN Orders.Salutations sal
      ON cust.SalutationID = sal.SalutationID;
GO

-- Create a Unique, clustered index on the view
DROP INDEX IF EXISTS UQ_CustomerList_CustomerID ON Orders.CustomerList;
CREATE UNIQUE CLUSTERED INDEX UQ_CustomerList_CustomerID
    ON Orders.CustomerList(CustomerID);
GO

-- Query the view
SELECT CustomerID, Name, Salutation, City
    FROM Orders.CustomerList 
    WHERE CustomerID = 1
    -- OPTION (EXPAND VIEWS);
GO

-- Create a non clustered index on the view
DROP INDEX IF EXISTS IX_CustomerList_Name_PostalCode ON Orders.CustomerList;
CREATE NONCLUSTERED INDEX IX_CustomerList_Name_PostalCode  
    ON Orders.CustomerList(Name, PostalCode);
GO

-- Query the view
SELECT Name, PostalCode
    FROM Orders.CustomerList
    -- OPTION (EXPAND VIEWS);
GO

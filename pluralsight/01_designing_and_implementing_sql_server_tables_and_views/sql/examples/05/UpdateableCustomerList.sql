CREATE OR ALTER VIEW Orders.CustomerList 
WITH SCHEMABINDING
AS
  SELECT 
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

-- Show current customers
SELECT * FROM Orders.Customers;

-- Update the customer table through the view
BEGIN TRAN
UPDATE Orders.CustomerList
SET name = 'Trillian Dent'
WHERE name = 'Trillian Astra';

-- Show the modified table
SELECT * FROM Orders.Customers;
ROLLBACK

-- Update name and salutation
UPDATE Orders.CustomerList
SET name = 'Trillian Dent', Salutation = 'Mrs.'
WHERE name = 'Trillian Astra';
GO

-- View WITH CHECK OPTION
CREATE OR ALTER VIEW Orders.OnlyTheAs
WITH SCHEMABINDING
AS
  SELECT c.CustName
  FROM Orders.Customers c
  WHERE c.CustName LIKE 'A%'
WITH CHECK OPTION;
GO

SELECT CustName FROM Orders.OnlyTheAs;

-- Update Arthur to Ford
UPDATE Orders.OnlyTheAs
SET CustName = 'Ford Prefect'
WHERE CustName = 'Arthur Dent';

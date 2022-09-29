CREATE OR ALTER VIEW Orders.CustomerList
AS
  SELECT 
    sal.Salutation,
    cust.CustName, 
    cust.CustStreet, 
    city.CityStateCity, 
    city.CityStateProv,
    city.CityStatePostalCode,
    city.CityStateCountry
  FROM orders.Customers cust
    INNER JOIN Orders.CityState city
      ON cust.CityStateID = city.CityStateID
    INNER JOIN Orders.Salutations sal
      ON cust.SalutationID = sal.SalutationID;
GO

SELECT 
  cl.Salutation,
  cl.CustName,
  cl.CustStreet,
  cl.CityStateCity,
  cl.CityStateProv,
  cl.CityStatePostalCode,
  cl.CityStateCountry

FROM Orders.CustomerList cl;
GO

-- alter the view to add column aliases
CREATE OR ALTER VIEW Orders.CustomerList 
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

SELECT 
  cl.Salutation,
  cl.Name,
  cl.Street,
  cl.City,
  cl.StateProv,
  cl.PostalCode,
  cl.Country

FROM Orders.CustomerList cl;
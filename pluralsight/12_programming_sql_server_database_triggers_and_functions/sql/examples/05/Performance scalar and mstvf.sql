/*
  SELECT from the Sales.Order table where OrderDate is in
  a specific range
*/
SELECT CustomerID, OrderDate, OrderID FROM Sales.Orders WHERE
	OrderDate >= '2015-01-01' AND OrderDate < '2015-02-01';
	
/*
  Now try the same thing with a scaler function
*/
SELECT CustomerID, OrderDate, OrderID FROM Sales.Orders WHERE
	MONTH(OrderDate) = 1 AND YEAR(OrderDate) = 2015;


/*
  And not look at the impact of a static row estimation
  on our MSTVF
*/
SELECT * FROM dbo.AverageCustomerSale(10,'2015-01-01','2015-06-01');


/*
  Select all customers and their sales values for a specified range

  Has the row estimate changed?
*/
SELECT C.CustomerID, ACS.* FROM Sales.Customers C
	CROSS APPLY (
		SELECT * FROM dbo.AverageCustomerSale(C.CustomerID, '2015-01-01','2015-06-01')	
	) ACS
	WHERE MinimumSale > 100
GO
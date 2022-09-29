CREATE OR ALTER View Orders.OrderSummary
WITH SCHEMABINDING 
AS
    SELECT 
        o.OrderID,
        o.OrderDate,
        IIF(o.OrderIsExpedited = 1, 'YES', 'NO') AS Expedited,
        c.CustName,
        SUM(i.Quantity) TotalQuantity

    FROM Orders.Orders o
    JOIN Orders.Customers c 
      ON o.CustID = c.CustID
    JOIN Orders.OrderItems i
      ON o.OrderID = i.OrderID
    GROUP BY o.OrderID, o.OrderDate, o.OrderIsExpedited, c.CustName;
GO

-- Change Trillian's order to expedited
UPDATE Orders.OrderSummary
SET Expedited = 1
WHERE OrderID = 2;
GO

-- Miniview just showing total items
CREATE OR ALTER VIEW Orders.TotalOrderItems
WITH SCHEMABINDING
AS
    SELECT 
        o.orderid, 
        o.OrderDate,
        SUM(i.Quantity) AS TotalItems

    FROM Orders.Orders o
    JOIN Orders.OrderItems i
      ON o.OrderID = i.OrderID
    GROUP BY o.OrderID, o.OrderDate;
GO

-- Change the order date of order 1
UPDATE Orders.TotalOrderItems
SET OrderDate = '20191001'
WHERE OrderId = 1;

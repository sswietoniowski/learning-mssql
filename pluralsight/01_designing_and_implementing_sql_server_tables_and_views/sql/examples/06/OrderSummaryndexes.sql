USE BobsShoes;
GO

-- Create the View
CREATE OR ALTER View Orders.OrderSummary
WITH SCHEMABINDING 
AS 
    SELECT 
        o.OrderID,
        o.OrderDate,
        IIF(o.OrderIsExpedited = 1, 'YES', 'NO') AS Expedited, -- Comment
        -- o.OrderIsExpedited,   -- Add
        c.CustName, 
        SUM(i.Quantity) TotalQuantity
        -- ,COUNT_BIG(*) AS cb      -- Add

    FROM Orders.Orders o
    JOIN Orders.Customers c 
      ON o.CustID = c.CustID
    JOIN Orders.OrderItems i
      ON o.OrderID = i.OrderID
    GROUP BY o.OrderID, o.OrderDate, o.OrderIsExpedited, c.CustName
GO

-- Create the first index
CREATE UNIQUE CLUSTERED INDEX UQ_OrderSummary_OrderID
  ON Orders.OrderSummary (OrderID);
GO

SELECT *
FROM Orders.OrderSummary;

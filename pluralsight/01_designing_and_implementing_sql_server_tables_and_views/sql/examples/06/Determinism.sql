USE BobsShoes;
GO

DROP VIEW IF EXISTS foo;
GO

-- Create a test view using computed columns
CREATE VIEW foo
WITH SCHEMABINDING
AS
SELECT 
    CONCAT(oi.OrderID, oi.OrderItemID) AS One, 
    oi.Discount * cast(.90 as [float]) AS Two
FROM Orders.OrderItems oi;
GO

-- Query to show if columns are deterministic and precise
SELECT 
    COLUMNPROPERTY(OBJECT_ID(N'foo'), 'One', 'IsDeterministic') AS OneIsDeterministic,
    COLUMNPROPERTY(OBJECT_ID(N'foo'), 'One', 'IsPrecise') AS OneIsPrecise,
    COLUMNPROPERTY(OBJECT_ID(N'foo'), 'Two', 'IsDeterministic') AS TwoIsDeterministic,
    COLUMNPROPERTY(OBJECT_ID(N'foo'), 'Two', 'IsPrecise') AS TwoIsPrecise;

-- Try to index the view
DROP INDEX IF EXISTS ix_foo ON foo;
CREATE UNIQUE CLUSTERED INDEX ix_foo ON foo(One, Two);

DROP VIEW IF EXISTS foo;

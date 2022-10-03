USE BobsShoes;
GO

DECLARE @Context varbinary(10) = CAST('Trillian' as varbinary);
SET CONTEXT_INFO @Context;
SET TRAN ISOLATION LEVEL REPEATABLE READ;
SET LOCK_TIMEOUT -1;

BEGIN TRAN;
    SELECT * FROM Orders.Orders
    -- UPDATE Orders.Orders SET OrderIsExpedited = 1
    WHERE OrderID = 1;
ROLLBACK;

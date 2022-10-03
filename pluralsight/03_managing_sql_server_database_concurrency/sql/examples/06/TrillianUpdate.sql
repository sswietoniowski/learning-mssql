USE BobsShoes;
GO

DECLARE @Context varbinary(10) = 
    CAST('Trillian' as varbinary);
SET CONTEXT_INFO @Context;
SET LOCK_TIMEOUT -1;

BEGIN TRAN;
    UPDATE Orders.Orders 
        SET OrderIsExpedited = 1
        WHERE OrderID = 1;

    UPDATE Orders.OrderItems 
        SET Quantity += 1
        WHERE OrderID = 1
ROLLBACK;

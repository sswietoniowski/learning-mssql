USE BobsShoes;
GO

DECLARE @Context varbinary(10) = CAST('Trillian' as varbinary);
SET CONTEXT_INFO @Context;
SET TRAN ISOLATION LEVEL REPEATABLE READ;
SET LOCK_TIMEOUT -1;

BEGIN TRAN;
    UPDATE Orders.Orders SET OrderIsExpedited = 1
    WHERE OrderID = 1;
    WAITFOR DELAY '01:00:00';
ROLLBACK;

USE BobsShoes;
GO

SET LOCK_TIMEOUT -1 -- Wait forever
BEGIN TRAN;
    UPDATE Orders.Orders 
    SET OrderRequestedDate = '30000101'
    WHERE OrderID = 1;
COMMIT;

-- Restore previous order requested date

BEGIN TRAN;
    UPDATE Orders.Orders 
    SET OrderRequestedDate = '20190601'
    WHERE OrderID = 1;
COMMIT;

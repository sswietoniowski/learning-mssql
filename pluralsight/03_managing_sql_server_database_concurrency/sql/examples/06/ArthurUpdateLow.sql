USE BobsShoes;
GO

SET LOCK_TIMEOUT -1;
SET DEADLOCK_PRIORITY LOW; 
    -- NORMAL, HIGH, -10 to 10, char or int variable

BEGIN TRAN;
    UPDATE Orders.OrderItems  
        SET Quantity += 1
        WHERE OrderID = 1

    WAITFOR DELAY '00:00:10';

    UPDATE Orders.Orders 
        SET OrderIsExpedited = 1
        WHERE OrderID = 1;
ROLLBACK;

USE BobsShoes;
GO

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;
    -- Before updating
    SELECT * FROM Orders.Orders;

    -- After the update
    SELECT * FROM Orders.Orders;
COMMIT;

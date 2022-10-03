USE BobsShoes;
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRAN;
    -- Before inserting
    SELECT * FROM Orders.Customers;

    -- After the insert but before committing
    SELECT * FROM Orders.Customers;
COMMIT;

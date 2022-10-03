USE BobsShoes;
GO

BEGIN TRAN;

UPDATE Orders.Orders 
SET OrderRequestedDate = '30000101'
WHERE OrderID = 1;

-- WAITFOR DELAY '00:00:04'
ROLLBACK;

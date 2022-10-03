USE BobsShoes;
GO

-- Explicit transaction

BEGIN TRANSACTION;

    SELECT @@TRANCOUNT AS TranCount_AfterBegin;
    SELECT * FROM Orders.CityState; 

COMMIT; -- (Or ROLLBACK)

SELECT @@TRANCOUNT AS TranCount_AfterCommit;

-- There is no END TRANSACTION statement
END TRANSACTION;
GO
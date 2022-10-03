USE BobsShoes;
GO

PRINT CONCAT('@@TRANCOUNT before transaction: ', @@TRANCOUNT);
--  The BEGIN TRAN statement will increment the  
--  transaction count by 1.  

BEGIN TRAN;
    PRINT CONCAT('@@TRANCOUNT in OUTER transaction: ', @@TRANCOUNT);

    BEGIN TRAN;
        PRINT CONCAT('@@TRANCOUNT in inner transaction: ', @@TRANCOUNT);

--  The COMMIT statement will decrement the transaction count by 1.  
    ROLLBACK;
    PRINT CONCAT('@@TRANCOUNT after inner COMMIT: ', @@TRANCOUNT);
COMMIT;

PRINT CONCAT('@@TRANCOUNT after OUTER COMMIT: ', @@TRANCOUNT);
GO

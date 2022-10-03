USE BobsShoes;
GO

-- Create a test table
DROP TABLE IF EXISTS TestSavePoints;
CREATE TABLE TestSavePoints
(
   ConstantName varchar(50),
   ConstantValue float
);
GO

-- Transaction with savepoints
BEGIN TRAN Hitchhikers;
    INSERT INTO TestSavePoints (ConstantName, ConstantValue)
        VALUES ('The Answer', 42);

    -- Set a savepoint
    SAVE TRAN TheAnswer;

    INSERT INTO TestSavePoints (ConstantName, ConstantValue)
          VALUES ('Phi', 1.618033988749895);

    -- Show current table contents
    SELECT 'Before first rollback' AS [When], * FROM TestSavePoints;

    -- Return to the savepoint, discarding the last insert.
    ROLLBACK TRAN TheAnswer;

    -- Show current table contents
    SELECT 'After first rollback' AS [When], * FROM TestSavePoints;

    INSERT INTO TestSavePoints (ConstantName, ConstantValue)
        VALUES ('pi', 3.14159265359);

    DECLARE @MyName sysname = N'After Ford'; 
    SAVE TRAN @MyName;

    INSERT INTO TestSavePoints (ConstantName, ConstantValue)
        VALUES ('e', 2.7182818284);

    -- Show current table contents
    SELECT 'Before second rollback' AS [When], * FROM TestSavePoints;
    
    ROLLBACK TRAN @MyName;

COMMIT TRAN Hitchhikers;

 -- Show current table contents
SELECT 'At end of transaction' AS [When], * FROM TestSavePoints;
GO

DROP TABLE IF EXISTS TestSavePoints;
GO

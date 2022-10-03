DECLARE 
    @Tries      int = 1,
    @MaxTries   int = 3,
    @Delay      datetime = '00:00:00.01';

-- Loop until success or retry count exhausted
WHILE (@Tries < =  @MaxTries)
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Orders.Orders         -- The code updating the database
                SET OrderIsExpedited = 1
                WHERE OrderID = 1;

            UPDATE Orders.OrderItems 
                SET Quantity += 1
                WHERE OrderID = 1
        COMMIT TRANSACTION               -- Update succeeded. Commit the transaction
        BREAK;                           -- Break out of the loop
    END TRY
 
    BEGIN CATCH
        IF ERROR_NUMBER() <> 1205 OR @Tries = @MaxTries
            THROW;                       -- Reraise the exception
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;        -- Rollback any active transaction

        SET @Tries += 1;  
        WAITFOR DELAY @Delay; 
    END CATCH
END

-- Update process for generating Key Lookup deadlocks
USE DeadlockDemo
GO
SET NOCOUNT ON
WHILE (1=1) 
BEGIN
    EXEC KeyLookupUpdate 4
END
GO
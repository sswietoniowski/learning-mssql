-- Select process for generating Key Lookup deadlocks
USE DeadlockDemo
GO
SET NOCOUNT ON
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
BEGIN 
	DROP TABLE #t1
END
CREATE TABLE #t1 (col2 int, col3 int)
GO
WHILE (1=1) 
BEGIN
    INSERT INTO #t1 EXEC KeyLookupSelect 4
    TRUNCATE TABLE #t1
END
GO

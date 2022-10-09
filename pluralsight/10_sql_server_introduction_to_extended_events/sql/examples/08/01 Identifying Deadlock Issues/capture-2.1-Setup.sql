USE [master]
GO

-- Setup key lookup deadlock demo database and table
IF DB_ID('DeadlockDemo') IS NOT NULL 
BEGIN
	ALTER DATABASE DeadlockDemo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DeadlockDemo;
END
GO
CREATE DATABASE DeadlockDemo;
GO
USE DeadlockDemo;
GO
SET NOCOUNT ON
GO

-- Create table with data layout conducive to Key Lookup operations
CREATE TABLE KeyLookupDeadlock 
(col1 int, 
 col2 int, 
 col3 int, 
 col4 char(100));
GO

DECLARE @int int;
SET @int = 1;

WHILE (@int <= 1000) 
BEGIN
    INSERT INTO KeyLookupDeadlock 
	VALUES (@int*2, @int*2, @int*2, @int*2);
    SET @int = @int + 1;
END
GO

-- Create a clustered index on the table
CREATE CLUSTERED INDEX cidx_KeyLookupDeadlock 
ON KeyLookupDeadlock (col1);
GO

-- Create a nonclustered index to cause the key lookup on col2 to occur
CREATE NONCLUSTERED INDEX idx_KeyLookupDeadlock_col2 
ON KeyLookupDeadlock (col2);
GO

-- Create a procedure for select operations
CREATE PROCEDURE KeyLookupSelect 
(@col2 int)
AS
BEGIN
    SELECT col2, col3 
	FROM KeyLookupDeadlock 
	WHERE col2 BETWEEN @col2 AND @col2+1;
END
GO

-- Create a procedure for update operations
CREATE PROCEDURE KeyLookupUpdate 
(@col2 int)
AS
BEGIN
    UPDATE KeyLookupDeadlock 
	SET col2 = col2+1 
	WHERE col1 = @col2;
    
	UPDATE KeyLookupDeadlock 
	SET col2 = col2-1 
	WHERE col1 = @col2;
END
GO

-- Create test table
DROP TABLE IF EXISTS foo;
CREATE TABLE foo (a int, b float);
INSERT INTO FOO (a, b) VALUES (42, 3.14159);
GO

-- Create a view on the test table
CREATE OR ALTER VIEW bar
WITH SCHEMABINDING
AS
    SELECT 
        a AS an_integer, 
        b as a_float 
    FROM dbo.foo;
GO

-- Query the view
SELECT an_integer, a_float FROM bar;

-- Remove the table
DROP TABLE foo;

-- Query the view!
SELECT an_integer, a_float FROM bar;

-- Recreate the table, swapping the columns
DROP TABLE IF EXISTS foo;
CREATE TABLE foo (a float, b int);
INSERT INTO FOO (a, b) VALUES (3.14159, 42);
GO

-- Query the view again 
SELECT an_integer, a_float FROM bar;

-- Alter the table
ALTER TABLE foo
    ALTER COLUMN a float;

-- Clean up
DROP VIEW IF EXISTS bar;
DROP TABLE IF EXISTS foo;
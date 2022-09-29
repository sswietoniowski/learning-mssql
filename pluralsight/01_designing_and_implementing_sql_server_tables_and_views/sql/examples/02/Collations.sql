-- Show the collation configured on the instance
SELECT SERVERPROPERTY('collation') AS DefaultInstanceCollationName;

-- Show the collation configured on the database
SELECT DATABASEPROPERTYEX(DB_NAME(), 'collation') AS DatabaseCollationName;

-- Show the collation for all the columns in the OrderTracking table
SELECT name AS ColumnName, collation_name AS ColumnCollation
    FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'Orders.OrderTracking'); 

-- Show the description for the collation
SELECT name, description 
    FROM sys.fn_helpcollations()
    WHERE name = N'SQL_Latin1_General_CP1_CI_AS'; 

-- Show SQL collations not containing 'LATIN'
SELECT name, description 
    FROM sys.fn_helpcollations()
    WHERE name LIKE N'SQL_%' AND name not like N'SQL_Latin%';     

-- Change the customer column to a Scandinavian collation.
ALTER TABLE Orders.OrderTracking
    ALTER COLUMN CustName nvarchar(200) 
        COLLATE  SQL_Scandinavian_CP850_CI_AS 
        NOT NULL;

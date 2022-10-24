# Programming SQL Server Database Stored Procedures

Introduction to programming stored procedures.

## 1. Creating Your First Stored Procedure

A stored procedure is a piece of SQL code that has a name (might have some parameters) and can be executed multiple times (write once, run many times). It is stored in the database and can be executed by any user who has access to it.

Advantages of stored procedures:

- less network traffic,
- easier permissions,
- more efficient code.

What a stored procedure can't do:

- ?

What a stored procedure shouldn't do:

- return lots of result sets,
- use cursors (we should prefer set-based logic).

Stored procedures are helping us to separate the business logic from the application logic, also thanks to the them we might not need to embed SQL code in our application.

Attached examples are for a sample contacts application.

## 2. Creating Stored Procedures and Using Parameters

To create a stored procedure, you use the `CREATE PROCEDURE` statement.

To create a stored procedure use the following syntax:

```sql
CREATE PROCEDURE procedure_name
AS
    -- SQL statements
GO
```

You can create a stored procedure that accepts parameters, to do that use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type
AS
    -- SQL statements
GO
```

We can have optional parameters, to do that use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type = default_value
AS
    -- SQL statements
GO
```

It is also possible to have output parameters, to do that use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type OUTPUT
AS
    -- SQL statements
GO
```

We can return a value from the stored procedure, to do that use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type
AS
    -- SQL statements
    SELECT ...
GO
```

To return an ID of the last inserted row (provided that the table has an identity column), use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type
AS
    -- SQL statements
    SELECT SCOPE_IDENTITY() -- don't use @@IDENTITY or IDENT_CURRENT('table_name')
GO
```

If we don't want to see many information about rows that were affected by the stored procedure, we can use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name data_type
AS
    -- SQL statements
    SET NOCOUNT ON
    SELECT ...
GO
```

To change a stored procedure, use the following syntax:

```sql
ALTER PROCEDURE procedure_name
    @parameter_name data_type
AS
    -- SQL statements
GO
```

To drop a stored procedure, use the following syntax:

```sql
DROP PROCEDURE procedure_name
GO
```

To execute a stored procedure, you use the `EXECUTE` statement in the following syntax:

```sql
EXECUTE procedure_name
```

To execute a stored procedure that accepts parameters, you use the following syntax:

```sql
EXECUTE procedure_name @parameter_name = value
```

If a stored procedure has output parameters, you can use the following syntax to get the values:

```sql
DECLARE @parameter_name data_type
EXECUTE procedure_name @parameter_name = @parameter_name OUTPUT
SELECT @parameter_name
```

You can use `DECLARE` to declare variables inside of a stored procedure.

To do so use the following syntax:

```sql
DECLARE @variable_name data_type
```

To change a value of a variable use the following syntax:

```sql
SET @variable_name = value
```

Inside a stored procedure you can use `IF` statement to check if a condition is true or false.

To do so use the following syntax:

```sql
IF condition
BEGIN
    -- SQL statements
END
```

You can use `ELSE` to execute a block of code if the condition is false.

To do so use the following syntax:

```sql
IF condition
BEGIN
    -- SQL statements
END
ELSE
BEGIN
    -- SQL statements
END
```

It is also possible to use `WHILE` loop to execute a block of code while a condition is true.

To do so use the following syntax:

```sql
WHILE condition
BEGIN
    -- SQL statements
END
```

While not recommended it is possible to use a cursors inside of a stored procedure.

To do so use the following syntax:

```sql
DECLARE cursor_name CURSOR FOR
    -- SQL statements

OPEN cursor_name

FETCH NEXT FROM cursor_name INTO @variable_name
WHILE @@FETCH_STATUS = 0
BEGIN
    -- SQL statements
    FETCH NEXT FROM cursor_name INTO @variable_name
END

CLOSE cursor_name

DEALLOCATE cursor_name
```

## 3. Table-valued Parameters and Refactoring

A stored procedure can use table-valued parameters. A table-valued parameter is a parameter that accepts a table as a value.

To create a stored procedure that uses a table-valued parameter use the following syntax:

```sql
CREATE PROCEDURE procedure_name
    @parameter_name table_type
AS
    -- SQL statements
GO
```

To create a table type we can use the following syntax:

```sql
CREATE TYPE type_name
AS TABLE
(
    column_name data_type
)
GO
```

We can also declare a table variable inside of the stored procedure.

To do so use the following syntax:

```sql
DECLARE @variable_name TABLE
(
    column_name data_type
)
```

To insert a row into a table variable use the following syntax:

```sql
INSERT INTO @variable_name
VALUES (value)
```

To drop a type use the following syntax:

```sql
DROP TYPE type_name
GO
```

To execute a stored procedure that uses a table-valued parameter use the following syntax:

```sql
EXECUTE procedure_name @parameter_name = (SELECT * FROM table_name)
```

## 4. Debugging and Troubleshooting Stored Procedures

To debug a stored procedure, you can use the `PRINT` statement, alternatively you can use the `RAISERROR` statement. Inside of SSMS you can debug a stored procedure by using the `F5` key.

To use the `PRINT` statement use the following syntax:

```sql
PRINT 'message'
```

To use the `RAISERROR` statement use the following syntax:

```sql
RAISERROR ('message', severity, state)
```

You can also use `TRY` and `CATCH` blocks to catch errors.

To do so use the following syntax:

```sql
BEGIN TRY
    -- SQL statements
END TRY
BEGIN CATCH
    -- SQL statements
END CATCH
```

Inside `CATCH` block you can use the `ERROR_NUMBER` function to get the error number, the `ERROR_SEVERITY` function to get the error severity, the `ERROR_STATE` function to get the error state, the `ERROR_PROCEDURE` function to get the error procedure, the `ERROR_LINE` function to get the error line, the `ERROR_MESSAGE` function to get the error message.

To use the `ERROR_NUMBER` function use the following syntax:

```sql
SELECT ERROR_NUMBER()
```

To use the `ERROR_SEVERITY` function use the following syntax:

```sql
SELECT ERROR_SEVERITY()
```

To use the `ERROR_STATE` function use the following syntax:

```sql
SELECT ERROR_STATE()
```

To use the `ERROR_PROCEDURE` function use the following syntax:

```sql
SELECT ERROR_PROCEDURE()
```

To use the `ERROR_LINE` function use the following syntax:

```sql
SELECT ERROR_LINE()
```

To use the `ERROR_MESSAGE` function use the following syntax:

```sql
SELECT ERROR_MESSAGE()
```

You can use transactions and defensive coding practices to prevent errors.

Stored procedure can return an error code to inform the caller about the error. Normally, a stored procedure returns 0 if it was successful, otherwise it returns a non-zero value.

To return an error code use the following syntax:

```sql
RETURN error_code
```

We can check the return value of a stored procedure by using the `@@ERROR` variable.

To do so use the following syntax:

```sql
DECLARE @error_code INT
EXECUTE @error_code = procedure_name
SELECT @error_code
```

or

```sql
EXECUTE procedure_name
SELECT @@ERROR
```

## Summary

Now you've got a basic understanding of how to create and use stored procedures.

More info about stored procedures can be found [here](https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver15).

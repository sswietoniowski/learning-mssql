# Querying Data Using T-SQL

Introduction to querying data using T-SQL.

## 1. What Is T-SQL?

> T-SQL - Transact Query Language, a dialect of the SQL language used by Microsoft SQL Server.

Useful on-line tools:

- [db<>fiddle](https://dbfiddle.uk/) - a tool to test SQL queries online,
- [SQL Fiddle](https://sqlfiddle.com/) - a tool to test SQL queries online.

## 2. Our First SELECT

To write basic `SELECT` statements, we need to know the following:

- `SELECT` - keyword to select data from a database,
- `FROM` - keyword to specify the table from which to select data,
- `WHERE` - keyword to filter the data,
- ... and more.

To write `SELECT` alone we can use the following syntax:

```sql
SELECT 1 AS ColumnName;
```

## 3. The FROM Clause

In practice we're going to use the `FROM` clause to specify the table from which we want to select data.

```sql
SELECT * FROM Person.Person;
```

or

```sql
SELECT p.Id, p.FirstName FROM Person.Person AS p;
```

## 4. Filtering with WHERE

To filter the data we can use the `WHERE` clause.

```sql
SELECT * FROM Person.Person WHERE FirstName = 'John';
```

## 5. Grouping Rows

We might want to group the rows in our result set. To do that we can use the `GROUP BY` clause.

```sql
SELECT FirstName, COUNT(*) AS Count FROM Person.Person GROUP BY FirstName;
```

## 6. Evaluating SELECT Expressions

It is important to know that the `SELECT` clause can contain expressions.

```sql
SELECT FirstName, LastName, FirstName + ' ' + LastName AS FullName FROM Person.Person;
```

It is also important to know how to handle null values:

```sql
SELECT FirstName, LastName, FirstName + ' ' + LastName AS FullName FROM Person.Person WHERE FirstName IS NOT NULL;
```

## 7. Ordering and Paging

Sometimes we want to order the rows in our result set. To do that we can use the `ORDER BY` clause.

```sql
SELECT * FROM Person.Person ORDER BY FirstName;
```

We can also add an `OFFSET` and `FETCH` clause to paginate the result set.

```sql
SELECT * FROM Person.Person ORDER BY FirstName OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;
```

## Summary

If you want to talk to the database you should learn how to "talk" to it, to do that please learn T-SQL :-).

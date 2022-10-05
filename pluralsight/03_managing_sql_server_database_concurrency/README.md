# Managing SQL Server Database Concurrency

Introduction to SQL Server Database Concurrency.

## 1. Introducing SQL Server Concurrency Control

Relational databases are used by many users at the same time, that leads to concurrency issues. This course will introduce you to the concepts of concurrency control and how SQL Server manages concurrency.

### Introducing Concurrency

> Concurrency is the ability of a system to handle multiple requests at the same time.

### Concurrency in Computing Systems

The following are some examples of concurrency in computing systems:

- a web server that can handle multiple requests at the same time,
- a database that can handle multiple users at the same time.

> Multitasking is the ability of a system to handle multiple requests at the same time.

Multitasking Models:

- pre-emptive multitasking,
- cooperative multitasking.

Pre-emptive multitasking is when the operating system can interrupt a process and switch to another process.

Cooperative multitasking is when the process has to voluntarily give up (yield) control of the processor.

**[SQLOS](https://blog.sqlauthority.com/2015/11/11/sql-server-what-is-sql-server-operating-system/)** uses a combination of cooperative (most threads run in this mode) and pre-emptive multitasking.

### Understanding ACID

In a RDBMS, the ACID properties are used to ensure that data is consistent and reliable (data integrity).

> `ACID` is an acronym for the four properties of a transaction in a relational database management system (RDBMS).

The acronym stands for Atomicity, Consistency, Isolation, and Durability:

- `Atomicity`: A transaction is an atomic unit of work. Either the entire transaction succeeds or it fails. If a transaction fails, the database is left in the same state as before the transaction started.

- `Consistency`: The database is always in a consistent state. This means that all data in the database is valid according to all defined rules, including constraints, cascades, triggers, and any combination thereof.

- `Isolation`: Transactions are isolated from each other. This means that the effects of any one transaction are not visible to any other transaction until that transaction has been completed.

- `Durability`: Once a transaction has been committed, it will remain so, even in the event of power loss, crashes, or errors.

### Getting the tools installed

More info about the tools used in this course can be found [here](https://git.io/fhA7L).

## 2. Understanding Transactions

Transactions are the basic unit of work in a database. This lesson will introduce you to the concepts of transactions and how they are used in SQL Server.

> UoW (Unit of Work) is a set of operations that must be performed as a single unit. A transaction is a UoW.

### Introducing Transactions

Transactions are used to ensure that data is consistent and reliable (data integrity).

### Understanding Roles and Responsibilities

We need to understand who starts a transaction and who commits it, also who should do what in case of an error.

There are two "players" involved:

- SQL Programmers - starting and ending transactions in accordance with the business rules as a logical unit of work,
- SQL Server Database Engine - locking (isolation), logging (durability), management (atomicity and consistency).

### Autocommit

> Autocommit is a mode in which every SQL statement is treated as a transaction and is committed immediately.

Autocommit is enabled by default in SQL Server.

To disable autocommit mode use the following command:

```sql
SET IMPLICIT_TRANSACTIONS ON
```

To enable it back use the following command:

```sql
SET IMPLICIT_TRANSACTIONS OFF
```

To check whether we're inside a transaction or not use the following command:

```sql
SELECT @@TRANCOUNT
```

If the result is 0, we're not inside a transaction.

You might got an impression that transactions can be nested, but that's not exactly true. In reality if you are performing a rollback, all the transactions will be rolled back. In case of a commit, only the innermost transaction will be "committed" but in reality you will have an active transaction.

To check SQL Server version in use, use the following command:

```sql
SELECT @@VERSION
```

### Explicit Transactions

To start explicit transaction (when you are in the autocommit mode) use the following command:

```sql
BEGIN TRANSACTION
```

To commit a transaction use the following command:

```sql
COMMIT TRANSACTION
```

To rollback a transaction use the following command:

```sql
ROLLBACK TRANSACTION
```

It is important to understand that rollback behavior can be changed by using the `SET XACT_ABORT` command.

To enable `SET XACT_ABORT` command use the following command:

```sql
SET XACT_ABORT ON
```

When `SET XACT_ABORT` is enabled, the transaction will be rolled back when an error occurs.

To disable `SET XACT_ABORT` command use the following command:

```sql
SET XACT_ABORT OFF
```

When `SET XACT_ABORT` is disabled, the transaction will not be rolled back when an error occurs.

### Implicit Transactions

If we decide to disable autocommit mode, we're dealing with implicit transactions.

To check if we're using implicit transactions use the following command:

```sql
SELECT IFF(2 & @@OPTIONS, 'ON', 'OFF') AS ImplicitTransactions
```

Implicit transactions are started when we execute a statement and are committed when we execute commit or rollback.

To commit a implicit transaction use the following command:

```sql
COMMIT
```

To rollback a implicit transaction use the following command:

```sql
ROLLBACK
```

This behavior of transactions is popular in the Oracle Database, but in case of Microsoft SQL Server, it's not recommended to use implicit transactions.

### Revisiting Autocommit and Explicit Transactions

There are two other types of transactions:

- batched-scoped - applicable to MARS (Multiple Active Result Sets) connections,
- distributed - applicable to distributed transactions.

We can name our transactions and add special marker to the transaction log (using `WITH MARK` option). It is also possible to add to our `COMMIT` or `ROLLBACK` command a name of the transaction we want to commit or rollback (but that is only for documentation). We can also add to `COMMIT` special option `WITH (DELAYED_DURABILITY = ON` to delay the durability of the transaction (at the risk of breaking D in ACID).

### Introducing Savepoints

Sometimes we need to rollback a transaction to a specific point. We can do that using savepoints.

To create a savepoint use the following command:

```sql
SAVE TRANSACTION SavepointName
```

To rollback to a savepoint use the following command:

```sql
ROLLBACK TRANSACTION SavepointName
```

## 3. Managing Basic Isolation Levels

When we're dealing with transactions, we need to understand how they are isolated from each other. This lesson will introduce you to the concepts of isolation levels and how they are used in SQL Server.

### Understanding Isolation Levels

There are four (five\*) isolation levels in SQL Server:

- Read Uncommitted,
- Read Committed,
- Repeatable Read,
- Serializable,
- Snapshot\*.

To determine the isolation level used by a session, use the following command:

```sql
SELECT
    CASE transaction_isolation_level
        WHEN 0 THEN 'Unspecified'
        WHEN 1 THEN 'Read Uncommitted'
        WHEN 2 THEN 'Read Committed'
        WHEN 3 THEN 'Repeatable Read'
        WHEN 4 THEN 'Serializable'
        WHEN 5 THEN 'Snapshot'
    END AS IsolationLevel
FROM
    sys.dm_exec_sessions
WHERE
    session_id = @@SPID
```

### Read Uncommitted

`Read Uncommitted` is the lowest isolation level. It allows dirty reads and non-repeatable reads.

> Dirty read is a read of a row that has been modified by another transaction but not yet committed.

To set this level of isolation use the following command:

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
```

Sometimes we need to read data that is not committed yet. In this case, we can add `WITH (NOLOCK)` to our `SELECT` statement.

It might seem as there are no locks involved in this isolation level, but that's not true. There are locks involved, but they are not blocking locks. SQL Server uses schema locks (Sch-S) to prevent other transactions from modifying the schema.

Sample code:

```sql
SELECT * FROM dbo.Customers WITH (NOLOCK)
```

To achieve the same result you could use `With (READUNCOMMITTED)`.

Sample code:

```sql
SELECT * FROM dbo.Customers WITH (READUNCOMMITTED)
```

### Read Committed

`Read Committed` is the default isolation level. It allows non-repeatable reads.

> Non-repeatable read is when we read the same data twice and get different results (don't see the same row twice).

To set this level of isolation use the following command:

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
```

### Repeatable Read

`Repeatable Read` is the next isolation level. It allows phantom reads.

> Phantom read is when we read the same data twice and get different results. It is similar to non-repeatable read (but in this case new rows from another session were added).

To set this level of isolation use the following command:

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
```

### Serializable

Serializable is the highest isolation level. It prevents dirty reads, non-repeatable reads, and phantom reads.

Using this level of isolation is very expensive, so it's not recommended to use it in production. In general, you should use `Read Committed` isolation level.

To set this level of isolation use the following command:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
```

## 4. Implementing Snapshot Isolation Levels

Previous four isolation levels can be called pessimistic isolation levels. They are pessimistic because they assume that other transactions will modify data. In this lesson, we will learn about optimistic isolation levels.

Snapshot isolation is a new isolation level introduced in SQL Server 2008. In this case we can read previous state of data while other transactions are modifying it. This isolation level is called optimistic because it assumes that other transactions will not modify data.

To use this isolation level we need to enable it first. To enable it use the following command:

```sql
ALTER DATABASE AdventureWorks2012
SET ALLOW_SNAPSHOT_ISOLATION ON
```

When snapshot isolation is used the SQL Server maintains versions of each row that is modified. The chance that a read operation will block other transactions is greatly reduced. SQL Server uses a copy-on-write mechanism when a row is modified or deleted. Tempdb is used to hold the version store.

To set this level of isolation use the following command:

```sql
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
```

To check if the snapshot isolation is enabled use the following command:

```sql
SELECT
    is_read_committed_snapshot_on,
    snapshot_isolation_state_desc
FROM
    sys.databases
WHERE
name = 'AdventureWorks2012'
```

By enabling snapshot isolation we can use `WITH (SNAPSHOT)` option in our `SELECT` statement.

We can also change the default isolation level to `SNAPSHOT` by using the following command:

```sql
ALTER DATABASE AdventureWorks2012
SET READ_COMMITTED_SNAPSHOT ON
```

There is still risk o an error if two update operations are performed on the same row at the same time.

We must understand that snapshot isolation is not a replacement for `READ COMMITTED` isolation level.It is a new isolation level that can be used in specific scenarios. It is also important to know the performance impact of using this isolation level, especially to the tempdb.

Tempdb space is used to store the snapshot of the data. If we have a lot of data, it will take a lot of space in tempdb. It is also important to know that the snapshot is not updated until the transaction is committed. This means that if we have a lot of data, it will take a lot of time to update the snapshot.

There are some DMVs that might be useful while working with snapshot isolation (see examples).

### Locking vs Row Versioning

Locking is a mechanism that prevents other transactions from modifying data. Locking is used in `READ UNCOMMITTED`, `READ COMMITTED`, and `REPEATABLE READ` isolation levels. These are ANSI SQL-92 compliant. They are better for long-running updates.

Row versioning is a mechanism that allows us to read previous state of data while other transactions are modifying it. Row versioning is used in `SNAPSHOT` isolation level. This isolation level is proprietary. Better for read-heavy operations. Extra load on tempdb.

## 5. Locking in the SQL Server Database Engine

In this lesson, we will learn about locking in SQL Server. We will learn about different types of locks and how they are used.

### Locking

I in ACID is related to locking.

> Locking is a mechanism that prevents other transactions from modifying same data.

### Blocking

> Blocking is a situation when a transaction is waiting for a lock to be released by another transaction. Blocking is a bad thing because it can cause performance issues.

To see whether we have some blocking we might use DMV or SPs. There are also special procedures that can be used to find blocking. They are `sp_who2` and `sp_whoisactive`.

Useful DMV to discover blocking is `sys.dm_tran_locks`.

More info about locking can be found [here](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-locking-and-row-versioning-guide?view=sql-server-ver15).

Adam Machanic create a very useful stored procedure `sp_whoisactive` that can be used to find blocking. It can be downloaded from [here](http://whoisactive.com/downloads/).

### Lock Granularity and Hierarchies

> Lock granularity is the level of data that is locked.

Locks can be acquired on different levels. Locks can be acquired on the database level, table level, page level, row level, and key level. It is automatic process. SQL Server decides which level of lock to acquire.
Smaller granularity reduces blocking but it can cause overhead because we would have to deal with many more locks, larger granularity means less concurrency. It is also important to know that locks are acquired in a hierarchy.

To perform an operation we might need many different locks that would be acquired in a hierarchy. For example, if we want to update a row, we would need to acquire a lock on the table, page, and row level. If we want to update a table, we would need to acquire a lock on the database and table level.

At the moment we've got 11 locking granularities. They are: RID, Key, Page, Extent, HoBT, Table, File, Application, Metadata, Allocation Unit, Database.

### Locking Modes

> Lock mode is a type of lock that is acquired.

We can have: Shared (S), Update (U), Exclusive (X), Intent (IS, IX, SIX, IU, SIU, UIX), Schema (Sch-M, Sch-S), Bulk Update (BU), Key-Range (RS, RU, RN, RX).

### Lock Compatibility

> Lock compatibility is a set of rules that define which locks can be acquired at the same time.

### Lock Escalation and Dynamic Locking

To keep balance between concurrency and lock granularity, SQL Server uses dynamic locking. Dynamic locking is a mechanism that allows SQL Server to escalate locks from a lower level to a higher level.
For example, if we have a shared lock on a row, SQL Server can escalate it to a shared lock on a page. This simplifies database administration, increases performance. Part of that is automatic lock adjustment.

While we have no direct control over lock escalation, we might define our preferences. We can do so at the table level (SQL Server 2008 and later): `ALTER TABLE` statement
with `WITH (LOCK_ESCALATION = {AUTO | TABLE | DISABLE})` option.

### Deadlocks

> Deadlocks are as special case of blocking, it is a situation when two or more transactions are waiting for each other to release a lock.

Microsoft SQL Server uses a deadlock detection mechanism to detect deadlocks. When a deadlock is detected, one of the transactions is rolled back.

## 6. Optimizing Concurrency and Locking Behavior

To optimize concurrency and locking behavior we need to understand how locking works in SQL Server.

### Common Locks Compatibility

> Lock compatibility controls whether multiple transactions can acquire locks on the same resource at the same time.

If a resource is already locked by another transaction, a new lock can be granted only if the mode of the requested lock is compatible.
If the mode of the requested lock is not compatible with the existing lock, the transaction requesting the new lock waits for it.
No lock modes are compatible with exclusive locks.

More info about locks compatibility can be found [here](https://www.sqlshack.com/locking-sql-server/).

### Lock Incompatibility and Consequences

> Lock incompatibility is a situation when two or more transactions are trying to acquire locks on the same resource at the same time. Lock incompatibility can cause blocking and deadlocks.

### Deadlock Analysis using SSMS and Extended Events

We can use SSMS to diagnose deadlocks. We can see the graph of the deadlock and the list of the transactions involved in the deadlock and view the details of each transaction.

### Handling and Avoiding Deadlocks

We can handle deadlocks in two ways:

- we can use `TRY...CATCH` block to handle deadlocks (fail or retry).
- we can use `SET DEADLOCK_PRIORITY` statement to change the priority of the transaction.

Example of using `TRY...CATCH` block to handle deadlocks:

```sql
BEGIN TRY
    BEGIN TRANSACTION
    UPDATE dbo.Table1
    SET Column1 = 1
    WHERE Column2 = 2
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 1205
    BEGIN
        PRINT 'Deadlock occurred'
    END
    ELSE
    BEGIN
        PRINT 'Error occurred'
    END
END CATCH
```

However, it is better to avoid deadlocks.

We can do so by:

- keep transactions short,
- set `DEADLOCK_PRIORITY`.

### Controlling Deadlocks with `DEADLOCK_PRIORITY`

We can influence the way how SQL Server handles deadlocks by using `DEADLOCK_PRIORITY` option. It can be used in `BEGIN TRANSACTION` statement.

To define that our transactions has lower priority we can use the following command:

```sql
BEGIN TRANSACTION

SET DEADLOCK_PRIORITY LOW

-- do some work
```

### Framework for Avoiding and Handling Deadlocks

Some ideas how we could limit likelihood of deadlocks:

- batched deletes,
- retry loop.

## Summary

Now you've got basic understanding of concurrency and locking in SQL Server.

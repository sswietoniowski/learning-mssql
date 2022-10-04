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

Implicit transactions are started when we execute a statement and are committed when we execute commit or rollback.

To commit a implicit transaction use the following command:

```sql
COMMIT
```

To rollback a implicit transaction use the following command:

```sql
ROLLBACK
```

### Revisiting Autocommit and Explicit Transactions

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

## 4. Implementing Snapshot Isolation Levels

## 5. Locking in the SQL Server Database Engine

## 6. Optimizing Concurrency and Locking Behavior

## Summary

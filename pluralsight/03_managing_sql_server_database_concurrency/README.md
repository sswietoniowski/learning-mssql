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

### Introducing Transactions

### Understanding Roles and Responsibilities

### Autocommit

### Explicit Transactions

### Implicit Transactions

### Revisiting Autocommit and Explicit Transactions

### Introducing Savepoints

## 3. Managing Basic Isolation Levels

## 4. Implementing Snapshot Isolation Levels

## 5. Locking in the SQL Server Database Engine

## 6. Optimizing Concurrency and Locking Behavior

## Summary

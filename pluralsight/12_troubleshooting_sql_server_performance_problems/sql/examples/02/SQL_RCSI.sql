USE [master]
GO

/* check database is in default pessimistic locking mode */
SELECT [name], is_read_committed_snapshot_on FROM sys.databases
WHERE database_id = DB_ID('WideWorldImporters');

/* switch to optimistic concurrency at the database level */
/* this is called READ COMMITTED SNAPSHOT ISOLATION, or RCSI */
ALTER DATABASE [WideWorldImporters] SET READ_COMMITTED_SNAPSHOT ON;
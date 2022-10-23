/*
	Create a database to use for testing
*/
DROP DATABASE IF EXISTS [Movies];
GO

CREATE DATABASE [Movies]
	ON  PRIMARY 
	(NAME = N'Movies', FILENAME = N'C:\Databases\Movies\Movies.mdf' , 
	SIZE = 262144KB , FILEGROWTH = 65536KB )
	LOG ON 
	(NAME = N'Movies_log', FILENAME = N'C:\Databases\Movies\Movies_log.ldf' , 
	SIZE = 131072KB , FILEGROWTH = 65536KB );
GO

ALTER DATABASE [Movies] SET RECOVERY SIMPLE;
GO

/*
	Create a table and add some data
*/
USE [Movies];
GO

CREATE TABLE [dbo].[MovieInfo] (
	[MovieID] INT IDENTITY(1,1) PRIMARY KEY, 
	[MovieName] VARCHAR(800), 
	[ReleaseDate] SMALLDATETIME,
	[Rating] VARCHAR(5)
	);
GO

INSERT INTO [dbo].[MovieInfo] ( 
	[MovieName], [ReleaseDate], [Rating]
	)
VALUES
	('IronMan', '2008-05-02 00:00:00', 'PG-13'),
	('Joy', '2016-12-25', 'PG-13'),
	('Caddyshack', '1980-07-25', 'R'),
	('The Martian', '2015-10-02', 'PG-13'),
	('Apollo 13', '1995-05-30 00:00:00', 'PG'),
	('The Hunt for Red October', '1990-03-02 00:00:00', 'PG'),
	('A Few Good Men', '1994-12-11 00:00:00', 'R'),
	('Memento', '2000-10-11', 'R'),
	('The Truman Show', '1998-06-05 00:00:00', 'PG-13'),
	('All The President''s Men', '1976-04-09 00:00:00', 'R'),
	('The Right Stuff', '1983-10-21 00:00:00', 'PG-13'),
	('The Blind Side', '2009-11-20', 'PG-13'),
	('The Natural', '1984-05-11 00:00:00', 'PG'),
	('The Hangover', '2009-06-05 00:00:00', 'R'),
	('The Incredibles', '2004-11-05 00:00:00', 'PG');
GO


CREATE TABLE [dbo].[Actors](
	[ActorID] INT IDENTITY(1,1) PRIMARY KEY, 
	[FirstName] VARCHAR(100), 
	[LastName] VARCHAR(200),
	[DOB] SMALLDATETIME
	);
GO

INSERT INTO [dbo].[Actors](
	[FirstName], [LastName], [DOB]
	)
VALUES
	('Jennifer', 'Lawrence', '1990-08-15'),
	('Robert', 'Redford', '1936-08-18'),
	('Demi', 'Moore', '1962-11-11'),
	('Alec', 'Baldwin', '1958-01-03'),
	('Sandra', 'Bullock', '1964-07-26'),
	('Tom', 'Hanks', '1956-07-09');
GO

CREATE TABLE [dbo].[Cast](
	[MovieID] INT,
	[ActorID] INT
	);
GO

INSERT INTO [dbo].[Cast](
	[MovieID], [ActorID])
VALUES
	(2, 1),
	(10, 2),
	(13, 2),
	(7, 3),
	(6, 4),
	(12, 5),
	(5, 6);
GO


/*
	Enable Query Store through the UI
*/




/*
	this is the default if you script it out
*/
USE [master];
GO
ALTER DATABASE [Movies] 
	SET QUERY_STORE = ON;
GO
ALTER DATABASE [Movies] 
	SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO


/*
	This is what it's really setting
*/
USE [master];
GO
ALTER DATABASE [Movies] 
	SET QUERY_STORE = ON;
GO
ALTER DATABASE [Movies] 
	SET QUERY_STORE (
		OPERATION_MODE = READ_WRITE, 
		CLEANUP_POLICY = 
			(STALE_QUERY_THRESHOLD_DAYS = 30), 
		DATA_FLUSH_INTERVAL_SECONDS = 900,  
		INTERVAL_LENGTH_MINUTES = 60, 
		MAX_STORAGE_SIZE_MB = 100, 
		QUERY_CAPTURE_MODE = ALL, 
		SIZE_BASED_CLEANUP_MODE = AUTO, 
		MAX_PLANS_PER_QUERY = 200);
GO


/*
	Check current status
*/
USE [Movies];
GO

SELECT 
	[actual_state_desc], 
	[readonly_reason], 
	[desired_state_desc], 
	[current_storage_size_mb], 
    [max_storage_size_mb], 
	[flush_interval_seconds], 
	[interval_length_minutes], 
    [stale_query_threshold_days], 
	[size_based_cleanup_mode_desc], 
    [query_capture_mode_desc], 
	[max_plans_per_query]
FROM [sys].[database_query_store_options];
GO

/*
	Run a query
*/
USE [Movies];
GO

SELECT *
FROM [dbo].[MovieInfo]
WHERE [ReleaseDate] >= '2001-01-01';
GO

/*
	What do we see in Query Store?
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[qsq].[initial_compile_start_time],
	[qsq].[last_compile_start_time], 
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id];
GO




/*
	Textual matching still in effect
*/
USE [Movies];
GO

SELECT *
FROM [dbo].[MovieInfo]
WHERE [ReleaseDate] >= '2001-01-01'
ORDER BY [MovieName];
GO

SELECT *
FROM [dbo].[MovieInfo]
WHERE [ReleaseDate] >= '2001-01-01'
ORDER BY [moviename];
GO

SELECT * FROM [dbo].[MovieInfo]
WHERE [ReleaseDate] >= '2001-01-01'
ORDER BY    [MovieName];
GO

SELECT
	[qsq].[query_id], 
	[qsp].[plan_id], 
	[qsq].[object_id],  
	DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
		[qsp].[last_execution_time]) AS [LocalLastExecutionTime],
	[qst].[query_sql_text], 
	ConvertedPlan = TRY_CONVERT(XML, [qsp].[query_plan])
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN (
	SELECT [query_hash] AS [query_hash], COUNT([query_id]) AS [Count]
	FROM [sys].[query_store_query] 
	GROUP BY [query_hash]
	HAVING COUNT(*) > 1
	) [m] on [qsq].[query_hash] = [m].[query_hash]
WHERE [qst].[query_sql_text] LIKE '%ReleaseDate%';
GO

/*
	Individual QUERIES are captured
*/
CREATE PROCEDURE [dbo].[usp_GetMovie] (@ID INT)
AS

	SELECT 
		[MovieName],
		[ReleaseDate],
		[Rating]
	FROM [dbo].[MovieInfo]
	WHERE [MovieID] = @ID;

	SELECT
		[a].[FirstName], 
		[a].[LastName], 
		[a].[DOB]
	FROM [dbo].[Actors] [a]
	JOIN [dbo].[Cast] [c] 
		ON [a].[ActorID] = [c].[ActorID]
	WHERE  [c].[MovieID] = @ID;
GO


EXEC [dbo].[usp_GetMovie] 5;
GO
EXEC [dbo].[usp_GetMovie] 12;
GO


SELECT
	[qsq].[query_id], 
	[qsp].[plan_id], 
	[qsq].[object_id], 
	[rs].[count_executions],
	DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
		[qsp].[last_execution_time]) AS [LocalLastExecutionTime],
	[qst].[query_sql_text], 
	ConvertedPlan = TRY_CONVERT(XML, [qsp].[query_plan])
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'usp_GetMovie');
GO


/*
	If executed from the context of another database,
	still logged in Query Store
*/
USE [master];
GO
EXEC [Movies].[dbo].[usp_GetMovie] 10;
GO

USE [Movies];
GO
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id], 
	[qsq].[object_id], 
	[rs].[count_executions],
	DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
		[qsp].[last_execution_time]) AS [LocalLastExecutionTime],
	[qst].[query_sql_text], 
	ConvertedPlan = TRY_CONVERT(XML, [qsp].[query_plan])
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsq].[object_id] = OBJECT_ID(N'usp_GetMovie');
GO


/*
	If you turn it off...
*/
USE [master];
GO
ALTER DATABASE [Movies] 
	SET QUERY_STORE = OFF;
GO

/*
	Everything is still in QS views
*/
USE [Movies];
GO

SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[qsq].[initial_compile_start_time],
	[qsq].[last_compile_start_time], 
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id];
GO


/*
	Clean up
*/
DROP DATABASE [Movies];
GO
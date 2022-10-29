/*
	Module5_Demo1B.sql
	This script should be scheduled to run on a regular basis to 
	capture selected SQL Server performance monitor counters	
	from sys.dm_os_performance_counters.
	Change the WAITFORDELAY if needed.
*/

USE [BaselineData];
GO

SET NOCOUNT ON;

DECLARE @PerfCounters TABLE (
	[Counter] NVARCHAR(770),
	[CounterType] INT,
	[FirstValue] DECIMAL(38,2),
	[FirstDateTime] DATETIME,
	[SecondValue] DECIMAL(38,2),
	[SecondDateTime] DATETIME,
	[ValueDiff] AS ([SecondValue] - [FirstValue]),
	[TimeDiff] AS (DATEDIFF(SS, FirstDateTime, SecondDateTime)),
	[CounterValue] DECIMAL(38,2)
	);

INSERT INTO @PerfCounters (
	[Counter], 
	[CounterType], 
	[FirstValue], 
	[FirstDateTime]
	)
SELECT 
	RTRIM([object_name]) + N':' + RTRIM([counter_name]) + N':' + RTRIM([instance_name]), 
	[cntr_type],
	[cntr_value], 
	GETDATE()
FROM sys.dm_os_performance_counters
WHERE [counter_name] IN (
	'Page life expectancy', 'Lazy writes/sec', 'Page reads/sec', 'Page writes/sec','Free Pages',
	'Free list stalls/sec','User Connections', 'Lock Waits/sec', 'Number of Deadlocks/sec',
	'Transactions/sec', 'Forwarded Records/sec', 'Index Searches/sec', 'Full Scans/sec',
	'Batch Requests/sec','SQL Compilations/sec', 'SQL Re-Compilations/sec', 'Total Server Memory (KB)',
	'Target Server Memory (KB)', 'Latch Waits/sec'
	)
ORDER BY [object_name] + N':' + [counter_name] + N':' + [instance_name];

WAITFOR DELAY '00:00:10';

UPDATE @PerfCounters 
SET [SecondValue] = [cntr_value],
	[SecondDateTime] = GETDATE()
FROM sys.dm_os_performance_counters  
WHERE [Counter] =  RTRIM([object_name]) + N':' + RTRIM([counter_name]) + N':' + RTRIM([instance_name])
AND [counter_name] IN (
	'Page life expectancy', 'Lazy writes/sec', 'Page reads/sec', 'Page writes/sec','Free Pages',
	'Free list stalls/sec','User Connections', 'Lock Waits/sec', 'Number of Deadlocks/sec',
	'Transactions/sec', 'Forwarded Records/sec', 'Index Searches/sec', 'Full Scans/sec',
	'Batch Requests/sec','SQL Compilations/sec', 'SQL Re-Compilations/sec', 'Total Server Memory (KB)',
	'Target Server Memory (KB)', 'Latch Waits/sec'
	);

UPDATE @PerfCounters 
SET [CounterValue] = [ValueDiff]/[TimeDiff]
WHERE [CounterType] = 272696576 ;

UPDATE @PerfCounters
SET [CounterValue] = [SecondValue]
WHERE [CounterType] <> 272696576;

INSERT INTO [dbo].[PerfMonData] (
	[Counter],
	[Value],
	[CaptureDate])
SELECT
	[Counter], 
	[CounterValue],
	[SecondDateTime]
FROM @PerfCounters;



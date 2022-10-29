/*
	This demo assumes that relog has been used to process at least 
	one file from Performance Monitor into a database.
*/


USE BaselineData;
GO


/* 
	list each collector set 
*/
SELECT
	[GUID], 
	[DisplayString], 
	[LogStartTime], 
	[LogStopTime], 
	[NumberOfRecords]
FROM [dbo].[DisplayToID] 
ORDER BY [DisplayString];


/* 
	list of counters 
*/
SELECT 
	[CounterID], 
	[MachineName], 
	[ObjectName], 
	[CounterName], 
	[InstanceName]
FROM [dbo].[CounterDetails]
ORDER BY [CounterID];


/* 
	data collected 
*/
SELECT TOP 100 
	[GUID], 
	[CounterDateTime], 
	[CounterID], 
	[CounterValue]
FROM [dbo].[CounterData];


/* 
	show all data collected for specific collector set, 
	ordered by counter and time 
*/
SELECT 
	[cd].[CounterDateTime], 
	[cdt].[ObjectName], 
	[cdt].[CounterName], 
	[cd].[CounterValue]
FROM [dbo].[CounterData] [cd]
JOIN [dbo].[DisplayToID] [di] ON [cd].[GUID] = [di].[GUID]
JOIN [dbo].[CounterDetails] [cdt] ON [cd].[CounterID] = [cdt].[CounterID]
WHERE [di].[DisplayString] = 'ProdSample' 
ORDER BY [cdt].[ObjectName], [cdt].[CounterName], [cd].[RecordIndex];


/* 
	List min, max, avg and stdev for each counter for a specific collector set
*/
SELECT 
	CONVERT(VARCHAR(10),[cd].[CounterDateTime], 101) AS "Collection", 
	RTRIM([cdt].[ObjectName]) + '\' + RTRIM([cdt].[CounterName]) +  
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN '_' + RTRIM([cdt].[InstanceName])
		END AS "Counter", 
	CAST(MIN([cd].[CounterValue]) AS DECIMAL(6,0)) AS "Minimum", 
	CAST(MAX([cd].[CounterValue]) AS DECIMAL(6,0)) AS "Maximum", 
	CAST(AVG([cd].[CounterValue]) AS DECIMAL(6,0)) AS "Average", 
	CAST(STDEV([cd].[CounterValue]) AS DECIMAL(6,0)) AS "StDev"
FROM [dbo].[CounterData] [cd]
JOIN [dbo].[DisplayToID] [di] ON [cd].[GUID] = [di].[GUID]
JOIN [dbo].[CounterDetails] [cdt] ON [cd].[CounterID] = [cdt].[CounterID]
WHERE [di].[DisplayString] = 'ProdSample' 
GROUP BY 
	CONVERT(VARCHAR(10),[cd].[CounterDateTime], 101), 
	RTRIM([cdt].[ObjectName]) + '\' + RTRIM([cdt].[CounterName]) +  
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN '_' + RTRIM([cdt].[InstanceName])
		END
ORDER BY
	RTRIM([cdt].[ObjectName]) + '\' + RTRIM([cdt].[CounterName]) +  
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN '_' + RTRIM([cdt].[InstanceName])
		END


/*
	List max and avg for all counters for all samples
*/
SELECT 
	[di].[DisplayString] AS "Sample", 
	RTRIM([cdt].[ObjectName]) AS "Counter Object",
	RTRIM([cdt].[CounterName]) AS "Counter Name", 
	CASE
		WHEN [cdt].[InstanceName] IS NULL THEN ''
		WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].InstanceName)
	END AS "Counter Instance", 
	MAX([cd].[CounterValue]) AS "MaxValue", 
	AVG([cd].[CounterValue]) AS "AvgValue"
FROM 
	[dbo].[DisplayToID] [di]
	JOIN [dbo].[CounterData] [cd] ON [di].[GUID]=[cd].[GUID]
	JOIN [dbo].[CounterDetails] [cdt] ON [cd].[CounterID]=[cdt].[CounterID]
GROUP BY 
	[di].[DisplayString], 
	RTRIM([cdt].[ObjectName]),
	RTRIM([cdt].[CounterName]), 
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].[InstanceName])
		END
ORDER BY 
	RTRIM([cdt].[CounterName]), 
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].[InstanceName])
		END,
		RTRIM([cdt].[ObjectName])


/*
	List max and avg for selected counters for all samples
*/

SELECT 
	[di].[DisplayString] AS "Sample", 
	RTRIM([cdt].[ObjectName]) AS "Counter Object",
	RTRIM([cdt].[CounterName]) AS "Counter Name", 
	CASE
		WHEN [cdt].[InstanceName] IS NULL THEN ''
		WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].InstanceName)
	END AS "Counter Instance", 
	MIN([cd].[CounterValue]) AS "MinValue",
	MAX([cd].[CounterValue]) AS "MaxValue", 
	AVG([cd].[CounterValue]) AS "AvgValue"
FROM 
	[dbo].[DisplayToID] [di]
	JOIN [dbo].[CounterData] [cd] ON [di].[GUID]=[cd].[GUID]
	JOIN [dbo].[CounterDetails] [cdt] ON [cd].[CounterID]=[cdt].[CounterID]
WHERE [cdt].[CounterName] = 'Batch Requests/sec' 
	or ([cdt].[CounterName] like '% Processor Time' and [cdt].[ObjectName] like 'Processor')
	or ([cdt].[CounterName] = 'Avg. Disk sec/Read' and ([cdt].[InstanceName] like '%C%' or [cdt].[InstanceName] like '%E%'))
	or [cdt].[CounterName] = 'Available MBytes'
GROUP BY 
	[di].[DisplayString], 
	RTRIM([cdt].[ObjectName]),
	RTRIM([cdt].[CounterName]), 
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].[InstanceName])
		END
ORDER BY 
	RTRIM([cdt].[CounterName]), 
		CASE
			WHEN [cdt].[InstanceName] IS NULL THEN ''
			WHEN [cdt].[InstanceName] IS NOT NULL THEN RTRIM([cdt].[InstanceName])
		END,
		RTRIM([cdt].[ObjectName])






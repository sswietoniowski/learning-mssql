/* SQL Server cached counters */
SELECT * 
FROM sys.dm_os_performance_counters

/* Buffer Manager:Page life expectancy counter value */
SELECT * 
FROM sys.dm_os_performance_counters
WHERE [object_name] = 'SQLServer:Buffer Manager'
	AND counter_name = 'Page life expectancy'

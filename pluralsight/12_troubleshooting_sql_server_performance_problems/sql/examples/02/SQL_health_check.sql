
/* verify version, patch level, edition */
SELECT @@VERSION As Server_Version;

/* verify VM CPU configuration */
SELECT
	cpu_count,
	hyperthread_ratio,
	scheduler_count,
	socket_count,
	cores_per_socket,
	max_workers_count
FROM sys.dm_os_sys_info;

/* verify SQL Server services, if instant file initialization enabled */
SELECT
	servicename,
	startup_type_desc,
	status_desc,
	service_account,
	is_clustered,
	instant_file_initialization_enabled
FROM sys.dm_server_services;

/* verify databases, compatibility levels, recovery models, if snapshot isolation modes are enabled */
SELECT 
	[name],
	database_id,
	[state_desc],
	[compatibility_level],	
	recovery_model_desc,	
	snapshot_isolation_state_desc,
	is_read_committed_snapshot_on
FROM sys.databases;

/* verify server memory configuration options */
SELECT * 
FROM sys.configurations
WHERE [name] IN 
	('max server memory (mb)', 
	 'min server memory (mb)');

/* verify installed physical memory, memory usage, memory model, service startup time */
SELECT	
	CEILING(physical_memory_kb / 1024.0 / 1024.0) AS physical_memory_GB,
	CEILING(committed_kb / 1024.0) AS committed_memory_MB,
	CEILING(committed_target_kb / 1024.0) AS committed_target_memory_MB,
	CEILING(visible_target_kb / 1024.0) AS visible_target_memory_MB,
	sql_memory_model_desc,
	sqlserver_start_time
FROM sys.dm_os_sys_info;

/* verify WideWorldImporters database physical layout */
SELECT
	database_id,
	[file_id],
	[type],
	[type_desc],
	[name],
	physical_name,
	size,
	max_size,
	is_percent_growth,
	growth	
FROM sys.master_files
WHERE database_id = DB_ID('WideWorldImporters');

/* verify tempdb physical layout */
SELECT
	database_id,
	[file_id],
	[type],
	[type_desc],
	[name],
	physical_name,
	size,
	max_size,
	is_percent_growth,
	growth	
FROM sys.master_files
WHERE database_id = 2;


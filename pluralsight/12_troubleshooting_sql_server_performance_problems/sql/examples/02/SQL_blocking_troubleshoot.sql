/* let's see if my session_id is on the waiter list */
SELECT * FROM sys.dm_os_waiting_tasks
WHERE session_id = 74;

/* get the database name and the object name from resource_description */
SELECT OBJECT_NAME(94623380) AS [object_name];
SELECT DB_NAME(5) AS [db_name];

/* see who is the blocker */
SELECT * FROM sys.dm_exec_requests
WHERE session_id = 82;
/* get the SQL statement */
SELECT * FROM sys.dm_exec_sql_text(0x02000000A2CA46001AE59AF3A044F31FC34D25D8981AC5830000000000000000000000000000000000000000);

/* use the newer DMV to get the blocker session details */
SELECT * FROM sys.dm_exec_input_buffer(82, NULL);
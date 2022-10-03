USE BobsShoes;
GO

SELECT 
    CAST(es.context_info AS varchar(30)) AS [Session],
    tl.resource_type,
    tl.request_mode,
    tl.request_status,
    CASE tl.resource_type
        WHEN 'OBJECT' THEN OBJECT_NAME(tl.resource_associated_entity_id)
        WHEN 'KEY' THEN (
            SELECT OBJECT_NAME(p.object_id) 
            FROM sys.partitions p
            WHERE p.hobt_id = tl.resource_associated_entity_id
            )
    END AS ObjectName

FROM sys.dm_tran_locks tl
JOIN sys.dm_exec_sessions es
  ON tl.request_session_id = es.session_id
WHERE es.context_info <> 0x00
AND tl.resource_database_id = DB_ID()
ORDER BY es.context_info, tl.resource_type;

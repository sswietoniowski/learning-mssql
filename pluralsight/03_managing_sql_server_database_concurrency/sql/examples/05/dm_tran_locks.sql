USE BobsShoes;
GO

SELECT 
    CAST(es.context_info AS varchar(30)) AS [Session],
    tl.resource_type,
    tl.request_mode,
    tl.request_status
    
FROM sys.dm_tran_locks tl
JOIN sys.dm_exec_sessions es
  ON tl.request_session_id = es.session_id
WHERE es.context_info <> 0x00
ORDER BY es.context_info, resource_type;

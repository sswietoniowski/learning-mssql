SELECT
    IIF(request_session_id = 53, 'Trillian', 'Arthur') AS SessionName,
    resource_type, 
    request_type, 
    request_mode,
    request_status
    
FROM sys.dm_tran_locks
WHERE request_session_id IN (53, 54)
ORDER BY request_session_id, resource_type;

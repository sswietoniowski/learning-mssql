SELECT resource_type, 
       request_mode, 
       request_status, 
       resource_associated_entity_id
FROM sys.dm_tran_locks
WHERE resource_database_id = db_id(N'BobsShoes')

SELECT OBJECT_NAME(1915153868, db_id(N'BobsShoes'))
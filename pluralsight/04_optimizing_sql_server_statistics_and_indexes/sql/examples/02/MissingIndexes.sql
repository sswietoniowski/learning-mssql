SELECT DB_NAME(mid.database_id) AS DatabaseName,
       OBJECT_SCHEMA_NAME(mid.object_id, mid.database_id) AS SchemaName,
       OBJECT_NAME(mid.object_id, mid.database_id) AS ObjectName,
       migs.avg_user_impact,
       mid.equality_columns,
       mid.inequality_columns,
       mid.included_columns
FROM sys.dm_db_missing_index_groups mig
    INNER JOIN sys.dm_db_missing_index_group_stats migs
        ON migs.group_handle = mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details mid
        ON mig.index_handle = mid.index_handle;

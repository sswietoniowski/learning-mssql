SELECT OBJECT_NAME(i.object_id) AS TableName,
       i.index_id,
       ISNULL(user_seeks, 0) AS UserSeeks,
       ISNULL(user_scans, 0) AS UserScans,
       ISNULL(user_lookups, 0) AS UserLookups,
       ISNULL(user_updates, 0) AS UserUpdates
FROM sys.indexes i
    LEFT OUTER JOIN sys.dm_db_index_usage_stats ius
        ON ius.object_id = i.object_id AND ius.index_id = i.index_id
WHERE OBJECTPROPERTY(i.object_id, 'IsMSShipped') = 0;

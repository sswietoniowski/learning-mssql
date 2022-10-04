SELECT OBJECT_SCHEMA_NAME(rg.object_id) AS SchemaName,
       OBJECT_NAME(rg.object_id) AS TableName,
       i.name AS IndexName,
       i.type_desc AS IndexType,
       rg.partition_number,
       rg.state_description,
       COUNT(*) AS NumberOfRowgroups,
       SUM(rg.total_rows) AS TotalRows,
       SUM(rg.size_in_bytes) AS TotalSizeInBytes,
       SUM(rg.deleted_rows) AS TotalDeletedRows
FROM sys.column_store_row_groups AS rg INNER JOIN sys.indexes AS i ON i.object_id = rg.object_id AND i.index_id = rg.index_id
GROUP BY rg.object_id,
         i.name,
         i.type_desc,
         rg.partition_number,
         rg.state_description
ORDER BY TableName,
         IndexName,
         rg.partition_number;
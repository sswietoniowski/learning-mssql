SELECT OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
       OBJECT_NAME(i.object_id) AS TableName,
       i.name,
       i.type_desc,
       STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY key_ordinal) AS KeyCols
FROM sys.indexes i
    INNER JOIN sys.index_columns ic
        ON ic.object_id = i.object_id
           AND ic.index_id = i.index_id
    INNER JOIN sys.columns c
        ON c.object_id = i.object_id
           AND c.column_id = ic.column_id
WHERE OBJECTPROPERTYEX(i.object_id, 'IsMSShipped') = 0
      AND ic.is_included_column = 0
GROUP BY i.object_id,
         i.name,
         i.type_desc;

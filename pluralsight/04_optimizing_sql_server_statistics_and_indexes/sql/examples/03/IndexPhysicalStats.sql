SELECT OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName, OBJECT_NAME(i.object_id) TableName, 
	i.name,
	ips.partition_number, 
	ips.index_type_desc, 
	ips.index_level,
	ips.avg_fragmentation_in_percent,
	ips.page_count,
	ips.avg_page_space_used_in_percent
	FROM sys.indexes i 
		INNER JOIN sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'detailed') ips 
			ON ips.object_id = i.object_id AND ips.index_id = i.index_id
	WHERE i.name = 'idx_ShipmentDetails_ShipmentID';


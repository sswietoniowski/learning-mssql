SELECT COUNT(*) FROM dbo.ShipmentDetailsColumnStore;







SELECT object_id,
       index_id,
       used_page_count,
       reserved_page_count,
       row_count
FROM sys.dm_db_partition_stats WHERE OBJECT_ID = OBJECT_ID('ShipmentDetailsColumnStore')

-- 43534 pages as a heap
-- 14273 pages as a clustered columnstore
-- 11433 pages as a nonclustered columnstore



























SELECT ShipmentID,
       SUM(sd.Mass) AS TotalMass,
       SUM(sd.Volume) AS TotalVolume,
       SUM(sd.NumberOfContainers) AS TotalContainers
FROM dbo.ShipmentDetailsColumnStore sd
GROUP BY ShipmentID


SELECT * FROM dbo.ShipmentDetailsColumnStore WHERE ShipmentID = 22322

-- heap    CPU time = 12392 ms,  elapsed time = 2028 ms.
-- clustered columnstore    CPU time = 859 ms,  elapsed time = 413 ms.
-- nonclustered columnstore   CPU time = 921 ms,  elapsed time = 374 ms.
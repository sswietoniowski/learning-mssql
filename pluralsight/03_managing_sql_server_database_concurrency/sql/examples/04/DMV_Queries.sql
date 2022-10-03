USE BobsShoes;
GO

--  Show the active snapshot transactions
SELECT DB_NAME(database_id) AS DatabaseName, t.*
FROM sys.dm_tran_active_snapshot_database_transactions t
    JOIN sys.dm_exec_sessions s
    ON t.session_id = s.session_id;

-- Show space usage in tempdb
SELECT DB_NAME(vsu.database_id) AS DatabaseName,
    vsu.reserved_page_count, 
    vsu.reserved_space_kb, 
    tu.total_page_count as tempdb_pages, 
    vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
    tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
FROM sys.dm_tran_version_store_space_usage vsu
    CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
WHERE vsu.database_id = DB_ID(DB_NAME());

-- Show the contents of the current version store (expensive)
SELECT DB_NAME(database_id) AS DatabaseName, *
FROM sys.dm_tran_version_store;

-- Show objects producing most versions (expensive)
SELECT DB_NAME(database_id) AS DatabaseName, *
FROM sys.dm_tran_top_version_generators;

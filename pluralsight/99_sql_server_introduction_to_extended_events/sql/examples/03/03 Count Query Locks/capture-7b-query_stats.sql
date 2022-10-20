-- Get the query stats for a query_hash
SELECT * 
FROM [sys].[dm_exec_query_stats]
WHERE CAST(query_hash AS BIGINT) = <value>;


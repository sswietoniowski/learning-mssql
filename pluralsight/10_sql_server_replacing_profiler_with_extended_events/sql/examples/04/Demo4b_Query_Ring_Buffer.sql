/*
	Query the ring_buffer for information
	Next, create an XML variable to hold Target Data
*/
DECLARE @target_data XML;
SELECT @target_data = CAST(target_data AS XML)
FROM sys.dm_xe_sessions AS s 
JOIN sys.dm_xe_session_targets AS t 
    ON t.event_session_address = s.address
WHERE s.name = N'Capture_Queries_RB'
  AND t.target_name = N'ring_buffer';

/*
	Query the XML variable to get Event Data
*/
SELECT 
    @target_data.value('(RingBufferTarget/@eventsPerSec)[1]', 'int') AS eventsPerSec,
    @target_data.value('(RingBufferTarget/@processingTime)[1]', 'int') AS processingTime,
    @target_data.value('(RingBufferTarget/@totalEventsProcessed)[1]', 'int') AS totalEventsProcessed,
    @target_data.value('(RingBufferTarget/@eventCount)[1]', 'int') AS eventCount,
    @target_data.value('(RingBufferTarget/@droppedCount)[1]', 'int') AS droppedCount,
    @target_data.value('(RingBufferTarget/@memoryUsed)[1]', 'int') AS memoryUsed;

SELECT 
    n.value('(@name)[1]', 'varchar(50)') AS [event_name],
    --n.value('(@package)[1]', 'varchar(50)') AS [package_name],
    DATEADD(hh, 
            DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP), 
            n.value('(@timestamp)[1]', 'datetime2')) AS [timestamp],
    n.value('(data[@name="session_id"]/value)[1]', 'int') AS [session_id],
	n.value('(data[@name="duration"]/value)[1]', 'int') AS [duration],
    n.value('(data[@name="logical_reads"]/value)[1]', 'int') AS [logicalreads],
    n.value('(data[@name="statement"]/value)[1]', 'nvarchar(max)') AS [statement]
FROM @target_data.nodes('RingBufferTarget/event') AS q(n);
GO
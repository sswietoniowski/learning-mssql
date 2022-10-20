-- Retrieve from Extended Events in 2008/2008R2
SELECT CAST(XEvent.value('(event/data/value)[1]', 'varchar(max)')AS XML) as DeadlockGraph
FROM
(SELECT 
    XEvent.query('.') AS XEvent
 FROM    (SELECT CAST(target_data AS XML) AS TargetData
         FROM sys.dm_xe_session_targets st
         JOIN sys.dm_xe_sessions s 
            ON s.address = st.event_session_address
         WHERE s.name = 'system_health'
           AND st.target_name = 'ring_buffer') AS Data
 CROSS APPLY TargetData.nodes ('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData (XEvent)
) AS src;



-- Retrieve from Extended Events in 2012
SELECT XEvent.query('(event/data[@name="xml_report"]/value/deadlock)[1]') as DeadlockGraph
FROM
(SELECT 
    XEvent.query('.') AS XEvent
 FROM    (SELECT CAST(target_data AS XML) AS TargetData
         FROM sys.dm_xe_session_targets st
         JOIN sys.dm_xe_sessions s 
            ON s.address = st.event_session_address
         WHERE s.name = 'system_health'
           AND st.target_name = 'ring_buffer') AS Data
 CROSS APPLY TargetData.nodes ('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData (XEvent)
) AS src;
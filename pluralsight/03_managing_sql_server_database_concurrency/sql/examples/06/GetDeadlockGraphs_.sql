/* 
    Jonathan Kehayias and Ted Krueger (2011)
    Troubleshooting SQL Server
    A Guide for the Accidental DBA
    Simple Talk Publishing 
    Chapter 7: Handling Deadlocks
*/
SELECT XEvent.query('(event/data/value/deadlock)[1]') AS DeadlockGraph 
FROM ( SELECT XEvent.query('.') AS XEvent 
       FROM ( SELECT CAST(target_data AS XML) AS TargetData 
              FROM sys.dm_xe_session_targets st 
                   JOIN sys.dm_xe_sessions s 
                   ON s.address = st.event_session_address 
              WHERE s.name = 'system_health' 
                    AND st.target_name = 'ring_buffer' 
              ) AS Data 
              CROSS APPLY 
                 TargetData.nodes 
                    ('RingBufferTarget/event[@name="xml_deadlock_report"]')
              AS XEventData ( XEvent ) 
      ) AS src;

-- My version
SELECT dead.lock.query('(event/data/value/deadlock)[1]') AS DeadlockGraph 
FROM sys.dm_xe_session_targets st 
JOIN sys.dm_xe_sessions s 
    ON s.address = st.event_session_address 
CROSS APPLY (SELECT CAST(st.target_data AS XML)) AS target(data)
CROSS APPLY target.data.nodes
    ('RingBufferTarget/event[@name="xml_deadlock_report"]') AS deadlock(report)
CROSS APPLY (SELECT report.query('.')) AS dead(lock)
WHERE s.name = 'system_health' 
    AND st.target_name = 'ring_buffer'   


-- FLWOR
SELECT CAST(st.target_data AS XML).query('
for $d in 
    RingBufferTarget/event[@name="xml_deadlock_report"]/data/value/deadlock
return $d') AS DeadlockReport
FROM sys.dm_xe_session_targets st 
JOIN sys.dm_xe_sessions s 
    ON s.address = st.event_session_address 
WHERE s.name = 'system_health' 
    AND st.target_name = 'ring_buffer'   

-- my version 2
SELECT deadlock.reports.query('deadlock')
FROM sys.dm_xe_session_targets st 
JOIN sys.dm_xe_sessions s 
    ON s.address = st.event_session_address 
CROSS APPLY (SELECT CAST(st.target_data AS XML)) as t(d)
CROSS APPLY t.d.nodes
    ('RingBufferTarget/event[@name="xml_deadlock_report"]/data/value') 
    AS deadlock(reports)
WHERE s.name = 'system_health' 
    AND st.target_name = 'ring_buffer'   
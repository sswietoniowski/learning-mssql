SELECT deadlock.reports.query('deadlock')
FROM sys.fn_xe_file_target_read_file
    (N'C:\temp\Deadlocks\Deadlocks*.xel', NULL, NULL, NULL) xe
CROSS APPLY (SELECT CAST(xe.event_data AS XML)) as t(d)
CROSS APPLY t.d.nodes
    ('event[@name="xml_deadlock_report"]/data/value') 
    AS deadlock(reports);

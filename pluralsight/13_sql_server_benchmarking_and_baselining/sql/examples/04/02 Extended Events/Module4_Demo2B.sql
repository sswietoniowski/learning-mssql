/*
	Module4_Demo2B.sql
	Use this script to schedule the stop and drop
	of an Extended Events session
	Change the session name as appropriate
*/

ALTER EVENT SESSION  [CaptureQueries]
ON SERVER
STATE = STOP
GO


DROP EVENT SESSION [CaptureQueries] ON SERVER;
-- Minimum requirements is a single event
CREATE EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported];
GO

-- Drop the event session to show single target doesn't work
DROP EVENT SESSION [Pluralsight Min Reqs] ON SERVER ;
GO

-- Try creating with just a target
CREATE EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
ADD TARGET package0.ring_buffer;
GO

-- Now create the session with both 
CREATE EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported]
ADD TARGET package0.ring_buffer;
GO

-- Drop the event
ALTER EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
DROP EVENT [sqlserver].[error_reported];
GO

-- Drop the event session to show single event on ALTER
DROP EVENT SESSION [Pluralsight Min Reqs] ON SERVER ;
GO

-- Now create the session with both 
CREATE EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
ADD EVENT [sqlserver].[error_reported]
ADD TARGET package0.ring_buffer;
GO

-- Drop the target
ALTER EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
DROP TARGET package0.ring_buffer;
GO

-- Now try to  drop the event too
ALTER EVENT SESSION [Pluralsight Min Reqs] 
ON SERVER 
DROP EVENT [sqlserver].[error_reported];
GO

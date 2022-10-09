-- Run this script to follow along with the demo
USE [ABCCompany];
GO

-- Check which isolation level we are using
DBCC USEROPTIONS;
GO


SELECT	s.session_id AS 'SPID'
		,s.nt_user_name AS 'User'
		,CASE s.transaction_isolation_level 
		WHEN 0 THEN 'Unspecified' 
		WHEN 1 THEN 'Read Uncomitted' 
		WHEN 2 THEN 'Read Comitted' 
		WHEN 3 THEN 'Repeatable' 
		WHEN 4 THEN 'Serializable' 
		WHEN 5 THEN 'Snapshot' 
                  END as 'Isolation Level'
FROM [sys].[dm_exec_sessions] s
WHERE s.session_id = @@SPID;
GO


-- Perform some updates on our salesorder table
BEGIN TRANSACTION;

	UPDATE Sales.SalesOrder SET OrderDescription = NULL;

ROLLBACK TRANSACTION;
GO


-- Let's make sure we have no open transactions
DBCC OPENTRAN;
GO

-- Only try and update one row
BEGIN TRANSACTION;

	UPDATE Sales.SalesOrder SET OrderDescription = NULL WHERE Id = 1;

ROLLBACK TRANSACTION;
GO
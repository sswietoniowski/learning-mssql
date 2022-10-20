CREATE TABLE Application.AuditLog (
	AuditLogID int identity,
	ModifiedTime DATETIME,
	ModifiedBy nvarchar(100),
	Operation nvarchar(16),
	SchemaName nvarchar(64),
	TableName nvarchar(64),
	TableID int,
	LogData nvarchar(max)
);
GO

truncate table Application.AuditLog;
GO

/*
  Save a row to the AuditLog table for every row that is actually
  updated.  See the impact when there are many rows.
*/
CREATE OR ALTER TRIGGER Sales.TU_OrderLines
ON Sales.OrderLines FOR UPDATE
AS
BEGIN
		IF (ROWCOUNT_BIG() = 0)
			RETURN;

		SET NOCOUNT ON;
		/*
		  Any UPDATE or DELETE should always have at least one
		  row in the DELETED table if data was modified or deleted.

		  If not, exit out and don't do any more work.
		*/
		IF NOT EXISTS (SELECT 1 FROM DELETED)
			RETURN;
		
		/*
		  Assume this is an UPDATE to start, having both
		  INSERTED and DELETED data
		*/
		DECLARE @operationType nvarchar(16) = 'UPDATE';

		SELECT * INTO #ModifiedData FROM (			
				SELECT * FROM DELETED
				EXCEPT
				SELECT * FROM INSERTED
		) ModifiedData;


		/*
		  For each row of the modified data, select a JSON document of the previous data to include in the audit log table.
		*/
		IF EXISTS (SELECT 1 FROM #ModifiedData)
		BEGIN
			INSERT INTO Application.AuditLog ([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
				SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','OrderLines',M1.OrderLineID, M2.OldValues
					FROM #ModifiedData M1
					CROSS APPLY (
						SELECT oldValues=(select * from #ModifiedData WHERE #ModifiedData.OrderLineID = M1.OrderLineID FOR JSON PATH)
					) AS M2
		END;
	END;
GO	

/*
  Check the AuditLog table first
*/
SELECT count(*) FROM Application.AuditLog;

/*
  Set the statistics TIME on so that we can see a representation
  of the work being done by the full command execution
*/
SET STATISTICS TIME ON;

/*
  Two runs to get timing.  Update the Quantity column on all specified rows
*/
UPDATE Sales.OrderLines SET Quantity = Quantity+1 where orderId < 25000;

UPDATE Sales.OrderLines SET Quantity = Quantity-1 where orderId < 25000;
GO


/*
  Now add at least some defensive SQL. Only add another entry if
  this record hasn't been updated today.
*/
CREATE OR ALTER TRIGGER Sales.TU_OrderLines
ON Sales.OrderLines FOR UPDATE
AS
BEGIN
	
		IF (ROWCOUNT_BIG() = 0)
			RETURN;

		SET NOCOUNT ON;

		/*
		  Any UPDATE or DELETE should always have at least one
		  row in the DELETED table if data was modified or deleted.

		  If not, exit out and don't do any more work.
		*/
		IF NOT EXISTS (SELECT 1 FROM DELETED)
			RETURN;
		
		/*
		  Assume this is an UPDATE to start, having both
		  INSERTED and DELETED data
		*/
		DECLARE @operationType nvarchar(16) = 'UPDATE';

		SELECT * INTO #ModifiedData FROM (			
				SELECT * FROM DELETED
				EXCEPT
				SELECT * FROM INSERTED
		) ModifiedData;

		IF EXISTS (SELECT 1 FROM Application.AuditLog AL
						INNER JOIN #ModifiedData MD ON AL.TableID = MD.OrderLineID
						WHERE TableName = 'OrderLines' AND
						    Operation = 'UPDATE' AND
							ModifiedTime >= CAST(GetDate() as Date) AND
							ModifiedTime < CAST(DateAdd(DAY, 1, GetDate()) as Date)
							)
			RETURN;

		/*
		  For each row of the modified data, select a JSON document of the previous data to include in the audit log table.
		*/
		IF EXISTS (SELECT 1 FROM #ModifiedData)
		BEGIN
			INSERT INTO Application.AuditLog ([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
				SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','OrderLines',M1.OrderLineID, M2.OldValues
					FROM #ModifiedData M1
					CROSS APPLY (
						SELECT oldValues=(select * from #ModifiedData WHERE #ModifiedData.OrderLineID = M1.OrderLineID FOR JSON PATH)
					) AS M2
		END;
	END;
GO	


/*
  Two more runs to get timing.  Update the Quantity column on all specified rows.

  Because there are log records for today, we don't insert again and save work.

*/
UPDATE Sales.OrderLines SET Quantity = Quantity+1 where orderId < 25000;

UPDATE Sales.OrderLines SET Quantity = Quantity-1 where orderId < 25000;
GO

/*
  As with other demos, this is an imperfect example and would certainly need
  more thought depending on your business needs. The main takeaway is that 
  Triggers are not free, and especially on large batches of INSERT, UPDATE and
  DELETE operations, more thought needs to be given to the performance impact 
  possible and techniques to mitigate it.
*/






/*
  Cleanup
*/
DROP TRIGGER Sales.TU_OrderLines;

TRUNCATE TABLE Application.AuditLog;

SET STATISTICS TIME OFF;
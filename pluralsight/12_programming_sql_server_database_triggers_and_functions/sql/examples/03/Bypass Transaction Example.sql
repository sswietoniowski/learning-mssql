/*
  Prep

  Again, remove references to Sales.Invoices so that we can
  attempt to delete data for the demo. In production systems
  a better overall view of CASCADE should be implemented or
  stored procedures that woudl delete the necessary data
  at one time.

  Second, empty the audit table.

*/
select * from sales.orders where orderID < 50;
update Sales.OrderLines set ORderId = 10 where ORderId is null;

UPDATE Sales.Invoices set OrderID = NULL where OrderId < 50;
GO

TRUNCATE TABLE Application.AuditLog;
GO

/*
  Let's redo the DELETE Trigger to log an attempted delete
  even if the constraint fails.
*/


/*
  Modify the previous logging examples by adding a Table Variable 
  that stores the deleted rows. This can be used later to INSERT
  the values into the audit table even if there is a rollback.
*/
CREATE OR ALTER TRIGGER [Sales].[TD_Orders_AFTER]ON 
	[Sales].[Orders]AFTER DELETEAS
	BEGIN
		IF (ROWCOUNT_BIG() = 0)
			RETURN;

		SET NOCOUNT ON;

		IF NOT EXISTS (SELECT 1 FROM DELETED)
			RETURN;
		
		/*
		  Variables are declared within the scope of the module they are
		  created in. This @operationType variable, like the table variable
		  below it won't be reset by a ROLLBACK and can be used as part
		  of the logging later
		*/ 
		DECLARE @operationType nvarchar(16) = 'DELETE';

		DECLARE @deleted TABLE (
			[OrderID] INT,
			[CustomerID] INT,
			[SalespersonPersonID] INT,
			[PickedByPersonID] INT,
			[ContactPersonID] INT,
			[BackorderOrderID] INT,
			[OrderDate] date,
			[ExpectedDeliveryDate] date,
			[CustomerPurchaseOrderNumber] nvarchar(20),
			[IsUndersupplyBackordered] bit,
			[Comments] nvarchar(max),
			[DeliveryInstructions] nvarchar(max),
			[InternalComments] nvarchar(max),
			[PickingCompletedWhen] datetime2,
			[LastEditedBy] int,
			[LastEditedWhen] datetime2
		);

		insert into @deleted
			select * from deleted;

	
		-- Has the order been picked for delivery yet?
		IF EXISTS 
		(
			SELECT 1 FROM DELETED d WHERE d.PickingCompletedWhen is not null
		)
		BEGIN
			SET @operationType = 'ATTEMPTED DELETE';
			RAISERROR('The OrderLine has been fulfilled and cannot be deleted',16,1);
			ROLLBACK TRAN;
		END;

		/*
		  This was an attempted delete that is being logged.  No reason, for now, to store
		  a copy of the data in JSON which could be quite large
		*/
		IF EXISTS (SELECT 1 FROM @deleted) AND (@operationType = 'ATTEMPTED DELETE')
		BEGIN
			/*
			  Using the Temp table that has the deleted rows
			*/
			INSERT INTO Application.AuditLog 
					([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
				SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','Orders',D1.OrderId, NULL
					FROM @deleted D1;
		END;
	
		/*
		  This is a normal delete, go ahead and take the additional step of saving the
		  row data to a JSON object and saving it in the audit log table
		*/
		IF EXISTS (SELECT 1 FROM @deleted) AND (@operationType = 'DELETE')
		begin
			/*
			  Using the Temp table that has the deleted rows
			*/
			INSERT INTO Application.AuditLog 
					([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
				SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','Orders',D1.OrderId, D2.LogData
					FROM @deleted D1
					CROSS APPLY (
						SELECT LogData=(select * from @deleted WHERE 
										OrderID = D1.OrderID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
					) AS D2;
		END;

		
	END; -- The overall Trigger BEGIN/END
GO

/*
  Delete rows of data
*/
DELETE FROM Sales.Orders WHERE OrderID < 20;
GO

/*
   Remember, Foreign Key constraints preempt AFTER Triggers. Our 
   logic was never executed.
*/
DELETE FROM Sales.OrderLines where OrderID < 20;

/*
  Delete rows of data
*/
DELETE FROM Sales.Orders WHERE OrderID < 20;
GO


SELECT * FROM Application.AuditLog;
GO

/*
  Attempt 2 - Try a Temporary Table
*/
CREATE OR ALTER TRIGGER [Sales].[TD_Orders_AFTER]ON 
	[Sales].[Orders]AFTER DELETEAS
	BEGIN
		IF (ROWCOUNT_BIG() = 0)
			RETURN;

		SET NOCOUNT ON;

		IF NOT EXISTS (SELECT 1 FROM DELETED)
			RETURN;
	
		/*
		  Try the same thing but with a temp table
		*/
		SELECT * INTO #deletedTemp from deleted;

		DECLARE @operationType nvarchar(16) = 'DELETE';		
		

	    -- Has the order been picked for delivery yet?
		IF EXISTS 
		(
			SELECT 1 FROM DELETED d WHERE d.PickingCompletedWhen is not null
		)
		BEGIN
			SET @operationType = 'ATTEMPTED DELETE';
			RAISERROR('The OrderLine has been fulfilled and cannot be deleted',16,1);
			ROLLBACK TRAN;
		END;


	END;

	/*
	  This was an attempted delete that is being logged.  No reason, for now, to store
	  a copy of the data in JSON which could be quite large
	*/
	if exists (select 1 from #deletedTemp) AND (@operationType = 'ATTEMPTED DELETE')
	begin
	    /*
		  Using the Temp table that has the deleted rows
		*/
		INSERT INTO Application.AuditLog 
				([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
			SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','Orders',D1.OrderId, NULL
				FROM #deletedTemp D1;
	end;
	
	/*
	  This is a normal delete, go ahead and take the additional step of saving the
	  row data to a JSON object and saving it in the audit log table
	*/
	if exists (select 1 from #deletedTemp) AND (@operationType = 'DELETE')
	begin
	    /*
		  Using the Temp table that has the deleted rows
		*/
		INSERT INTO Application.AuditLog 
				([ModifiedTime], [ModifiedBy], [Operation], [SchemaName], [TableName], [TableID], [LogData])
			SELECT GETDATE(), SYSTEM_USER, @operationType, 'Sales','Orders',D1.OrderId, D2.LogData
				FROM #deletedTemp D1
				CROSS APPLY (
					SELECT LogData=(select * from #deletedTemp WHERE 
									OrderID = D1.OrderID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
				) AS D2;
	end;
GO

TRUNCATE TABLE Application.AuditLog;
GO

DELETE FROM Sales.Orders WHERE OrderID < 20;
GO

SELECT * FROM Application.AuditLog;
GO

/*
  Insert a new user with the minimum amount of data required
*/
INSERT INTO Application.People (FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee,IsSalesperson, LastEditedBy)
VALUES ('Ryan Booz', 'Ryan',1,'ryan@softwareandbooz.com',0,1,0,0,1);


/*
  Create a temporary table that will old a copy of all users and any
  new users that we want to create (INSERT) or remove (DELETE).

  This will become the SOURCE table of our MERGE below

*/
CREATE TABLE #TempUsers (
	PersonId int,
	FullName nvarchar(50),
	PreferredName nvarchar(50),
	IsPermittedToLogon bit default(1),
	LogonName nvarchar(50),
	IsExternalLogonProvider bit default(0),
	IsSystemUser bit default(1),
	IsEmployee bit default(0),
	IsSalesPerson bit default(0),
	LastEditedBy int default(1)
);


/*
  INSERT all of the users in our current table (which includes my temporary user)
  into the Temporary Table created above
*/
INSERT INTO #TempUsers 
	select PersonId, FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee, IsSalesperson, LastEditedBy from Application.People


/*
  Now insert a new user into the Temporary table that does not exist in the 
  real Application.People table
*/
insert into #TempUsers (FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee,IsSalesperson, LastEditedBy)
VALUES
('Fake Ryan Booz', 'Fake Ryan',1,'fakeryan@softwareandbooz.com',0,1,0,0,1);


/*
  DELETE the original "real" user from the temporary table
*/
delete from #TempUsers where LogonName = 'ryan@softwareandbooz.com';
GO


/*
  Create a sample INSERT, UPDATE, and DELETE Trigger on the 
  People table.  This will allow us to see how the trigger
  is called in different combinations of the MERGE statement.
*/
CREATE OR ALTER TRIGGER Application.TIUD_People
 ON Application.People
 FOR INSERT, UPDATE, DELETE
AS
BEGIN
  DECLARE @TriggerRowCount VARCHAR(100);
  SET @TriggerRowCount = CAST(ROWCOUNT_BIG() AS varchar(100));
  PRINT ' Total Row count reported to Trigger: ' + @TriggerRowCount;
  /*
    Remember that normally we would at least check ROWCOUNT_BIG() to see
	if any rows were modified. As we'll see, we get unexpected results
	of the row count.

    Therefore, we have intentionally left out the usual checks below to prevent work
	so that we can see how many rows each Trigger thinks it would be working
	with if we didn't have additional checks
  */

  IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
  BEGIN
    PRINT ' INSERT Trigger Received Rows';
  END
  IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    PRINT ' UPDATE Trigger Received Rows';
  END
  IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    PRINT ' DELETE Trigger Received Rows';
  END
END
GO

/*
  And now the MERGE Statement itself

  This will:
    - UPDATE all current People where matched (~1112)
	- INSERT one (1) new Person ('fakeryan@softwareandbooz.com')
	- DELETE one (1) Person ('ryan@softwareandbooz.com')

*/
MERGE Application.People WITH (HOLDLOCK) AS Target
USING #TempUsers AS Source
ON Target.PersonId = Source.PersonId
WHEN MATCHED THEN UPDATE SET Target.FullName = Source.FullName
WHEN NOT MATCHED THEN 
	INSERT(FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee,IsSalesperson, LastEditedBy) 
	VALUES(Source.FullName, Source.PreferredName, Source.IsPermittedToLogon, Source.LogonName, Source.IsExternalLogonProvider, Source.IsSystemUser, Source.IsEmployee, Source.IsSalesperson, Source.LastEditedBy)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

/*
  Did we get the results we expected aside from the reported rows?
*/
select * from application.People where logonName = 'ryan@softwareandbooz.com'

select * from application.People where logonName = 'fakeryan@softwareandbooz.com'

/*
  Empty the Temporary table and insert the users again
*/
TRUNCATE TABLE #TempUsers;

INSERT INTO #TempUsers 
	select PersonId, FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee, IsSalesperson, LastEditedBy from Application.People


/*
  Run the MERGE again. Since no users are INSERTED or DELETED,
  what do we expect to see?
*/
MERGE Application.People WITH (HOLDLOCK) AS Target
USING #TempUsers AS Source
ON Target.PersonId = Source.PersonId
WHEN MATCHED THEN UPDATE SET Target.FullName = Source.FullName
WHEN NOT MATCHED THEN 
	INSERT(FullName, PreferredName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, IsSystemUser, IsEmployee,IsSalesperson, LastEditedBy) 
	VALUES(Source.FullName, Source.PreferredName, Source.IsPermittedToLogon, Source.LogonName, Source.IsExternalLogonProvider, Source.IsSystemUser, Source.IsEmployee, Source.IsSalesperson, Source.LastEditedBy)
WHEN NOT MATCHED BY SOURCE THEN DELETE;



/*
  Cleanup
*/
DROP TABLE #TempUsers;

DROP TRIGGER Application.TIUD_People;

DELETE FROM Application.People WHERE logonName = 'ryan@softwareandbooz.com';
DELETE FROM Application.People WHERE logonName = 'fakeryan@softwareandbooz.com';
/*
	Modify a bunch of data
*/

USE [AdventureWorks2014];
GO

UPDATE [Person].[Person]
SET [LastName] = 'Stark'
WHERE [FirstName] = 'Tony';
GO

UPDATE [Person].[Person]
SET [LastName] = 'Stark'
WHERE [FirstName] like 'T%';
GO

UPDATE [Person].[Person]
SET [Title] = 'Mr.'
WHERE [LastName] IN ('Stark');
GO

UPDATE [Person].[Person]
SET [LastName] = 'Wayne'
WHERE [FirstName] like 'Bruce';
GO

UPDATE [Person].[Person]
SET [LastName] = 'Howlett'
WHERE [FirstName] like 'James';
GO

UPDATE [Person].[Person]
SET [LastName] = 'Xavier'
WHERE [FirstName] like 'Charles';
GO

UPDATE [Person].[Person]
SET [LastName] = 'Bristow'
WHERE [FirstName] like 'Sydney';
GO

UPDATE [Person].[Person]
SET [Title] = 'Ms.'
WHERE [LastName] = 'Bristow';
GO

UPDATE [Person].[Person]
SET [Title] = 'Mr.'
WHERE [LastName] IN ('Stark', 'Wayne', 'Howlett', 'Xavier');
GO

UPDATE [Person].[Person]
SET [ModifiedDate] = GETDATE()
WHERE [LastName] IN ('Stark', 'Wayne', 'Howlett', 'Bristow', 'Xavier');
GO

UPDATE [Person].[Person]
SET [ModifiedDate] = GETDATE()
WHERE [PersonType] = 'SC' ;
GO

UPDATE [Person].[Person]
SET [ModifiedDate] = GETDATE()
WHERE [PersonType] <> 'IN' ;
GO


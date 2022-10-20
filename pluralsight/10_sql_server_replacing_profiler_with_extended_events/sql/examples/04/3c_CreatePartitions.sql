/*
	Set up partitioning in the AuntMarjorie
	database and load data into the table
*/
USE [AuntMarjorie];
GO
/* Add filegroups */
ALTER DATABASE [AuntMarjorie]
ADD FILEGROUP [FG2011];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILEGROUP [FG2012];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILEGROUP [FG2013];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILEGROUP [FG2014];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILEGROUP [FG2015];
GO


/* Add files */
ALTER DATABASE [AuntMarjorie]
ADD FILE 
  (NAME = N'2011',
  FILENAME = N'C:\Databases\AuntMarjorie\2011.ndf',
  SIZE = 1MB,
  MAXSIZE = 1024MB,
  FILEGROWTH = 1MB)
TO FILEGROUP [FG2011];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILE 
  (NAME = N'2012',
  FILENAME = N'C:\Databases\AuntMarjorie\2012.ndf',
  SIZE = 1MB,
  MAXSIZE = 1024MB,
  FILEGROWTH = 1MB)
TO FILEGROUP [FG2012];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILE 
  (NAME = N'2013',
  FILENAME = N'C:\Databases\AuntMarjorie\2013.ndf',
  SIZE = 1MB,
  MAXSIZE = 1024MB,
  FILEGROWTH = 1MB)
TO FILEGROUP [FG2013];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILE 
  (NAME = N'2014',
  FILENAME = N'C:\Databases\AuntMarjorie\2014.ndf',
  SIZE = 1MB,
  MAXSIZE = 1024MB,
  FILEGROWTH = 1MB)
TO FILEGROUP [FG2014];
GO

ALTER DATABASE [AuntMarjorie]
ADD FILE 
  (NAME = N'2015',
  FILENAME = N'C:\Databases\AuntMarjorie\2015.ndf',
  SIZE = 1MB,
  MAXSIZE = 1024MB,
  FILEGROWTH = 1MB)
TO FILEGROUP [FG2015];
GO

/* 
	Define the partition function 
*/
CREATE PARTITION FUNCTION [OrderDateRangePFN] (datetime)
AS 
RANGE LEFT FOR VALUES (
            '20111231 23:59:59.997',  --everything in 2011
            '20121231 23:59:59.997',  --everything in 2012
            '20131231 23:59:59.997',  --everything in 2013
            '20141231 23:59:59.997',  --everything in 2014
			'20151231 23:59:59.997'); --everything in 2015
GO

            

/* 
	Create the parition scheme
*/
CREATE PARTITION SCHEME [OrderDateRangePScheme]
AS 
PARTITION [OrderDateRangePFN] TO 
( [FG2011], [FG2012], [FG2013], [FG2014], [FG2015], [PRIMARY] );
GO


/* 
	Create the table 
*/
CREATE TABLE [dbo].[Orders]  
(
   [PurchaseOrderID] [int] NOT NULL,
   [EmployeeID] [int] NULL,
   [VendorID] [int] NULL,
   [TaxAmt] [money] NULL,
   [Freight] [money] NULL,
   [SubTotal] [money] NULL,
   [Status] [tinyint] NOT NULL,
   [RevisionNumber] [tinyint] NULL,
   [ModifiedDate] [datetime] NULL,
   [ShipMethodID]   tinyint NULL,
   [ShipDate] [datetime] NOT NULL, 
   [OrderDate] [datetime] NOT NULL, 
   [TotalDue] [money] NULL
) ON [OrderDateRangePScheme] (OrderDate);
GO

 
/* 
	Load some data 
*/
INSERT [dbo].[Orders]
([PurchaseOrderID] 
         ,[EmployeeID]
         ,[VendorID]
         ,[TaxAmt]
         ,[Freight] 
         ,[SubTotal] 
         ,[Status] 
         ,[RevisionNumber] 
         ,[ModifiedDate] 
         ,[ShipMethodID] 
         ,[ShipDate] 
         ,[OrderDate] 
         ,[TotalDue] )
   SELECT [o].[PurchaseOrderID] 
         , [o].[EmployeeID]
         , [o].[VendorID]
         , [o].[TaxAmt]
         , [o].[Freight] 
         , [o].[SubTotal] 
         , [o].[Status] 
         , [o].[RevisionNumber] 
         , [o].[ModifiedDate] 
         , [o].[ShipMethodID] 
         , [o].[ShipDate] 
         , [o].[OrderDate] 
         , [o].[TotalDue] 
   FROM [Purchasing].[PurchaseOrderHeader] AS [o]
GO

/*
	Add the primary key 
*/
ALTER TABLE [dbo].[Orders] 
ADD CONSTRAINT [OrdersPK] 
	PRIMARY KEY CLUSTERED (
		[OrderDate] ASC,
		[PurchaseOrderID] ASC
	)
	WITH (STATISTICS_INCREMENTAL = ON)
ON [OrderDateRangePScheme] ([OrderDate]);
GO

select orderdate, purchaseorderid, count(*)
from dbo.orders
group by orderdate, purchaseorderid
having count(*) > 1

/*
	Load more data
*/
SET NOCOUNT ON;
DECLARE @Loops SMALLINT = 0;
DECLARE @Increment INT = 5000;

WHILE @Loops < 1000 --adjust this to decrease or increase the number of rows in the table, 1000 = 20 millon rows
	BEGIN
		INSERT [dbo].[Orders]
			([PurchaseOrderID] 
			 ,[EmployeeID]
			 ,[VendorID]
			 ,[TaxAmt]
			 ,[Freight] 
			 ,[SubTotal] 
			 ,[Status] 
			 ,[RevisionNumber] 
			 ,[ModifiedDate] 
			 ,[ShipMethodID] 
			 ,[ShipDate] 
			 ,[OrderDate] 
			 ,[TotalDue] )
	   SELECT [o].[PurchaseOrderID] + @Increment
			 , [o].[EmployeeID]
			 , [o].[VendorID]
			 , [o].[TaxAmt]
			 , [o].[Freight] 
			 , [o].[SubTotal] 
			 , [o].[Status] 
			 , [o].[RevisionNumber] 
			 , [o].[ModifiedDate] 
			 , [o].[ShipMethodID] 
			 , [o].[ShipDate] + 365
			 , [o].[OrderDate] + 365 
			 , [o].[TotalDue] + 365 
	   FROM [Purchasing].[PurchaseOrderHeader] AS [o];
	CHECKPOINT;
	SET @Loops = @Loops + 1;
	SET @Increment = @Increment + 5000;
END

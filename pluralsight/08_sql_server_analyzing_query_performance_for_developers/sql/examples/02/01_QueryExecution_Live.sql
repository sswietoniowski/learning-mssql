/*
	Run a query with nothing enabled
*/
USE [WideWorldImporters];
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO


/*
	Run a query with STATISTICS IO and TIME enabled
*/
USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO
SET STATISTICS TIME ON;
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO



/*
	Run a query with STATISTICS IO and TIME enabled,
	and Actual Execution Plan 
*/
USE [WideWorldImporters];
GO

SET STATISTICS XML ON;
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO

SET STATISTICS XML OFF;
GO


/*
	Run a query with STATISTICS IO and TIME enabled,
	and enable Actual Execution Plan (UI)
*/
USE [WideWorldImporters];
GO

SET STATISTICS IO ON;
GO
SET STATISTICS TIME ON;
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO



/*
	Run a query to get the Estimated Execution Plan (UI)
*/
USE [WideWorldImporters];
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO


/*
	Enable client statistics
*/
USE [WideWorldImporters];
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO


SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [s].[StateProvinceName] LIKE 'O%';
GO

/*
	Enable option to discard results after execution
*/
USE [WideWorldImporters];
GO

SELECT 
	[s].[StateProvinceName], 
	[s].[SalesTerritory], 
	[s].[LatestRecordedPopulation], 
	[s].[StateProvinceCode]
FROM [Application].[Countries] [c]
JOIN [Application].[StateProvinces] [s]
	ON [s].[CountryID] = [c].[CountryID]
WHERE [c].[CountryName] = 'United States';
GO
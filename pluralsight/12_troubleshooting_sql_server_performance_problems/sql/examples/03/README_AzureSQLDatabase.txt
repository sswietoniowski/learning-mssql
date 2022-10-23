========================================================================
Course: Troubleshooting SQL Server Performance Problems
Module: Troubleshooting Performance Problems with Azure SQL Database
========================================================================

Hello!

You are encouraged to try the troubleshooting concepts demonstrated in this module on your own too.
For this, please find the pre-requisites and setup instructions detailed below within this Readme, as well as the T-SQL script files all put together in the Demo_AzureSQLDatabase.zip file.

You can set up the Demo environment including Power BI Desktop and the customer's Power BI Sales Analytics dashboard, but of course, you can work only with the script files directly in SQL Server Management Studio too.

Note: you can set up the environment with on-premises or Azure VM deployments too and compare the behaviors!

Happy troubleshooting!
Regards,

Viktor Suha

========================================================================
Pre-requisites for the database environment
========================================================================
- Azure SQL Database
	-> Standard S3 (100DTU, 5GB maximum database size)

- WideWorldImportersDW data warehouse sample database, Standard .bacpac
	-> Github download: https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bacpac
	-> Documentation
		-> https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers
		-> https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-what-is?view=sql-server-ver15

- SQL Server Management Studio
	-> download latest version from: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15

========================================================================
Pre-requisites for the Power BI client environment
========================================================================
Create the following objects in the WideWorldImportersDW data warehouse sample database to be used by the dashboard:
- [dbo].[ViewPowerBISalesDW] -> ViewPowerBISalesDW.sql
- [dbo].[GetSumQuantityPerStockItemAnchored] -> ScalarUDF_GetSumQuantityPerStockItemAnchored.sql
- [dbo].[udfSalesAnchor] -> InlineTVF_udfSalesAnchor.sql

- Power BI Desktop
	-> download from: https://powerbi.microsoft.com/en-us/desktop/

- Power BI dashboard
	-> WWISalesDWData_v3.pbix

Note: you must change the Power BI dashboard data source connection according to your own setup.

========================================================================
SQL scripts to work with directly in SQL Server Management Studio
========================================================================
NewIndex.sql -> create a new nonclustered index on the Dimension.City table
SQL_CityPopulation_Index_Query.sql -> core City Population query filtering on Latest recorded population
SQL_SalesQuantityAnchored_Query.sql -> core Sales Quantity Anchored query. Play with the different versions and parameters of the inline TVF here.

	

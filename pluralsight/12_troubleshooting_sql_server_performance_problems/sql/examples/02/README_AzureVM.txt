========================================================================
Course: Troubleshooting SQL Server Performance Problems
Module: Troubleshooting Performance Problems with SQL Server on Azure VM
========================================================================

Hello!

You are encouraged to try the troubleshooting concepts demonstrated in this module on your own too.
For this, please find the pre-requisites and setup instructions detailed below within this Readme, as well as the T-SQL script files all put together in the Demo_AzureVM.zip file.

You can set up the Demo environment including Power BI Desktop and the customer's Power BI Sales Analytics dashboard, but of course, you can work only with the script files directly in SQL Server Management Studio too.

Happy troubleshooting!
Regards,

Viktor Suha

========================================================================
Pre-requisites for the database environment
========================================================================
- SQL Server 2019 Developer Edition
	-> install on-premises or on Azure VM: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
	-> free license, Enterprise Edition equivalent

- WideWorldImporters (Full) OLTP sample database
	-> Github download: https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak
	-> Documentation
		-> https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers
		-> https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-what-is?view=sql-server-ver15

- SQL Server Management Studio
	-> download latest version from: https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15

========================================================================
Pre-requisites for the Power BI client environment
========================================================================
Create the following objects in the WideWorldImporters (Full) OLTP sample database to be used by the dashboard:
- [Sales].[ViewPowerBISalesOrdersConsolidated] -> ViewPowerBISalesOrdersConsolidated.sql
- [Warehouse].[ViewPowerBIColdRoomTempHistory] -> ViewPowerBIColdRoomTempHistory.sql
- [Warehouse].[ViewPowerBIColdRoomTempCurrent] -> ViewPowerBIColdRoomTempCurrent.sql

- Power BI Desktop
	-> download from: https://powerbi.microsoft.com/en-us/desktop/

- Power BI dashboard
	-> WWISalesSensorData_v2.pbix

Note: you must change the Power BI dashboard data source connection according to your own setup.

========================================================================
Pre-requisites for simulating the query blocking scenario
========================================================================
- ClientBlockingQuery.sql

- ClientBatch.bat
	-> this is a Windows batch (.bat) file using the command line sqlcmd.exe utility
	-> modify the following code line according to your setup: sqlcmd -S .\<yourSQLinstance> -E -d WideWorldImporters -i "<yourpath>\ClientBlockingQuery.sql"
		-> -S: change to your actual SQL Server 2019 instance
		-> -i: change to the path of your ClientBlockingQuery.sql file executing the blocking workload
		-> -E: using Windows authentication
		-> -d: WideWorldImporters database

Refer to the sqlcmd documentation for full command line option details: https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15

To execute the blocking workload in the ClientBlockingQuery.sql file, run the ClientBatch.bat file from a command line window. 

========================================================================
SQL scripts to work with directly in SQL Server Management Studio
========================================================================
SQL_file_io_stats.sql -> file level IO statistics since last restart of the instance
SQL_health_check.sql  -> some useful DMV queries to check up on system configuration
SQL_RCSI.sql 	      -> check if the WideWorldImporters database has Read Committed Snapshot Isolation (RCSI) enabled
SQL_DMV_counters.sql  -> check the SQL Server cached counters DMV for SQL Server performance counter values, for example Page Life Expectancy
SQL_blocking.sql      -> the sample dashboard workload that was blocked by the update transaction. Use the @@SPID statement to get your actual session_id to play with.
SQL_blocking_troubleshoot.sql -> use your actual session_ids (blocked and blocking) and other ids unique to your particular environment and replace them in the script accordingly

	

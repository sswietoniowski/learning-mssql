/*
	Module5_Demo4A.sql
	These scripts can be used to execute WhoIsActive
	with different options.
	Please download WhoIsActive from:
	http://sqlblog.com/files/default.aspx
*/


/* 
	includes built-in help 
*/
EXEC dbo.sp_WhoIsActive @help=1;


/* 
	execute with no input parameters 
*/
EXEC dbo.sp_WhoIsActive; 


/* 
	specificy sort order 
*/
EXEC dbo.sp_WhoIsActive 
	@sort_order = '[CPU] DESC';


/*	
	can include query plans 
*/
EXEC dbo.sp_WhoIsActive 
	@get_plans = 1;


/* 
	change output order of columns and include the query plan
*/
EXEC dbo.sp_WhoIsActive 
	@get_plans = 1,
	@output_column_list = '[dd%],[session_id],[CPU],[physical_reads],
		[used_memory],[database_name],[login_name],[sql_text],[query_plan]';


/* 
	this creates the statement for the destination table 
*/
DECLARE @schema VARCHAR(max) 
EXEC dbo.sp_WhoIsActive 
	@return_schema=1, 
	@schema=@schema OUTPUT 
SELECT REPLACE(@schema, '<table_name>', 'dbo.WIA_Output' );


/* 
	execute these statements to create the table 
*/

USE [BaselineData];
GO

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'WIA_Output')
	DROP TABLE dbo.WIA_Output;

CREATE TABLE dbo.WIA_Output ( 
	[dd hh:mm:ss.mss] varchar(8000) NULL,
	[session_id] smallint NOT NULL,
	[sql_text] xml NULL,
	[login_name] nvarchar(128) NOT NULL,
	[wait_info] nvarchar(4000) NULL,
	[CPU] varchar(30) NULL,
	[tempdb_allocations] varchar(30) NULL,
	[tempdb_current] varchar(30) NULL,
	[blocking_session_id] smallint NULL,
	[reads] varchar(30) NULL,
	[writes] varchar(30) NULL,
	[physical_reads] varchar(30) NULL,
	[used_memory] varchar(30) NULL,
	[status] varchar(30) NOT NULL,
	[open_tran_count] varchar(30) NULL,
	[percent_complete] varchar(30) NULL,
	[host_name] nvarchar(128) NULL,
	[database_name] nvarchar(128) NULL,
	[program_name] nvarchar(128) NULL,
	[start_time] datetime NOT NULL,
	[login_time] datetime NULL,
	[request_id] int NULL,
	[collection_time] datetime NOT NULL);


/*	
	execute regularly to capture information
*/
EXEC dbo.sp_WhoIsActive 
	@destination_table = 'dbo.WIA_Output';


/* 
	view data 
*/
SELECT * FROM dbo.WIA_Output;


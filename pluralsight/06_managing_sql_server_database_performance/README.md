# Managing SQL Server Database Performance

SQL Server performance problems are real and troubleshooting can be a challenge.
This course will cover what factors affect performance and how to troubleshoot and
optimize performance both on-premise and with Azure SQL Database.

## 1. Aiming for Performance and Scalability

Scenario:

> Please help, I have performance problems!

Architecture:

- database application (client solution, desktop, web-based, mobile),
- workload (T-SQL ad-hoc queries, stored procedures, functions, views),
- database (SQL Server database on-promise on in the cloud).

Six degrees of performance problems:

- workload,
- environment and infrastructure,
- configuration,
- database,
- data,
- operations and maintenance.

Holistic Approach:

- workload,
- database environment.

Layered approach (from the outside):

- environment and infrastructure,
- SQL Server,
- database,
- query.

How to start troubleshooting:

- identify the problem,
- targeted troubleshooting,
- drill-down/top-down,
- choose the layer(s) directly to optimize.
- find entry points,
- follow branches,
- multidisciplinary paths.

> - **Service Level Agreements (SLA)** - a business requirement and/or agreement that our workload must adhere to, e.g., it has to complete in one minute.
> - **Performance** - my queries are running fast enough, always fall within business SLAs, the database application is responsive and my customers are happy with it.
> - **Scalability** - performance under changing constraints, e.g., data size grows, number of concurrent users increases, and peak usage times occur. You must be able to prove it with diagnostic data! It's measurable.

Get data for performance and scalability:

- **monitoring** - measure the environment and your workload, collect data, baseline, set up alerts,
- **diagnostics** - understand the problem, analyze the data, troubleshoot with entry points, plan,
- **optimization** - communicate, involve other disciplines, measure and validate, document.

Aiming for scalability and performance:

- business requirements,
- solution planning,
- usage patterns,
- infrastructure planning,
- SQL Server configuration,
- operations and maintenance.

Usage patterns:

- data growth trends,
- data table sizes,
- data distributions,
- concurrent users and peak times.

Infrastructure planning:

- choose the proper platform and technologies,
- plan with performance and scalability in advance,
- size properly and choose the correct tier.

SQL Server configuration:

- understand and know the platform,
- do regular health-checks,
- adjust configuration when necessary.

Operations and maintenance:

- have ownership of the environment,
- monitor, diagnose and optimize,
- maintain the database environment.

Sample database (_WorldWideImporters_) can be found [here](https://github.com/Microsoft/sql-server-samples/blob/master/samples/databases/wide-world-importers).

SQL Server performance optimization is more like an art.

## 2. Understanding Key SQL Server Concepts

### Major Versions and Compatibility Levels

### Patch Levels and Servicing

### Editions and Best Practices

### Server Instances

### Server Configuration Options

### Database Configuration Options

### Trace Flags

### Tempdb

### Transaction Log and Recovery Models

### Memory Management and SQLOS

### Wait Statistics and the Threading Model

## 3. Optimizing SQL Server Instance and Memory Configuration

### Server Health Check

It is important to have some kind of a server health check repository.

When do you need a server health check?

- after installing SQL Server,
- before going into production,
- regularly as part of operations and maintenance.

What do you verify in a server health check?

- host environment (hardware, OS),
- SQL Server configuration,
- database settings,
- SQL Server ERRORLOG files,
- scheduled jobs,
- custom (something that is specific to a particular environment).

### Memory Settings

Configuration SQL Server memory settings:

- max server memory,
- min server memory,
- lock pages in memory.

Review other server configuration settings:

- optimize for ad hoc workloads,
- max degree of parallelism,
- cost threshold for parallelism.

SQL Server ERRORLOG files.

Buffer pool memory sizing.

SQL Server VM Memory Settings Example:

- VM RAM,
- max server memory,
- VM reserved memory,
- min server memory.

System Data Collection Method Examples:

- system information,
  - method: ERRORLOG files and @@version, sys.dm_os_sys_info, sys.dm_os_schedulers, msinfo32 (Windows)
- errors and exceptions:
  - ERRORLOG files, event logs (Windows),
- memory dumps:
  - sys.dm_server_memory_dumps, ERRORLOG files,
- database corruption:
  - DBCC CHECKDB job failures,
  - msdb..sysjobhistory,
  - msdb..suspect_pages.
- SQL Server performance counters:
  - sys.dm_os_performance_counters,
- wait statistics:
  - sys.dm_os_wait_stats, sys.dm_exec_session_wait_stats,
- database file IO:
  - sys.dm_io_virtual_file_stats,
- system level bottlenecks:
  - ERRORLOG files,
- missing indexes and index usage:
  - sys.dm_db_missing_index_groups, sys.dm_db_missing_index_details, sys.dm_db_index_usage_stats, sys.dm_db_index_group_stats.

### Parallelism Settings

### ERRORLOG Files

## 4. Optimizing Tempdb and User Database File Configuration

Server health check items:

- tempdb file configuration:
  - number of data files,
  - sizing of data files,
- trace flags depending on major version:
  - TF1118,
  - TF1117,
- database instant file initialization,
- file autogrowth settings.

Additional external factors:

- storage configuration and tiers,
- data, transaction log, and tempdb file separation onto different drives/disks,
- drive formatting:
  - 64 KB NTFS allocation unit size,
- antivirus configuration:
  - KB309422 to read for exclusion paths.

### Database File IO

Database IO latency:

- for data files (\*.mdf, \*.ndf) it is OK if < 25 ms,
- for log files (\*.ldf) it is OK if < 5 ms.

Database files on SSD storage:

- use SSD storage for production workloads:
  - average IO latency in the few milliseconds range,
- if otherwise:
  - storage properly configured or tiered,
  - no SQL Server memory pressure,
  - workload is optimized,
  - index usage is optimal,
  - other external factors do not interfere.

Monitoring IO performance:

- windows performance monitor (Perfmon):
  - LogicalDisk object counters,
- SQL Server views:
  - sys.dm_io_virtual_file_stats,
- SQL Server wait statistics:
  - PAGEIOLATCH_SH,
  - PAGEIOLATCH_EX,
  - WRITELOG.

### Instant File Initialization and Tempdb Bottlenecks

Database file zero initialization.

Database instant file initialization:

- no zero initialization on:

  - create,
  - autogrow,
  - restore.

- applies to the data files only:
  - log files are always zeroed,
- perform volume maintenance tasks security policy,
- evaluate security considerations.

Tempdb performance factors:

- IO - read/write the data file(s) and the log file with varying IO sizes,
- internal allocation - SQL Server internal algorithms to allocate objects and manage metadata.

How to measure these tempdb bottlenecks?

- IO - subpar read/write latency values seen with Perfmon and sys.dm_io_virtual_file_stats on tempdb files and disk,
- tempdb contention - PAGELATCH_UP, PAGELATCH_EX wait types, with bad average wait times and wait resources in tempdb.

How to alleviate tempdb IO bottlenecks?

- IO performance:
  - use SSD storage,
  - use multiple tempdb data files,
  - separate tempdb files from all the rest,
  - separate tempdb log files from data files,
  - optimize autogrowth settings,
  - database instant file initialization,
  - optimize workload,
  - resolve memory configuration problems,
- tempdb contention:
  - use SQL2016+,
  - use TF1118 with pre-SQL2016 instances,
  - use multiple tempdb data files,
  - pre-size the tempdb data files,
  - size all data files equally,
  - configure fixed equal autogrow values,
  - use TF1117 with pre-SQL2016 instances,
  - optimize workload.

### Autogrowth Settings

### Tempdb Configuration

## 5. Configuring SQL Server in Azure

### SQL Server in Azure

### SQL Server Virtual Machines

### Creating SQL Server Virtual Machines and Sizing

### Azure SQL Database

### Elastic Pools

### Estimating Service Tiers and Sizes

## 6. Troubleshooting and Baselining the Environment

### Troubleshooting and Baselining in SQL Server

### Wait Statistics in Practice

### IO and CPU Related Wait Type Patterns

### OS, Locking, and Data Page Related Wait Type Patterns

### Wait Statistics Patterns in Troubleshooting

### Wait Statistics Analysis with Custom Query

### IO Performance Troubleshooting with DMVs

### IO Performance Analysis with Custom Query

### Query Store

### Using the Query Store for Query Performance Analysis

### System_health Session Trace

### Using the System_health Session Trace for Troubleshooting

### Perfmon Traces

### Interesting SQL Server Counters

### Page Life Expectancy Patterns

### Using and Analyzing Perfmon Traces

## 7. SQL Server 2019 Improvements

### Database and Server Upgrade

### Versions, Editions, and Patching

### Setup

### Tempdb Improvements

### Query Store Improvements

### Accelerated Database Recovery

### Sequential Key Insert Optimization

### Intelligent Query Processing

### References

## Summary

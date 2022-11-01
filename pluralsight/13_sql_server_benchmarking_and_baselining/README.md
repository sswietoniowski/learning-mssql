# SQL Server: Benchmarking and Baselining

Introduction (a bit old) to the idea of SQL Server benchmarking and baselining.

## 1. Introduction

Where do you begin troubleshooting when there is a problem?

- how do you know there is a problem?
- what changed in the environment?

### What is a Baseline?

Baseline:

- often represents the "normal" or typical state of the environment,
- but it really is a point of reference from which change can be measured,
- not a point in time:
  - data is captured over time and averaged,
- you should have multiple baselines:
  - e.g. business hours, end of month, peak.

### What is a Benchmark?

> A benchmark is a comparison against a baseline.

Benchmarks are utilized to target or reach a specific goal:

- define a goal (_this is your benchmark_),
- measure the current value (_this is your baseline_),
- how does the current value compare to the goal?
- improve the current value in steps (_this is tuning_),
- measure the value again.

### Why Are They Important?

Thanks to benchmarks and baselines, you can:

- understand where the system is today:
  - can help determine where you want to go,
- troubleshooting is easier,
- proactively tune the environment,
- determine usage patterns and trending,
- starting point for growth and capacity planning,
- used to measure the effects of changes:
  - hardware, software, configuration, application code, etc.

### Who Needs to Capture This Information?

There are many people who need to capture this information:

- DBAs,
- developers,
- application administrators,
- server administrators,
- storage administrators,
- network administrators,
- _but only DBA is going to do it for SQL Server in production..._.

## 2. What, When, and Where

Introduction:

- data, data everywhere...,
- how do you know where to start?
  - define your goal,
- determine what data has the most value,
- understand how much data you want to collect and manage.

### The Customer Call - Part 1

Showed during demo.

### Deciding What Data to Capture

Performance Monitor:

- hardware resource counters,
- OS counters,
- SQL Server counters.

SQL Trace and Extended Events:

- queries for analysis or tuning,
- queries for comparison.

DMVs:

- wait statistics,
- file statistics,
- index usage statistics,
- performance counters.

Catalog Views / System Tables:

- SQL Server configuration,
- database and file size,
- maintenance job history.

Application:

- user activity,
- system work,
- batch jobs.

Application-specific, but within SQL Server:

- application schema,
- query plans.

### Deciding When to Capture Data

Some things to consider:

- when vs. how often:
  - when: what time during the day, month, quarter,
  - how often: every 15 seconds, every 5 minutes, every hour, etc.,
- it depends...:
  - business cycle,
  - DBA resources,
  - volatility of the environment,
  - available storage,
- also consider the data retention period:
  - keep for only 60/120/180 days,
  - aggregate older data and store it before purging.

### Deciding How to Store and Retrieve Data

Where to store the data:

- store in a database:
  - custom, user database on a production instance,
  - schedule a regular, daily backup job,
  - size appropriately and ensure enough storage exists,
  - consider the performance impact of this database,
- retrieve using custom queries or code:
  - T-SQL is your friend,
  - SQL Server Reporting Services (SSRS) may become your new friend,
  - develop an external application or website.

## 3. Performance Monitor

Performance Monitor is built in to Windows.

It can be used to monitor performance real-time or capture metrics over a period of time.

Hardware, OS and SQL Server counters can be captured.

Data collection can be automated.

Data can be processed manually or automatically.

### Performance Monitor Pros, Cons, and Overhead

Pros:

- uses functionality built into Windows,
- capture OS, resource and SQL Server counters,
- process can be automated,
- data can be retrieved using T-SQL.

Cons:

- setup and execution is outside of SQL Server,
- manual adjustment may be needed for each server.

Overhead:

- resource usage is minimal if sampling interval is greater than every 1 second,
- hard disk usage and performance based on number of counters, interval and underlying storage.

### Use Performance Monitor When

Main use cases:

- you want to look at current system performance,
- you need to collect OS and hardware resource counters, as well as SQL Server counters, over time,
- you want to capture metrics to demonstrate a performance gain (or loss) based on a change,
- analysis using Performance Analysis of Logs (PAL) is appropriate.

### Using Performance Monitor in Real-Time

Be aware of the following:

- only the last 100 seconds of data are shown by default:
  - not useful for historical analysis or trending,
- there are multiple views of real-time performance data available,
- there are many settings you can tweak to change the display of information:
  - most of them are not necessary for real-time monitoring.

### Performance Monitor

Showed during demo.

### Counters to Capture

[This](https://www.sentryone.com/blog/allenwhite/sql-server-performance-counters-to-monitor) article shows a list of counters to capture.

### OS/Resource Counters to Capture

Counters to capture:

- Processor - % Processor Time,
- Processor - % Privileged Time,
- Process (sqlservr) - % Processor Time,
- Process (sqlservr) - % Privileged Time,
- System - Processor Queue Length,
- Memory - Available Mbytes,
- Memory - Pages/sec,
- Paging File - % Usage,
- Physical Disk - Avg Disk sec/Read,
- Physical Disk - Avg Disk sec/Write,
- Physical Disk - Disk Reads/sec,
- Physical Disk - Disk Writes/sec.

### SQL Server Counters to Capture

Counters to capture:

- SQL Server: Access Methods - Forwarded Records/sec,
- SQL Server: Access Methods - Full Scans/sec,
- SQL Server: Access Methods - Index Searches/sec,
- SQL Server: Buffer Manager - Free List Stalls/sec,
- SQL Server: Buffer Manager - Lazy Writes/sec,
- SQL Server: Buffer Manager - Page Life Expectancy,
- SQL Server: Buffer Manager - Page Reads/sec,
- SQL Server: Buffer Manager - Page Writes/sec,
- SQL Server: Memory Manager - Total Server Memory (KB),
- SQL Server: Memory Manager - Target Server Memory (KB),
- SQL Server: SQL Statistics - Batch Requests/sec,
- SQL Server: SQL Statistics - SQL Compilations/sec,
- SQL Server: SQL Statistics - SQL Recompilations/sec,
- SQL Server: General Statistics - User Connections,
- SQL Server: Latches - Latch Waits/sec,
- SQL Server: Locks - Lock Wait/sec,
- SQL Server: Locks - Number of Deadlocks/sec.

### Counter Collection

Your goals:

- determine:
  - the counters you want to capture,
  - the interval at which you will capture the counters,
  - the time period and duration for which you will capture the counters,
- be consistent.

### Data Collector Sets

Main purposes:

- collector set allow for a repeated use:
  - user-defined vs. system,
  - can be exported/imported between servers,
- collector sets can be started manually, via the built-in scheduler or via command line with logman:
  - logman is available in Windows Server 2003+,
- can be used to automate data collection as a result of a specific event or alert.

### Processing Performance Monitor Data

You can do that:

- manually:
  - Excel:
    - not recommended,
- database:
  - manual import,
  - relog,
- Performance Analysis of Logs (PAL):
  - free utility available for download from [here](https://github.com/clinthuffman/PAL),
  - analyzes PerfMon data based on thresholds within templates which are customizable,
  - GUI interface which creates HTML output with metrics and graphs,
  - requires Chart Controls for .NET 3.5.

### relog

Showed during demo.

### PAL

Showed during demo.

## 4. Capturing Queries

It is much easier to baseline performance in terms of numbers rather than in terms of query performance.

However, the performance of individual queries is what ultimately uses the available resources we monitor so carefully.

It is possible to compare performance of a query or set of queries but it is a two-part process:

- query capture,
- query analysis.

Query capture can be done using SQL Trace, Extended Events and DMVs:

- DMVs will be covered in the next chapter.

Query analysis involves SQL Server Profiler, XML and third-party utilities.

### SQL Trace

What is it?

- low-level, server-side event implementation in SQL Server,
- SQL Trace has existed since SQL Server 6.x:
  - deprecated in SQL Server 2012,
- SQL Trace captures information in real time, when enabled,
- in order to capture queries must set up a trace or use Profiler:
  - traces can be started manually or as part of a scheduled job,
  - Profiler provides a graphical use interface for tracing and low-level analysis,
- performance overhead can be introduced when capturing information, depending on trace configuration.

### Extended Events

What is it?

- light-weight server-side event implementation in SQL Server,
- Extended Events are available in SQL Server 2008+:
  - GUI introduced in SQL Server 2012,
- Extended Events captures information in real-time when enabled,
- in order to capture queries must set up an event session,
- event sessions can be started manually or as part of a scheduled job,
- performance overhead can be introduced when capturing information, depending on event session configuration,
- analysis of Extended Events can be performed using the GUI or by programmatic interpretation of the event XML.

### When to Use SQL Trace vs. Extended Events

We should use SQL Trace and Extended Events when:

- if the information needed cannot be obtained through DMO,
- as a proactive step when troubleshooting, rather than waiting for the issue to occur again.

Use SQL Trace:

- when performance tuning code or during integration testing,
- if you need to capture a replay workload (Profiler, Distributed Replay),
- if you want to use any third-party tool to analyze data.

Use Extended Events:

- to capture performance counters previously only available in PerfMon (SQL Server 2012+).

In general Extended Events are more powerful than SQL Trace, but for benchmarking and baselining purposes SQL Trace is sufficient.

Prior to SQL Server 2012:

- not all events from SQL Trace exist in Extended Events,
- the sql_text captured in Extended Events is not the same as Statement Text.

### Clear Trace

What is it?

- free utility available [here](https://www.scalesql.com/cleartrace/),
- ad-hoc workloads are normalized:
  - output includes total and averaged values for CPU, reads, writes and duration for queries,
- queries can be grouped by ApplicationName, LoginName, HostName and/or TextData,
- allows you to:
  - determine what query, application, user, etc. is using the most resources,
  - determine how frequently a query or stored procedure is executed.

### ReadTrace

What is it?

- free utility within RML Utilities, which is developed by Microsoft and used by the SQL Server support team, available [here](https://www.microsoft.com/en-us/download/details.aspx?id=103126),
- ad-hoc workloads are normalized:
  - output includes total and averaged values for CPU, reads, writes and duration for queries,
- queries can be grouped by ApplicationName, LoginName and/or TextData,
- use with Reporter tool to review data in graphical format,
- allows you to:
  - determine what query, application, user, etc. is using the most resources,
  - review individual queries and execution plans,
  - determine how frequently a query or stored procedure is executed,
  - compare two trace files.

### Benefits of Clear Trace vs. ReadTrace

Main differences:

- Clear Trace:
  - free,
  - no installation, configuration is straight-forward,
  - GUI makes it easier to utilize and navigate initially,
- ReadTrace:
  - as part of RML Utilities, additional utilities are installed which may be of value (e.g. Ostress),
  - command-line utility, usage is not intuitive,
  - provides the ability to compare two traces,
  - gives more information overall,
  - provides graphical output which can be used for reporting.

### Replaying Workloads

Options:

- Profiler:
  - replay available for SQL Server 2005+,
  - replay can only be performed with one client,
- RML Ostress:
  - replay available for SQL Server 2005+,
  - can replay a workload across multiple clients,
- Distributed Replay:
  - added in SQL Server 2012,
  - replay available for SQL Server 2008+,
  - can replay a workload across multiple clients (maximum clients = 16 in Enterprise Edition).

## 5. Using DMVs

### When to Use DMVs

### Capturing DMV Data

### DMVs to Consider for Data Capture

### sys.dm_os_performance_counters

### sys.dm_io_virtual_file_stats

### Other Data You Can Capture

### sys.configurations

### WhoIsActive

## 6. Pulling It All Together

### Before You Start

### Data Options

### Next Steps

## Summary

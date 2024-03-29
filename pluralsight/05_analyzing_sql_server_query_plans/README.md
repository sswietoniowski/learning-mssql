# Analyzing SQL Server Query Plans

Introduction to SQL Server Query Plans

## 1. Capture Query Plans Using Extended Events and Traces

To diagnose performance issues, you need to capture query plans. In this module, you will learn how to capture query plans using Extended Events and Traces.

### What is a Query Plan?

> A query plan (or query execution plan) is an ordered set of steps used to access data in a SQL relational management system.

SQL language is declarative and thus there are many ways to execute our queries.

SQL Server uses a query plan to determine the best way to execute a query. The query plan is a set of steps that SQL Server uses to access data in the database. The query plan is generated by the query optimizer. The query optimizer is a component of SQL Server that determines the best way to execute a query. The query optimizer uses statistics and other information to determine the best way to execute a query. The query optimizer uses the query plan to determine the best way to execute a query.

### Query Execution Plan Stages

Query execution plan stages:

1. **query parsing**,
2. **query optimization**,
3. **query execution**,
4. **query plan cached**.

### Why Analyze Query Plans?

Main reasons to analyze query plans:

1. identify expensive operators,
2. understand the data flow,
3. diagnose blocking operators,
4. determine state of statistics,
5. classify resource consumption.

Short answer:

> To identify root cause of our poor performance we must analyze query plans.

In SSMS we can have three different ways to see execution plans:

- graphical view (default, enabled by `^M`),
- textual view (to see it we must use `SET STATISTICS PROFILE ON`),
- XML view (to see it we must use `SET STATISTICS XML ON`).

### How to Analyze Query Plans?

To analyze query plans we can use:

- SQL Profiler (old and famous),
- SQL Trace (deprecated),
- Extended Events (new and powerful),
- Query Store (new and powerful).

### What is SQL Profiler?

> SQL Profiler is graphical user interface to SQL Trace to monitor various events running on a SQL Server instance.

SQL Profiler is resource intensive and it is not recommended to use it in production environment.

SQL traces gather events at the instance level and report them efficiently to users. SQL Profiler can create traces. SQL traces were great until MS decided to deprecated them.

### What are Extended Events?

Extended Events are a new feature in SQL Server 2008. Extended Events are a lightweight monitoring
tool which collects data about inner operations of SQL Server and helps troubleshoot performance
problems.

Compared to SQL Profiler, Extended Events are:

- lightweight on resources,
- extensive server events,
- portable.

## 2. Identify Poorly Performing Query Plan Operators

We know how to gather query plans, now its time to analyze them. In this module, you will learn how to identify poorly performing query plan operators.

### What is a Query Execution Plan?

> A query execution plan is a visual representation of operations performed by SQL Server
> engine to return the valid data for the query.

### Interpreting Execution Plans

While interpreting a query plan:

- read it from right to left,
- look at operators' costs,
- see the data flow,
- look for warnings,
- look for suggestions/hints,
- query cost in batch.

Also add to the picture:

- statistics IO,
- statistics TIME.

### Slow Performing Operators

Main operators that we should look for are:

1. **Table Scan** - not bad per se, but we would rather want to see a **Seek** operator,
2. **Index Scan** - same as above,
3. **Parallelism** - again, not bad per se, but why we need to process so much data in parallel?
4. **Sort** - we should avoid sorting if possible, but sometimes it is necessary, it is possible that sorting is added just for merging data, also we should look for **Sort Spill** operator,
5. **Implicit Conversion** - we should avoid situations in which that problem can happen because that would prevent optimizer from using indexes efficiently.

## 3. Create Efficient Query Plans Using Query Store

Query Store is a new feature in SQL Server 2016 that helps us to create efficient query plans. In this module, you will learn how to create efficient query plans using Query Store.

### What is a Query Store?

A query store tracks query plans, statistics and historical data to help diagnose performance degradation of the queries over time.

Query store:

- database level feature,
- available in all editions,
- helps find performance regression,
- identify resource intensive queries,
- query plan and execution history,
- forcing query plans.

### Query Store Setup & Configuration

To configure query store we need to:

1. enable query store,
2. configure query store retention,
3. configure query store max size.

To verify that query store is enabled we can use:

```sql
SELECT name, is_query_store_on
FROM sys.databases
```

### 3 Important Query Stores

There are three important query stores:

1. **plan store** - stores query plans,
2. **runtime stats store** - stores runtime statistics,
3. **wait stats store** - stores wait stats data.

### Query Store Reports

There are many reports that we can use to analyze query store data:

- regressed queries,
- overall resource consumption,
- top resource consuming queries,
- queries with forced plan,
- queries with high variation,
- query wait statistics,
- tracked queries.

### Resolving Parameter Sniffing with Query Store

We can use query store reports to discover that certain query has very different execution stats due to parameter sniffing.

> Parameter sniffing is a problem that occurs when a query plan is generated for a specific set of parameters and then the same query is executed with different parameters.

Problem statement:

> How to get optimal performance from a query at all the time with all the parameters?

We can use query store to force a query plan for a specific set of parameters.

## 4. Compare Estimated and Actual Query Plans and Related Metadata

We need to know the difference between estimated and actual query plans. In this module, you will learn how to compare estimated and actual query plans and related metadata.

### What is an Estimated Execution Plan?

> The most probable plan the engine is likely to use when SQL Server generates an execution plan without running an actual query and display.

An estimated execution plan is a plan that is generated by the query optimizer. The query optimizer uses statistics and other information to determine the best way to execute a query.

Estimated execution plan:

- is quicker,
- no need to run actual query,
- no execution data,
- no available resource consideration,
- to enable it use `^L` in SSMS,
- alternative to `SET SHOWPLAN_ALL ON` or `SET SHOWPLAN_XML ON`.

### What is and Actual Execution Plan?

> When SQL Server generates an execution plan running an actual query, considering available resources.

Actual execution plan:

- visible after query is executed,
- contains actual execution data,
- consider available resources,
- to enable it use `^M` in SSMS,
- alternative to `SET STATISTICS PROFILE ON` or `SET STATISTICS XML ON`.

### What is Live Query Statistics?

> The live query statistics displays the real-time insights into the query execution process as well as control flows of the operator.

### Analyze Execution Plan

To analyze execution plan we can use in SSMS:

- show plan analysis,
- compare show plan,
- find node.

## 5. Configure Azure SQL Database Performance Insight

It is possible to configure Azure SQL Database Performance Insight. In this module, you will learn how to do that.

### Query Performance Insight

> Query Performance Insight is a feature of Azure SQL Database that helps us to identify and resolve performance issues.

Query performance insight provides deeper understanding of the database resource consumption and
details on inefficient queries.

Query performance insight provides:

- DTU consumption ($$$),
- top queries by CPU, duration, execution,
- history of resource utilization,
- performance recommendations,
- requires Query Store.

### Going Beyond Query Plans on Azure

You can configure:

- automatic tuning,
- intelligent insights,
- Azure SQL Analytics.

## Summary

In this course, you learned how to analyze query plans. You learned how to identify poorly performing query plan operators. You learned how to create efficient query plans using Query Store. You learned how to compare estimated and actual query plans and related metadata. You learned how to configure Azure SQL Database Performance Insight.

> When there is a SQL Server **performance issue**, our primary is to find the **root cause** of the slowness.

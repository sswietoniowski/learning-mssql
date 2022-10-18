# SQL Server: Analyzing Query Performance for Developers

Introduction to analyzing query performance for developers.

## 1. Introduction

Developer's responsibilities:

- write code,
- fix code (write more code).

A developer's work doesn't end when the code is written. The code must be maintained and optimized.

### Why We Need to Understand Query Execution?

T-SQL is declarative.

We need to understand what decisions were made by SQL Server:

- every query has a query plan generated,
- every query has execution metrics.

### Course Objectives

> Explain what information can be captured about a query and its execution from SQL Server.

That includes:

- query execution metrics,
- using performance metrics,
- query text and plan.

> Provide an understanding of where to find information about query execution and what it means.

Methods to capture information about query execution and performance interpreting query metrics.

> Step through an execution plan and the information it provides.

That includes:

- how to read a query plan,
- how to find information in a plan,
- discuss what's not important in a plan.

> Understand the information included in a query plan.

Examine the most frequently-seen operators in a query plan.

Examine how changes to a plan can affect query performance.

Demonstrate additional, valuable information found within query plans.

## 2. Finding Information About Queries

### Introduction and Information About Queries

Information we can find about query execution:

- query text,
- query plan,
- execution statistics.

Information generated by query execution:

- can be viewed "live",
- "stored" information can be retrieved and reviewed.

Data from SSMS:

- I/O, CPU, duration,
- actual plan,
- estimated plan.

### Viewing "Live" Query Execution Data

Showed during demo.

### Finding Query Execution Data

Finding query execution data:

- SSMS,
- extended events,
- DMOs,
- Query Store,
- Performance Monitor.

### Query Information from Extended Events

Extended Events worth using:

- `sql_statement_completed`,
- `sp_statement_completed`,
- `rpc_completed`,
- `sql_batch_completed`.

Extended Events that should be avoided:

- `query_post_compilation_showplan`,
- `query_post_execution_showplan`,
- `query_pre_execution_showplan`.

### Query Execution Data in DMOs

DMOs worth using (detailed):

- `sys.dm_exec_sql_text`,
- `sys.dm_exec_query_plan`,
- `sys.dm_exec_cached_plans`,
- `sys.dm_exec_text_query_plan`

DMOs worth using (summary):

- `sys.dm_exec_query_stats`,
- `sys.dm_exec_function_stats`.

### Query Store

Query Store:

- captures query text,
- captures query plan,
- captures runtime statistics.

### Query Metrics From Performance Monitor

Performance Monitor:

- CPU,
- memory,
- physical disk,
- access methods,
- locks,
- SQL statistics.

### A Note About Estimated and Actual Plans

| Estimated                                                                | Actual                                                  |
| ------------------------------------------------------------------------ | ------------------------------------------------------- |
| Contains estimates only                                                  | Contains estimates and actual values                    |
| Estimates are based on values use for the _first_ execution of the query | Actuals based on input values used for _that_ execution |
| SSMS, XE/trace, plan cache                                               | SSMS, XE/trace                                          |
| -                                                                        | May be different than the estimated plan                |

## 3. Understanding Query Performance Metrics

Examine query resource use and execution duration in detail:

- source for data,
- how to use it for troubleshooting and comparing performance.

### Query Metrics of Interest

You might be interested in:

- duration,
- CPU,
- I/O,
- memory.

### SSMS, Extended Events, DMOs, and Query Store

SSMS:

- information for the execution of one query,
- client statistics have limitations,
- returning results to the UI incurs overhead,
- output must be saved.

Extended Events:

- data for an individual query or batch,
- only selected data is collected, based on the capture duration and predicates,
- data can be saved,
- aggregation must be done post-collection.

Dynamic Management Objects (DMOs):

- data is an aggregation from the time the plan entered the plan cache,
- data is lost when the plan leaves the cache or when the instance is restarted.

Query Store:

- SQL Server aggregates query execution data for a plan across user-defined time intervals.

### Viewing and Interpreting Query Execution Data

Showed during demo.

## 4. Reading Query Plans

### What is a Plan?

A plan is a set of instructions that SQL Server uses to execute a query:

- SQL Server Optimizer,
- logical operations transformed to physical operations,
- query plan.

### What's in a Plan and What's Not in a Plan

Cost _used_ to equate to elapsed time in seconds required to run on a specific Microsoft employee's machine.

"_Cost_" today in the context of query plans is a unit-less measure.

Cost is _always_ an estimate.

What is not in a plan?

- query duration,
- I/O information\*,
- locks,
- wait statistics,
- actual cost.

> Unless you capture the actual execution plan, the numbers you see in a plan are estimates.

### Reading Plans

Control flow starts at the root operator.

Data flow starts at the leaf level.

### How to Start Looking at a Query Plan

How do you find information in a plan?

- graphical plan,
- XML plan,
- Plan Explorer.

## 5. Operators in a Query Plan

### Introduction and What Do You Look for in a Plan?

### Scans and Seeks

### Data Access Operators

### Nested Loop and Lookups

### Merge Join and Sort

### Hash Join

### Compute Scalar

## 6. Important Information in a Plan

### Introduction and Input Parameters

### Finding Input Parameters in a Plan

### Trace Flags in a Query Plan

### Cardinality Estimator Version and Issues

### Examining CE Version and Estimates

### Execution Statistics for Operators

### Parallelism in Plans

### Seek and Residual Predicates

### Generating Plan Warnings

## Summary

---
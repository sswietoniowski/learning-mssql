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

### Memory Settings

### Parallelism Settings

### ERRORLOG Files

## 4. Optimizing Tempdb and User Database File Configuration

### Database File IO

### Instant File Initialization and Tempdb Bottlenecks

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

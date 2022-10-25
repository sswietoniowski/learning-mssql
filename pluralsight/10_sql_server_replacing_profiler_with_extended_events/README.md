# SQL Server: Replacing Profiler with Extended Events

Introduction to using Extended Events instead of Profiler.

## 1. Introduction

SQL Trace was introduced in SQL Server 6.5 as a graphical tool.

SQL Profiler was introduced in SQL Server 7.0.

### SQL Trace/Profiler, Example Uses, and Why it's Time to Move On

Basic uses of trace:

- providing real-time insight into SQL Server activity,
- capturing of queries and their resource usage,
- auditing of user activity,
- capture a baseline or replaying a workload,
- most frequently used for troubleshooting performance issues and errors.

Why do we have to stop using Trace and Profiler?

### Comparing Functionality and Why We Avoid Extended Events

| Trace/Profiler                     | Extended Events                                     |
| ---------------------------------- | --------------------------------------------------- |
| Capture query information          | Capture query information                           |
| Choose which fields to capture     | Choose which fields to capture                      |
| Filter on different fields         | Filter on different fields                          |
| Multiple options for data analysis | Multiple options for data analysis                  |
| -                                  | Provide multiple options for data collction         |
| -                                  | Flexible in implementation and configuration        |
| -                                  | Only method for tracing **new** SQL Server features |

Why do we avoid extended events?

- one reason: **change**.

### Extended Events and Example Uses

Advanced event collection infrastructure introduced in SQL Server 2008 and provided by SQLOS.

Highly-flexible implementation which allows complex configurations for event collection that simplify problem identification.

What is Extended Events, really?

- it's a _general event-handling system for server systems_,
- _the Extended Events infrastructure supports the correlation of data from SQL Server_,
- an infrastructure which provides the ability to create complex sessions to collect event information.

Examples of troubleshooting options available in Extended Events:

- identifying stored procedures that exceed a prior maximum,
- capturing first N executions of an event,
- finding accumulated effect of queries using query_hash,
- identifying statement timeouts/attention events.

## 2. Transitioning from Profiler’s UI to Extended Events

### Introduction, the Extended Events Engine, and its Objects

### Making the Leap from Profiler Trace to Extended Events

### Events and Event Comparison

### Event Changes by Version and Considerations for Events

### Predicates and Considerations for Predicates

### Actions and Considerations for Actions

### Targets and Considerations for Targets

### The Big Picture

### Event Session Options

## 3. Leveraging the Extended Events UI

### New Session Wizard, New Session, and Templates

### Event Session Creation and Output Analysis in the UI

### Live Data Viewer, Customize Columns, Grouping and Aggregation

### Expanding a Grouping and Filtering

### Merging Files, Bookmarking Events

## 4. Understanding Target Options for Extended Events

### Introduction and Target Basics

### Event Dispatching and Revisiting the Big Picture

### Event File, Event Counter, and Histogram Targets

### Tracking Database File Growth Using the Histogram Target

### Event Pairing and Ring Buffer Targets

### Using the Ring Buffer Target

## 5. Avoiding Performance Issues with Extended Events

### Introduction and General Performance Considerations

### Create Good Predicates

### Code Examples of Good and Bad Predicates

### Action Overhead and Limit Setting

### Ignoring the Warnings

### Extended Events Pros and Cons

## Summary

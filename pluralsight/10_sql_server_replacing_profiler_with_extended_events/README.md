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

Extended Events Engine:

- Database Engine -> SQLOS -> Extended Events Engine -> Packages

> The Extended Events Engine is a collection of services and objects that it manages and is an interaction point for other SQL Server processes.

### Making the Leap from Profiler Trace to Extended Events

We need to understand some terminology to start with Extended Events.

### Events and Event Comparison

> An event corresponds to a well-known point in the code.

Events (some examples):

- Data File Auto Grow,
- Sort Warning,
- Object: Created,
- SP: StmtCompleted,
- Lock: Acquired,
- SQL: StmtRecompile,
- Deadlock Graph.

Event comparison:

| Trace               | Extended Events              |
| ------------------- | ---------------------------- |
| SP: StmtCompleted   | sp_statement_completed       |
| SQL: StmtRecompile  | sp_statement_recompile       |
| Data File Auto Grow | database_file_size_changed\* |
| Deadlock Graph      | xml_deadlock_report          |
| Audit Login         | ~~login~~                    |

### Event Changes by Version and Considerations for Events

The number of XE events increased greatly over time (from 253 in MSSQL 2008 to 1303 in MSSQL 2016).

> Events have a default payload - a set of data elements that are always returned by an event and cannot be altered\*.

### Predicates and Considerations for Predicates

Predicates:

- a predicate is a filter,
- predicates support short-circuit evaluation,
- predicates can operate on event payload data or global predicate source.

> If you filter on an element that is not part of the default payload, the Engine has to first collect that information before it can perform predicate evaluation.

### Actions and Considerations for Actions

Actions:

- an action is an additional operation performed when the event fires:
  - _collect_ the database ID,
  - _collect_ the session ID,
  - _create_ a mini dump for the current thread,
- an action executes _only_ when the event fires, therefore the predicate must evaluate to true first.

> Think carefully about what actions are really necessary and relevant. Some actions have serious side effects. Other actions can have high overhead based on the event and how frequently it fires.

### Targets and Considerations for Targets

Targets:

- targets consume the events and they store the data in either raw or aggregated format,
- different targets:
  - event file,
  - ring buffer,
  - event counter,
  - histogram,
  - event pairing,
  - event tracing for Windows.

> Only the event file target stores data permanently. All other targets are memory-resident and only store data while the event session is running.

### The Big Picture

1. Event encountered if IsEnabled = True, continue in collection mode.
2. Collect payload data.
3. Perform predicate evaluation.
4. If true, event fires (publish).
5. Execute actions to collect additional data.
6. Serve data to synchronous targets.
7. Buffer event data to memory buffers (specific to event session).
8. Dispatch event data to target (buffers filled or dispatch latency reached).

### Event Session Options

General options:

- `STARTUP_STATE` - starts the event session automatically,
- `TRACK_CAUSALITY` - attachesas GUID and sequence number to events.

Advanced options:

- `EVENT_RETENTION_MODE` - determines the level of event loss,
- `MAX_DISPATCH_LATENCY` - affects how quickly events get to the target,
- `MAX_MEMORY` - not the actual maximum memory for the event session,
- `MEMORY_PARTITION_MODE` - determines the number of memory buffers for the event session,
- `MAX_EVENT_SIZE` - based on event definitions.

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

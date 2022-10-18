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

### Viewing "Live" Query Execution Data

### Finding Query Execution Data and Extended Events

### Query Information from Extended Events

### Dynamic Management Objects

### Query Execution Data in DMOs

### Query Store and Performance Monitor

### Query Metrics From Performance Monitor

### A Note About Estimated and Actual Plans

## 3. Understanding Query Performance Metrics

### Introduction and Query Metrics of Interest

### SSMS, Extended Events, DMOs, and Query Store

### Viewing and Interpreting Query Execution Data

## 4. Reading Query Plans

### Introduction and What is a Plan?

### What's in a Plan and What's Not in a Plan

### Reading Plans

### How to Start Looking at a Query Plan

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

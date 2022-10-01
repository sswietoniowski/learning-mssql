# Designing and Implementing SQL Server Database Indexes

Introduction to SQL Server Database Indexes.

## 1. General Indexing Guidelines

Why do we create indexes?

> Most of the time, we create indexes to improve the performance of our queries. We can also create indexes to enforce uniqueness, to enforce referential integrity, and to improve the performance of data modification operations.

In general, we might say that we're doing so:

1. to improve query performance,
2. to enforce data constraints (uniqueness).

> Indexes created for performance are determined by the workload! We need to understand the workload to determine the best indexes and be ready to change them as the workload changes.

When indexing a new system:

1. create indexes to support unique requirements,
2. create indexes on foreign key columns,
3. create indexes to support expected common queries,
4. be prepared to change indexes later!

When indexing an existing system:

1. identify the most resource-intensive queries,
2. identify the most important queries,
3. index to support them (not all of them but some of them - 5 is a good starting number),
4. re-investigate regularly!

## 2. Understanding Basic Index Architecture and Index Usage

## 3. Designing Indexes to Organize Tables

## 4. Designing Indexes to Improve Query Performance: Part 1

## 5. Designing Indexes to Improve Query Performance: Part 2

## 6. Designing Indexed Views

## 7. Designing Columnstore Indexes for Analytic Queries

## Summary

Now you know how to design and implement SQL Server database indexes :-).

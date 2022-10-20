# SQL Server: Replacing Profiler with Extended Events

Introduction to using Extended Events instead of Profiler.

## 1. Introduction

### SQL Trace/Profiler, Example Uses, and Why it's Time to Move On

### Comparing Functionality and Why We Avoid Extended Events

### Extended Events and Example Uses

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

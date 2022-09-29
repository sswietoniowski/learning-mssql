# Designing and Implementing SQL Server Tables and Views

Introduction to SQL Server Tables and Views.

## Introducing Tables and Views

Some definitions can be found [here](definitions.md) :-).

Relational databases are made up of tables and views. Tables are used to store data. Views are used to retrieve data. Views are also used to restrict access to data. Views can be used to hide sensitive data from users. Views can also be used to combine data from multiple tables. Tables are related to each other through relationships.

E.F. Codd, the father of relational databases. He is credited with inventing the relational database model.

Some terminology:

- relation == table,
- tuple == row,
- attribute == column,
- RDBMS == relational database management system.

### _Bob's Shoes_

Problem description (for which we will create a database):

_Bob has a factory that produces shoes, he needs a database to store information about his shoes, customers, orders, etc._

We need to store:

- customer information,
- order information,
- shoe information.

### Creating Identifiers

Regular identifiers:

- starts with: letter, underscore, at sign (@) (!use :-)), number sign (#) (!use :-)),
- then: letters, digits, @, $, #, \_,
- not a reserved word,
- not a special character,
- identifier delimited with square brackets ([]) can break all the rules above,
- no longer than 128 characters.

Valid identifiers:

orders, product_name, [Order Details], ...

### Using Naming Conventions

Do not use @ or # (used for objects in tempdb) as the first character.

Use consistent style for naming objects, for example:

- Pascal Case: OrderDetails,
- Underscore separated: order_details,
- don't use delimited identifiers: [Order Details].

### Using Character Data Types

### Using Integer Types

### Using Decimal Types

### Using Date and Time Types

### Using Collations

## Designing and Implementing Tables

To create a database use [01_create_database.sql](01_create_database.sql).

## Improving Table Design Through Normalization

## Ensuring Data Integrity with Constraints

## Designing View to Meet Business Requirements

## Implementing Indexed Views

## Implementing Partitioned Views

## Summary

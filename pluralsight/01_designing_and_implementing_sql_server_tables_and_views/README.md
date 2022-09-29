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

## Designing and Implementing Tables

To create a database use [01_create_database.sql](01_create_database.sql).

To create sample tables use [02_create_tables.sql](02_create_tables.sql).

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

There are two types of character data types:

- fixed length: char, nchar, binary,
- variable length: varchar, nvarchar, varbinary.

char(n) - fixed length non-unicode characters, n is the length of the string (1 <= n <= 8000).

nchar(n) - fixed length unicode characters, n is the length of the string (1 <= n <= 4000).

varchar(n) - variable length non-unicode characters, n is the maximum length of the string (1 <= n <= 8000).

nvarchar(n) - variable length unicode characters, n is the maximum length of the string (1 <= n <= 4000).

binary(n) - fixed length binary data, n is the length of the string (1 <= n <= 8000).

varbinary(n) - variable length binary data, n is the maximum length of the string (1 <= n <= 4000).

varchar(max) - variable length non-unicode characters, maximum length of the string is 2GB.

nvarchar(max) - variable length unicode characters, maximum length of the string is 1GB.

binary(max) - variable length binary data, maximum length of the string is 2GB.

varbinary(max) - variable length binary data, maximum length of the string is 1GB.

### Using Integer and Decimal Data Types

There are two types of integer data types:

- integer: tinyint, smallint, int, bigint,
- float: real, float,
- decimal: decimal, numeric, smallmoney, money.

tinyint - 1 byte, 0 to 255.

smallint - 2 bytes, -32,768 to 32,767.

int - 4 bytes, -2,147,483,648 to 2,147,483,647.

bigint - 8 bytes, -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807.

real - 4 bytes, -3.40E + 38 to -1.18E - 38, 0, and 1.18E - 38 to 3.40E + 38.

float - 8 bytes, -1.79E + 308 to -2.23E - 308, 0, and 2.23E - 308 to 1.79E + 308.

decimal(p, s) - 5 to 17 bytes, -10^38 + 1 to 10^38 - 1, 0, and 10^38 - 1 to 10^38 - 1, p is the precision (1 <= p <= 38), s is the scale (0 <= s <= p).

numeric(p, s) - 5 to 17 bytes, -10^38 + 1 to 10^38 - 1, 0, and 10^38 - 1 to 10^38 - 1, p is the precision (1 <= p <= 38), s is the scale (0 <= s <= p).

smallmoney - 4 bytes, -214,748.3648 to 214,748.3647.

money - 8 bytes, -922,337,203,685,477.5808 to 922,337,203,685,477.5807.

### Using Date and Time Types

There are six types of date and time data types:

- date: date,
- time: time,
- date and time: datetime, datetime2, smalldatetime,
- time interval: datetimeoffset.

date - 3 bytes, year, month, day (range: 0001-01-01 to 9999-12-31).

time - 5 bytes, hour, minute, second, millisecond (range: 00:00:00.000 to 23:59:59.999).

datetime - 8 bytes, year, month, day, hour, minute, second, millisecond (range: 1753-01-01 00:00:00 to 9999-12-31 23:59:59).

datetime2 - 6 to 8 bytes, year, month, day, hour, minute, second, millisecond (range: 0001-01-01 00:00:00.000 to 9999-12-31 23:59:59.999).

smalldatetime - 4 bytes, year, month, day, hour, minute (1900-01-01 00:00:00 2079-06-06 23:59:59).

datetimeoffset - 10 bytes, year, month, day, hour, minute, second, millisecond, offset (range like datetime2 + timezone info).

### Other Data Types

There are other data types:

- uniqueidentifier - 16 bytes, globally unique identifier (GUID),
- rowversion - 8 bytes, timestamp.
- bit - 1 bit, 0 or 1.

Comprehensive list of data types can be found [here](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15).

### Using Collations

A collation specifies the rules for comparing characters in a character set. Collations are used to sort and compare data, they also define case and accent sensitivity and code page for non-unicode data (no n-char/varchar).

All character data has some collation, whether it is specified or not. If not specified, the default collation for the database is used. Collation can be specified at the instance level (during setup), database level (ALTER DATABASE), or column level (CREATE TABLE) it is also possible to specify collation at the expression level (SELECT).

More info [here](https://learn.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver15).

## Improving Table Design Through Normalization

Normalization is a process of organizing data in a database to minimize redundancy and dependency of data.

There are three normal forms (at least these are the most popular ones):

- zero normal form (0NF) - not really a normal form, it is a state of a table before normalization,
- first normal form (1NF) - each column contains atomic values, no repeating groups,
- second normal form (2NF) - table is in 1NF and all non-key columns are fully dependent on the primary key,
- third normal form (3NF) - table is in 2NF and all non-key columns are not transitively dependent on the primary key.

More info about database normalization can be found [here](https://learn.microsoft.com/en-us/office/troubleshoot/access/database-normalization-description) and [here](https://www.guru99.com/database-normalization.html).

## Ensuring Data Integrity with Constraints

## Designing View to Meet Business Requirements

## Implementing Indexed Views

## Implementing Partitioned Views

## Summary

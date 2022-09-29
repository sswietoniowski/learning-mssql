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

### Using Collations

## Designing and Implementing Tables

To create a database use [01_create_database.sql](01_create_database.sql).

## Improving Table Design Through Normalization

## Ensuring Data Integrity with Constraints

## Designing View to Meet Business Requirements

## Implementing Indexed Views

## Implementing Partitioned Views

## Summary

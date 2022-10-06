------------------------------
-- Pluralsight Course --------
-- Querying Data with T-SQL --
-- TSQL Demo DB --------------
------------------------------
-- Ami Levin 2019 ------------
------------------------------
-- Recommended reading - Joe Celko on keys and identifiers
-- https://www.informationweek.com/software/information-management/celko-on-sql-natural-artificial-and-surrogate-keys-explained/d/d-id/1059246
-- https://www.red-gate.com/simple-talk/sql/t-sql-programming/a-tale-of-identifiers/
-- Documentation for statements used in this script
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/drop-database-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql

USE master;
GO

DROP DATABASE IF EXISTS TSQLDemoDB;
GO

CREATE DATABASE TSQLDemoDB;
GO

USE TSQLDemoDB;
GO

CREATE TABLE Customers  (
                        Customer VARCHAR(20) NOT NULL 
							PRIMARY KEY,
                        Country VARCHAR(20) NULL
                        );

CREATE TABLE Items		(
                        Item VARCHAR(20) NOT NULL 
							PRIMARY KEY,
						Color VARCHAR(10) NOT NULL
							CHECK (Color IN ('Black', 'White', 'Yellow', 'Blue', 'Red'))
                        );

CREATE TABLE Orders		(
						OrderID INTEGER NOT NULL 
							PRIMARY KEY,
						OrderDate DATE NOT NULL,
						Customer VARCHAR(20) NOT NULL 
							REFERENCES Customers(Customer) 
						);

CREATE TABLE OrderItems (
                        OrderID INTEGER NOT NULL 
							REFERENCES Orders(OrderID),
                        Item VARCHAR(20) NOT NULL 
							REFERENCES Items(Item),
                        Quantity INTEGER NOT NULL 
							CHECK (Quantity > 0),
                        Price DECIMAL(9,2) NOT NULL 
							CHECK (Price > 0),
                        PRIMARY KEY (OrderID, Item)
                        );

INSERT INTO Customers (Customer, Country)
VALUES	('Jack', 'USA'), ('Kelly', 'USA'), ('Sunil', 'India'), 
		('Chen', 'China'), ('Bob', NULL);

INSERT INTO Items (Item, Color)
VALUES  ('Headphones', 'White'), ('MP3 Player', 'Black'), 
		('Audio Cable', 'Blue'), ('Amplifier', 'Black'), ('Turntable', 'White');

INSERT INTO Orders (OrderID, OrderDate, Customer)
VALUES  (1, '20190101', 'Jack'), (2, '20190101', 'Bob'), 
		(3, '20190115', 'Jack'), (4, '20190116', 'Chen');

INSERT INTO OrderItems (OrderID, Item, Quantity, Price)
VALUES  (1, 'MP3 Player', 1, 27.00), (1, 'Headphones', 1, 35.50),
        (2, 'Turntable', 1, 170.00),
        (3, 'Amplifier', 1, 148.00), (3, 'Audio Cable', 3, 12.50),
        (4, 'Amplifier', 1, 133.50), (4, 'Audio Cable', 2, 11.00), (4, 'Turntable', 2, 155.50);

-- END
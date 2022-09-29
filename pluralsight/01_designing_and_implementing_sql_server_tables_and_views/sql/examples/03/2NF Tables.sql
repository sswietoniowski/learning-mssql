USE BobsShoes;
GO

-- Remove any existing tables

DROP TABLE IF EXISTS Orders.Customers, Orders.Stock, Orders.Orders, Orders.OrderItems;

CREATE TABLE Orders.Customers (
    CustID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Customers_CustID PRIMARY KEY,
    CustName nvarchar(200) NOT NULL,
    CustStreet nvarchar(100) NOT NULL,
    CustCity nvarchar(100) NOT NULL,
    CustStateProv nvarchar(100) NOT NULL,
    CustCountry nvarchar(100) NOT NULL,
    CustPostalCode nvarchar(20) NOT NULL,
    CustSalutation char(5) NOT NULL
);

CREATE TABLE Orders.Stock (
    StockID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Stock_StockID PRIMARY KEY,    
    StockSKU char(8) NOT NULL,
    StockSize varchar(10) NOT NULL,
    StockName varchar(100) NOT NULL,
    StockPrice numeric(7, 2) NOT NULL,
    -- CONSTRAINT PK_Stock_StockSKU_StockSize PRIMARY KEY (StockSKU, StockSize)
);

CREATE TABLE Orders.Orders (  
    OrderID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Orders_OrderID PRIMARY KEY,
    OrderDate date NOT NULL,
    OrderRequestedDate date NOT NULL,
    OrderDeliveryDate datetime2(0) NULL,
    CustID int NOT NULL,
    OrderIsExpedited bit NOT NULL
 );

CREATE TABLE Orders.OrderItems (
    OrderItemID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_OrderItems_OrderItemID PRIMARY KEY,
    OrderID int NOT NULL,
    StockID int NOT NULL,
    Quantity smallint NOT NULL,
    Discount numeric(4, 2) NOT NULL
);

RETURN;

-- Populate the tables

INSERT INTO Orders.Customers (
        CustName, 
        CustStreet, 
        CustCity, 
        CustStateProv, 
        CustCountry, 
        CustPostalCode, 
        CustSalutation)
VALUES 
    ('Arthur Dent', '1 Main St', 'Golgafrincham', 'GuideShire', 'UK', '1MSGGS', 'Mr.'),
    ('Trillian Astra', '42 Cricket St.', 'Islington', 'Greater London', 'UK', '42CSIGL', 'Miss')

INSERT INTO Orders.Stock (
        StockSKU, 
        StockName, 
        StockSize, 
        StockPrice)

VALUES
    ('OXFORD01', 'Oxford', '10_D', 50.),
    ('BABYSHO1', 'BabySneakers', '3', 20.),
    ('HEELS001', 'Killer Heels', '7', 75.)

INSERT INTO Orders.Orders(
    OrderDate, 
    OrderRequestedDate, 
    CustID, 
    OrderIsExpedited)

VALUES 
    ('20190301', '20190401', 1, 0),
    ('20190301', '20190401', 2, 0)

INSERT INTO Orders.OrderItems(
    OrderID, 
    StockID,
    Quantity, 
    Discount)

VALUES
    (1, 1, 1, 20.),
    (2, 3, 1, 20.)

-- Show the results

SELECT * FROM Orders.Customers;
SELECT * FROM Orders.Stock
SELECT * FROM Orders.Orders;
SELECT * FROM Orders.OrderItems;



-- Can't insert an order item with a non-existent orderid

INSERT INTO Orders.OrderItems(
    OrderID, 
    StockID,
    Quantity, 
    Discount)
VALUES (42,42,42,42.)

USE BobsShoes;
GO

-- DROP TABLES In Foreign Key order
DROP TABLE IF EXISTS Orders.OrderItems, Orders.Orders

CREATE TABLE Orders.Orders (  
    OrderID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Orders_OrderID PRIMARY KEY,
    OrderDate date NOT NULL,
    OrderRequestedDate date NOT NULL,
    OrderDeliveryDate datetime2(0) NULL,
    CustID int NOT NULL
        CONSTRAINT FK_Orders_CustID_Customers_CustID 
            FOREIGN KEY REFERENCES Orders.Customers (CustID),
    OrderIsExpedited bit NOT NULL
 );

CREATE TABLE Orders.OrderItems (
    OrderItemID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_OrderItems_OrderItemID PRIMARY KEY,
    OrderID int NOT NULL
        CONSTRAINT FK_OrderItems_OrderID_Orders_OrderID
            FOREIGN KEY REFERENCES Orders.Orders (OrderID),
    StockID int NOT NULL
        CONSTRAINT FK_OrderItems_StockID_Stock_StockID
            FOREIGN KEY REFERENCES Orders.Stock (StockID),
    Quantity smallint NOT NULL,
    Discount numeric(4, 2) NOT NULL
);

-- Add the big sandals
INSERT INTO Orders.Stock (
        StockSKU, 
        StockName, 
        StockSize, 
        StockPrice)

VALUES
    ('SANDALS', 'Roman Sandals', '17', 50.);

SELECT * from Orders.Stock where StockSKU = 'SANDALS'    

-- Add the order item
INSERT INTO Orders.OrderItems(
    OrderID, 
    StockID,
    Quantity, 
    Discount)

VALUES
    (1, 4, 1, 0.);

SELECT * FROM orders.OrderItems WHERE StockID = 4;    

-- Try to delete the sandals from the stock table
DELETE orders.Stock 
    WHERE StockID = 4;

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
    ('Trillian Astra', '42 Cricket St.', 'Islington', 'Greater London', 'UK', '42CSIGL', 'Mrs.');

INSERT INTO Orders.Stock (
        StockSKU, 
        StockName, 
        StockSize, 
        StockPrice)

VALUES
    ('OXFORD01', 'Oxford', '10_D', 50.),
    ('BABYSHO1', 'BabySneakers', '3', 20.),
    ('HEELS001', 'Killer Heels', '7', 75.),
    ('SANDALS', 'Roman Sandals', '17', 50.);

INSERT INTO Orders.Orders(
    OrderDate, 
    OrderRequestedDate, 
    CustID, 
    OrderIsExpedited)

VALUES 
    ('20190301', '20190401', 1, 0),
    ('20190301', '20190401', 2, 0);

INSERT INTO Orders.OrderItems(
    OrderID, 
    StockID,
    Quantity, 
    Discount)

VALUES
    (1, 1, 1, 20.),
    (2, 3, 1, 20.);

SELECT * FROM Orders.Customers;
SELECT * FROM Orders.Stock
SELECT * FROM Orders.Orders;
SELECT * FROM Orders.OrderItems;

RETURN;

-- Can't insert an order item with a non-existent orderid

INSERT INTO Orders.OrderItems(
    OrderID, 
    StockID,
    Quantity, 
    Discount)
VALUES (42,42,42,42.)
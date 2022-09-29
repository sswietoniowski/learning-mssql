USE BobsShoes;
GO

-- CREATE SCHEMA Orders AUTHORIZATION DBO;
GO

-- Drop any existing tables
DROP VIEW IF EXISTS Orders.OrderSummary, Orders.TotalOrderItems
DROP TABLE IF EXISTS Orders.OrderItems, Orders.Stock, Orders.Orders, Orders.Customers, Orders.Salutations, Orders.CityState;
GO

-- Define Salutations table
CREATE TABLE Orders.Salutations (
    SalutationID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Salutations_SalutationID PRIMARY KEY CLUSTERED,
    Salutation varchar(5) NOT NULL
        CONSTRAINT UQ_Salutations_Salutation UNIQUE NONCLUSTERED,
        CONSTRAINT CK_Salutations_Salutation_cannot_be_blank 
            CHECK (Salutation <> '')
);

-- Define CityState table
CREATE TABLE Orders.CityState (
    CityStateID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_CityState_CityStateID PRIMARY KEY CLUSTERED,
    CityStateCity nvarchar(100) NOT NULL,
    CityStateProv nvarchar(100) NOT NULL,
    CityStateCountry nvarchar(100) NOT NULL,
    CityStatePostalCode nvarchar(20) NOT NULL,
    CONSTRAINT UQ_CityState_Street_City_Country_PostalCode
        UNIQUE NONCLUSTERED 
            (CityStateCity, CityStateProv, CityStateCountry, CityStatePostalCode),
    CONSTRAINT CK_CityState_Address_cannot_be_blank
        CHECK (CONCAT(CityStateCity, CityStateProv, CityStateCountry, CityStatePostalCode) <> '')
);

-- Define Customers table
CREATE TABLE Orders.Customers (
    CustID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Customers_CustID PRIMARY KEY,
    CustName nvarchar(200) NOT NULL,
    CustStreet nvarchar(200) NULL,
    CityStateID int NOT NULL
        CONSTRAINT FK_Customers_CityStateID_CityState_CityStateID 
            REFERENCES Orders.CityState(CityStateID),
    SalutationID int NOT NULL 
        CONSTRAINT FK_Customers_SaluationID_Salutations_SalutationID 
            REFERENCES Orders.Salutations (SalutationID),
        CONSTRAINT CK_Customers_CustomerName_cannot_be_blank 
            CHECK (CustName <> '')
);

-- Define Stock table
CREATE TABLE Orders.Stock (
    StockID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Stock_StockID PRIMARY KEY CLUSTERED,    
    StockSKU char(8) NOT NULL,
    StockSize varchar(10) NOT NULL,
    StockName varchar(100) NOT NULL,
    StockPrice numeric(7, 2) NOT NULL,
        CONSTRAINT UQ_Stock_StockSKU_StockSize 
            UNIQUE NONCLUSTERED (StockSKU, StockSize),
        CONSTRAINT CK_Stock_item_cannot_be_blank
            CHECK (CONCAT(StockSKU, StockSize, StockName) <> ''),
        CONSTRAINT CK_Stock_Price_GT_zero
            CHECK (StockPrice > 0)
);

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
        CONSTRAINT DF_Orders_OrderIsExpedited_False DEFAULT (0),
    CONSTRAINT CK_Orders_RequestedDate_GE_OrderDate
        CHECK (OrderRequestedDate >= OrderDate),
    CONSTRAINT CK_Orders_DeliveryDate_GE_OrderDate
        CHECK (OrderDeliveryDate >= OrderDate)            
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
    Quantity smallint NOT NULL
        CONSTRAINT DF_OrderItems_Quantity_1 DEFAULT (1)
        CONSTRAINT CK_OrderItems_Quantity_GT_zero
            CHECK (Quantity > 0),
    Discount numeric(4, 2) NOT NULL
        CONSTRAINT CK_OrderItems_Discount_GE_zero
            CHECK (Discount >= 0.0)
);

RETURN

-- Populate the tables

INSERT INTO Orders.Salutations (Salutation)
VALUES ('Mr.'), ('Miss'), ('Mrs.');

INSERT INTO Orders.CityState (
        CityStateCity, 
        CityStateProv,         
        CityStateCountry,
        CityStatePostalCode)
VALUES 
    ('Golgafrincham', 'GuideShire', 'UK', '1MSGGS'),
    ('Islington', 'Greater London', 'UK', '42CSIGL');

INSERT INTO Orders.Customers (
        CustName, 
        CustStreet,
        CityStateID, 
        SalutationID)
VALUES 
    ('Arthur Dent', '1 Main St', 1, 1),
    ('Trillian Astra', '42 Cricket St.', 2, 2);

INSERT INTO Orders.Stock (
        StockSKU, 
        StockName, 
        StockSize, 
        StockPrice)

VALUES
    ('OXFORD01', 'Oxford', '10_D', 50.),
    ('BABYSHO1', 'BabySneakers', '3', 20.),
    ('HEELS001', 'Killer Heels', '7', 75.);

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

-- Show current contents of tables
SELECT * FROM Orders.Salutations;
SELECT * FROM Orders.Customers;
SELECT * FROM Orders.CityState;
SELECT * FROM Orders.Stock
SELECT * FROM Orders.Orders;
SELECT * FROM Orders.OrderItems;

RETURN;
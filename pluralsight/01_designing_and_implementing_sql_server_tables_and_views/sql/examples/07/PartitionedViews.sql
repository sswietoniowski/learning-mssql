USE BobsShoes;
GO

-- Drop any existing order tables and views
DROP VIEW IF EXISTS Orders.PartitionedOrders, Orders.OrderSummary, Orders.TotalOrderItems;
DROP TABLE IF EXISTS Orders.OrderItems, Orders.Orders, Orders.Orders2018;

CREATE TABLE Orders.Orders (  
    OrderID int IDENTITY(1,1) NOT NULL,                -- Was primary key
    OrderYear smallint NOT NULL                        -- New partitioning column
        CONSTRAINT CK_Orders_Current 
            CHECK (OrderYear >= 2019 AND OrderYear < 2020), -- Check constraint to create disjoint sets
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
        CHECK (OrderDeliveryDate >= OrderDate),
    CONSTRAINT PK_Orders_OrderYear_OrderID 
        PRIMARY KEY (OrderYear, OrderID)                    -- New Primary Key
);

-- Order items table
DROP TABLE IF EXISTS Orders.OrderItems
CREATE TABLE Orders.OrderItems (
    OrderItemID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_OrderItems_OrderItemID PRIMARY KEY,
    OrderID int NOT NULL,
    OrderYear smallint NOT NULL,                        -- New column for Foreign Key
    StockID int NOT NULL
        CONSTRAINT FK_OrderItems_StockID_Stock_StockID
            FOREIGN KEY REFERENCES Orders.Stock (StockID),
    Quantity smallint NOT NULL
        CONSTRAINT DF_OrderItems_Quantity_1 DEFAULT (1)
        CONSTRAINT CK_OrderItems_Quantity_GT_zero
            CHECK (Quantity > 0),
    Discount numeric(4, 2) NOT NULL
        CONSTRAINT CK_OrderItems_Discount_GE_zero
            CHECK (Discount >= 0.0),
    CONSTRAINT FK_OrderItems_OrderYear_OrderId_Orders   -- New Foreign Key constraint
        FOREIGN KEY (OrderYear, OrderId)
        REFERENCES Orders.Orders (OrderYear, OrderId)
);

-- Orders for the year 2018
CREATE TABLE Orders.Orders2018 (  
    OrderID int IDENTITY(1,1) NOT NULL,
    OrderYear smallint NOT NULL
        CONSTRAINT CK_Orders2018_Current 
            CHECK (OrderYear >= 2018 AND OrderYear < 2019),     -- Check constraint to create disjoint sets    
    OrderDate date NOT NULL,
    OrderRequestedDate date NOT NULL,
    OrderDeliveryDate datetime2(0) NULL,
    CustID int NOT NULL
        CONSTRAINT FK_Orders2018_CustID_Customers_CustID 
            FOREIGN KEY REFERENCES Orders.Customers (CustID),
    OrderIsExpedited bit NOT NULL
        CONSTRAINT DF_Orders2018_OrderIsExpedited_False DEFAULT (0),
    CONSTRAINT CK_Orders2018_RequestedDate_GE_OrderDate
        CHECK (OrderRequestedDate >= OrderDate),
    CONSTRAINT CK_Orders2018_DeliveryDate_GE_OrderDate
        CHECK (OrderDeliveryDate >= OrderDate),
    CONSTRAINT PK_Orders2018_OrderYear_OrderID PRIMARY KEY (OrderYear, OrderID)
);
RETURN;
GO

-- Create partitioned view
CREATE VIEW Orders.PartitionedOrders
WITH SCHEMABINDING
AS
    SELECT OrderID, OrderYear, OrderDate, OrderRequestedDate, OrderDeliveryDate, CustID, OrderIsExpedited
    FROM Orders.Orders
    UNION ALL
    SELECT OrderID, OrderYear, OrderDate, OrderRequestedDate, OrderDeliveryDate, CustID, OrderIsExpedited
    FROM Orders.Orders2018
GO

-- Populate the orders tables -- 2019
INSERT INTO Orders.Orders(
    OrderDate, 
    OrderYear,
    OrderRequestedDate, 
    CustID,  
    OrderIsExpedited)

VALUES 
    ('20190301', 2019, '20190401', 1, 0),
    ('20190301', 2019, '20190401', 2, 0);

-- Populate the orders tables -- 2018
INSERT INTO Orders.Orders2018(
    OrderDate, 
    OrderYear,
    OrderRequestedDate, 
    CustID, 
    OrderIsExpedited)

VALUES 
    ('20180301', 2018, '20180401', 1, 0),
    ('20180301', 2018, '20180401', 2, 0);  

-- Populate some order items
INSERT INTO Orders.OrderItems(
    OrderID, 
    OrderYear,
    StockID,
    Quantity, 
    Discount)

VALUES
    (1, 2019, 1, 1, 20.),
    (2, 2019, 3, 1, 20.);

SELECT * FROM Orders.PartitionedOrders
    WHERE OrderYear = 2018;

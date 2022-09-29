USE BobsShoes;
GO

-- Order Table definition

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

 -- Insert a new order

INSERT INTO Orders.Orders(
    OrderDate, 
    OrderRequestedDate, 
    CustID, 
    OrderIsExpedited)

    VALUES (GETDATE(), '20190401', 1, 0);

-- Add default constraint for the OrderDate

ALTER TABLE Orders.Orders
    ADD CONSTRAINT DF_Orders_OrderDate_Getdate 
        DEFAULT GETDATE() FOR OrderDate;


-- Add default constraint for the expedited flag

ALTER TABLE Orders.Orders
    ADD CONSTRAINT DF_Orders_OrderIsExpedited_False
        DEFAULT 0 FOR OrderIsExpedited;

-- Revised insert statement

INSERT INTO Orders.Orders(
    OrderRequestedDate, 
    CustID)

    VALUES ('20190401', 1);

-- View the last order created

SELECT TOP 1 * FROM Orders.Orders
ORDER BY OrderID DESC

-- Revised CREATE TABLE 

CREATE TABLE Orders.Orders (  
    OrderID int IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Orders_OrderID PRIMARY KEY,
    OrderDate date NOT NULL
        CONSTRAINT DF_Orders_OrderDate_Getdate 
            DEFAULT GETDATE(),
    OrderRequestedDate date NOT NULL,
    OrderDeliveryDate datetime2(0) NULL,
    CustID int NOT NULL
        CONSTRAINT FK_Orders_CustID_Customers_CustID 
            FOREIGN KEY REFERENCES Orders.Customers (CustID),
    OrderIsExpedited bit NOT NULL
        CONSTRAINT DF_Orders_OrderIsExpedited_False
            DEFAULT 0
 );

 -- Alter a default constraint

 ALTER TABLE Orders.Orders
    ALTER CONSTRAINT DF_Orders_OrderDate_Getdate 
        DEFAULT GETDATE()+1 FOR OrderDate;

-- Alter a default constraint, the right way

ALTER TABLE Orders.Orders
    DROP CONSTRAINT DF_Orders_OrderDate_Getdate;

 ALTER TABLE Orders.Orders
    ADD CONSTRAINT DF_Orders_OrderDate_Getdate_Plus_1
        DEFAULT GETDATE()+1 FOR OrderDate;

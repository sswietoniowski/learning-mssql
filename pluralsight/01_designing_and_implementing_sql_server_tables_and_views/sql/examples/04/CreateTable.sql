USE BobsShoes;
GO

CREATE TABLE Orders.OrderTracking (
    OrderId int IDENTITY (1,1) NOT NULL,
    OrderDate datetime2(0) NOT NULL,
    RequestedDate datetime2(0) NOT NULL,
    DeliveryDate datetime2(0) NULL,
    CustName nvarchar(200) NOT NULL,
    CustAddress nvarchar(200) NOT NULL,
    ShoeStyle varchar(200) NOT NULL,
    ShoeSize varchar(10) NOT NULL,
    SKU char(8) NOT NULL,
    UnitPrice numeric(7, 2) NOT NULL,
    Quantity smallint NOT NULL,
    Discount numeric(4, 2) NOT NULL,
    IsExpedited bit NOT NULL,
    TotalPrice AS (Quantity * UnitPrice * (1.0 - Discount)), -- PERSISTED
) 
ON BobsData 
WITH (DATA_COMPRESSION = PAGE);
GO

USE inventory;
GO

DROP VIEW IF EXISTS dbo.vw_order_details;
GO

CREATE VIEW dbo.vw_order_details
AS
SELECT
    od.order_id AS OrderID,
    od.product_id AS ProductID,
    od.product_price AS ProductPrice,
    od.product_quantity AS ProductQuantity,
    od.total_price AS TotalPrice,
    p.product_name AS ProductName,
    p.product_description AS ProductDescription,
    p.category_id AS CategoryID,
    c.category_name AS CategoryName,
    c.category_description AS CategoryDescription
FROM 
    dbo.order_details AS od
    INNER JOIN dbo.products AS p
    ON od.product_id = p.product_id
    INNER JOIN dbo.categories AS c
    ON p.category_id = c.category_id;
GO

SELECT * FROM dbo.vw_order_details;
GO
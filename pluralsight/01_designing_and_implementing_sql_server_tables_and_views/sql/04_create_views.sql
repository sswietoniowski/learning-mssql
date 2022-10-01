USE inventory;
GO

DROP VIEW IF EXISTS dbo.vw_order_details;
GO

CREATE VIEW dbo.vw_order_details
AS
SELECT
    od.order_id,
    od.product_id,
    od.product_quantity,
    od.product_price,
    od.total_price,
    p.product_name,
    p.product_description,
    p.category_id,
    c.category_name,
    c.category_description
FROM 
    dbo.order_details AS od
    INNER JOIN dbo.products AS p
    ON od.product_id = p.product_id
    INNER JOIN dbo.categories AS c
    ON p.category_id = c.category_id;
GO

SELECT * FROM dbo.vw_order_details;
GO
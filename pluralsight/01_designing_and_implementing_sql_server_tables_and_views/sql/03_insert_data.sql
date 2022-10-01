USE inventory;
GO

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
GO

DELETE FROM dbo.order_details;
DELETE FROM dbo.orders;
DELETE FROM dbo.customers;
DELETE FROM dbo.products;
DELETE FROM dbo.categories;
GO

SET IDENTITY_INSERT dbo.categories ON;
GO
INSERT INTO dbo.categories (category_id, category_name, category_description)
VALUES (1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
       (2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
       (3, 'Confections', 'Desserts, candies, and sweet breads'),
       (4, 'Dairy Products', 'Cheeses'),
       (5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
       (6, 'Meat/Poultry', 'Prepared meats'),
       (7, 'Produce', NULL),
       (8, 'Seafood', NULL);
GO
SET IDENTITY_INSERT dbo.categories OFF;
GO

SET IDENTITY_INSERT dbo.products ON;
GO
INSERT INTO dbo.products (product_id, product_name, product_description, product_price, category_id)
VALUES (1, 'Chai', 'Spicy chai', 18.0000, 1),
       (2, 'Chang', 'An alcoholic beverage', 19.0000, 1),
       (3, 'Aniseed Syrup', 'Aniseed Syrup', 10.0000, 2),
       (4, 'Chef Anton''s Cajun Seasoning', 'Chef Anton''s Cajun Seasoning', 22.0000, 2),
       (5, 'Chef Anton''s Gumbo Mix', 'Chef Anton''s Gumbo Mix', 21.3500, 2),
       (6, 'Grandma''s Boysenberry Spread', 'Grandma''s Boysenberry Spread', 25.0000, 2),
       (7, 'Uncle Bob''s Organic Dried Pears', 'Uncle Bob''s Organic Dried Pears', 30.0000, 7),
       (8, 'Northwoods Cranberry Sauce', 'Northwoods Cranberry Sauce', 40.0000, 2),
       (9, 'Mishi Kobe Niku', 'Mishi Kobe Niku', 97.0000, 6),
       (10, 'Ikura', 'Ikura', 31.0000, 8),
       (11, 'Queso Cabrales', 'Queso Cabrales', 21.0000, 4);
GO
SET IDENTITY_INSERT dbo.products OFF;
GO

SET IDENTITY_INSERT dbo.customers ON;
GO
INSERT INTO dbo.customers (customer_id, customer_first_name, customer_last_name)
VALUES (1, 'John', 'Doe'),
       (2, 'Jane', 'Doe'),
       (3, 'John', 'Smith'),
       (4, 'Jane', 'Smith');
GO
SET IDENTITY_INSERT dbo.customers OFF;

SET IDENTITY_INSERT dbo.orders ON;
GO
INSERT INTO dbo.orders (order_id, order_date, delivery_date)
VALUES (1, '2019-01-01', '2019-01-02'),
       (2, '2019-01-02', '2019-01-03'),
       (3, '2019-01-03', '2019-01-04'),
       (4, '2019-01-04', '2019-01-05'),
       (5, '2019-01-05', NULL),
       (6, '2019-01-06', '2019-01-07'),
       (7, '2019-01-07', '2019-01-08'),
       (8, '2019-01-08', '2019-01-09'),
       (9, '2019-01-09', '2019-01-10'),
       (10, '2019-01-10', NULL);
GO
SET IDENTITY_INSERT dbo.orders OFF;
GO

INSERT INTO dbo.order_details (order_id, product_id, product_quantity, product_price)
VALUES (1, 1, 1, 10.00),
       (1, 2, 2, 10.00),
       (1, 3, 3, 10.00),
       (2, 4, 4, 10.00),
       (2, 5, 5, 10.00),
       (2, 6, 6, 10.00),
       (3, 7, 7, 20.00),
       (3, 8, 8, 20.00),
       (3, 9, 9, 20.00),
       (4, 10, 10, 20.00),
       (4, 11, 11, 20.00),
       (4, 1, 12, 20.00),
       (5, 2, 13, 20.00),
       (5, 3, 14, 20.00),
       (5, 4, 15, 20.00);
GO

COMMIT TRANSACTION;
GO
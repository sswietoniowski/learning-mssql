USE inventory;
GO

DROP TABLE IF EXISTS dbo.order_details, dbo.orders, dbo.customers, dbo.products, dbo.categories;
GO

CREATE TABLE dbo.categories
(
    category_id INT NOT NULL IDENTITY
        CONSTRAINT PK_categories PRIMARY KEY,
    category_name NVARCHAR(64) NOT NULL 
        CONSTRAINT UQ_categories_category_name UNIQUE,
    category_description NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.products
(
    product_id INT NOT NULL IDENTITY
        CONSTRAINT PK_products PRIMARY KEY,
    product_name NVARCHAR(128) NOT NULL,
    product_description NVARCHAR(MAX) NULL,
    product_price DECIMAL NOT NULL 
        CONSTRAINT CK_products_price_ge_zero CHECK (product_price >= 0),
    category_id INT NOT NULL 
        CONSTRAINT FK_products_categories 
            FOREIGN KEY (category_id) REFERENCES dbo.categories 
            ON UPDATE CASCADE ON DELETE NO ACTION
);
GO

CREATE TABLE dbo.customers
(
    customer_id INT NOT NULL IDENTITY
        CONSTRAINT PK_customers PRIMARY KEY,
    customer_first_name NVARCHAR(64) NOT NULL,
    customer_last_name NVARCHAR(128) NOT NULL,    
);
GO

CREATE TABLE dbo.orders
(
    order_id INT NOT NULL IDENTITY
        CONSTRAINT PK_orders PRIMARY KEY,
    order_date DATETIME2 NOT NULL
        CONSTRAINT DF_orders_order_date DEFAULT (GETDATE())
);
GO

CREATE TABLE dbo.order_details
(
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_quantity INT NOT NULL
        CONSTRAINT CK_order_details_product_quantity_gt_zero CHECK (product_quantity > 0),
    product_price DECIMAL NOT NULL
        CONSTRAINT CK_product_price_ge_zero CHECK (product_price >= 0),
    total_price AS (product_quantity * product_price) PERSISTED
)
WITH (DATA_COMPRESSION = PAGE);
GO



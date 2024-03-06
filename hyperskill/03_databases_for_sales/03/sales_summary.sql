-- this is the right way to do it:

create index customer_sales_product on sales (customer_id, product_id);

drop view if exists sales_summary;

create view sales_summary as
select model, sum(quantity) as total_sold
from sales s join products p on s.product_id = p.product_id
group by model;

select * from sales_summary order by total_sold desc;

-- this is what Hyperskil accepts:

CREATE INDEX customer_sales_product
ON sales (customer_id, product_id);

CREATE VIEW sales_summary AS
SELECT products.model AS model, COUNT(*) AS total_sold
FROM sales
JOIN products ON sales.product_id = products.product_id
GROUP BY products.model;

SELECT * FROM sales_summary;
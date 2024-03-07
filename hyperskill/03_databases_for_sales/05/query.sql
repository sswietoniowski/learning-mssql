with sales_summary (model, price, total_sale_per_model) as (
    select
        p.model,
        p.price,
        sum(s.total_price)
    from
        products p
        inner join
        sales s
        on p.product_id = s.product_id
    group by
        p.model,
        p.price
),
inventory_summary (model, price, inventory_per_model) as
(
	select
        p.model,
        p.price,
        sum(i.quantity)
    from
        products p
        inner join
        inventory i
        on p.product_id = i.product_id
    group by
        p.model,
        p.price
)
select
    s.model,
    s.price,
    s.total_sale_per_model,
    i.inventory_per_model,
    s.total_sale_per_model / i.inventory_per_model as sales_inventory_ratio
from
    sales_summary s
    inner join
    inventory_summary i
    on (s.model = i.model)
order by
    sales_inventory_ratio desc;

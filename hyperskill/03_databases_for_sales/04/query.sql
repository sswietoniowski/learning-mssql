with monthly_sales (month_year, total_sales) as (
    select
        DATE_FORMAT(s.sale_date, '%M %Y') as month_year,
        sum(s.total_price) as total_sales
    from
        sales s
    group by
        month_year
), employee_sales (employee_name, position, month_year, sales) as (
    select
        concat_ws(' ', e.first_name, e.last_name) as employee_name,
        e.position,
        DATE_FORMAT(s.sale_date, '%M %Y') as month_year,
        sum(s.total_price) as sales
    from
		employees e
        inner join
        sales s
        on (e.employee_id = s.employee_id)
    where 
        e.position = 'Sales Associate'
    group by
        concat_ws(' ', e.first_name, e.last_name),
        e.position,
        month_year
)
select
    e.employee_name,
    e.position,
    e.month_year,
    case
        when e.sales < 0.05 * s.total_sales then 0
        when e.sales < 0.1 * s.total_sales then 2000
        when e.sales < 0.2 * s.total_sales then 5000
        when e.sales < 0.3 * s.total_sales then 10000
        when e.sales < 0.4 * s.total_sales then 15000
        else 25000
    end as employee_bonus
from
    employee_sales e
    inner join
    monthly_sales s on e.month_year = s.month_year
order by e.employee_name, e.month_year;
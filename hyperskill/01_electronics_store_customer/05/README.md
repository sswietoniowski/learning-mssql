# Objectives

Identify the laptops priced higher than any PC, including `model`, `maker` (`Product` table), and `price`.

Also, compute the differences: laptop vs. most expensive PC as `price_difference_max_pc` and laptop vs. average laptop price as `price_difference_avg_laptop`.

The order of the columns matters.

```sql
SELECT
    l.model,
    p.maker,
    l.price,
    l.price - max_pc_price AS price_difference_max_pc,
    l.price - avg_laptop_price AS price_difference_avg_laptop
FROM
    Laptop l
    INNER JOIN
    Product p ON l.model = p.model
    CROSS JOIN
    (SELECT MAX(price) AS max_pc_price FROM PC) max_pc
    CROSS JOIN
    (SELECT AVG(price) AS avg_laptop_price FROM Laptop) avg_laptop
WHERE
    l.price > max_pc_price;
```

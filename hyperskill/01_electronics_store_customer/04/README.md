# Objectives

Identify manufacturers producing PCs and laptops, then count their production quantities.

Find the `maker` in the `Product` table, `COUNT` the number of PC-type models it produces as `pc_count`, and `COUNT` the number of laptop-type models it produces as `laptop_count`.

Use `GROUP_BY` and `SUM` functions to solve this task. The order of the columns matters.

```sql
SELECT maker, 
    SUM(CASE when type = 'PC' then 1 else 0 end) AS pc_count, 
    SUM(CASE when type = 'Laptop' then 1 else 0 end) AS laptop_count
FROM Product
WHERE type = 'PC' or type='Laptop'
GROUP BY maker
HAVING pc_count > 0 AND laptop_count > 0;
```

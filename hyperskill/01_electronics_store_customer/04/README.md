# Objectives

Identify manufacturers producing PCs and laptops, then count their production quantities.

Find the `maker` in the `Product` table, `COUNT` the number of PC-type models it produces as `pc_count`, and `COUNT` the number of laptop-type models it produces as `laptop_count`.

Use `GROUP_BY` and `SUM` functions to solve this task. The order of the columns matters.

```sql
SELECT maker, COUNT(model) AS pc_count, 0 AS laptop_count
FROM Product
WHERE type = 'PC'
GROUP BY maker
UNION
SELECT maker, 0 AS pc_count, COUNT(model) AS laptop_count
FROM Product
WHERE type = 'Laptop'
GROUP BY maker;
```

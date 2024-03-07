# Objectives

Identify the second most expensive PCs based on the RAM capacity.

Find the `pc_code`, `model`, `speed`, `ram`, `hd`, `cd`, and `price` from the `PC` table.

Use `PARTITION BY` to solve this challenge.

The order of the columns matters.

```sql
SELECT
    pc_code,
    model,
    speed,
    ram,
    hd,
    cd,
    price
FROM
    (SELECT
        pc_code,
        model,
        speed,
        ram,
        hd,
        cd,
        price,
        ROW_NUMBER() OVER (PARTITION BY ram ORDER BY price DESC) AS rn
    FROM
        PC) ranked
WHERE
    rn = 2;
```

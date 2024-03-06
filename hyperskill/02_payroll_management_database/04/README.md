# Objectives

Create a procedure called `PayrollReport` that takes in the name of any department.

Output the `full_names`, `base_pay`, `overtime_pay`, `total_pay`, `tax_owed`, and `net_income`.

Order the table with the `net_income` column in descending order.

Call the `PayrollReport` procedure on the 'City Ethics Commission' department.

```sql
drop procedure if exists CalculateEmployeePay;

delimiter //

create procedure CalculateEmployeePay (IN employee_id INT, IN total_hours INT,
    OUT base_pay FLOAT, OUT overtime_pay FLOAT, OUT total_pay FLOAT)
begin
    declare hourly_rate FLOAT;
    declare normal_hours INT;
    declare overtime_hours INT;
    declare overtime_rate FLOAT;
    declare max_overtime_pay FLOAT;

    set normal_hours = 8 * (250 + 10);
    set overtime_rate = 1.5;
    set max_overtime_pay = 6000;

    select
        j.hourly_rate
        into hourly_rate
    from
        employees e
        inner join
        jobs j
        on e.job_id = j.id
    where
        e.id = employee_id;

    set overtime_hours = total_hours - normal_hours;

    set base_pay = normal_hours * hourly_rate;

    if overtime_hours > 0 then
        set overtime_pay = least(hourly_rate * overtime_rate * overtime_hours, max_overtime_pay);
    else
        set overtime_pay = 0;
    end if;
    set total_pay = base_pay + overtime_pay;
end//

delimiter ;

drop function if exists TaxOwed;

delimiter //

create function TaxOwed (taxable_income FLOAT(10,2)) returns FLOAT(10,2)
deterministic
begin
    declare tax_owed FLOAT(10,2);

    if taxable_income <= 11000 then
        set tax_owed = 0.10 * taxable_income;
    elseif taxable_income > 11000 and taxable_income <= 44725 then
        set tax_owed = 1100 + (taxable_income - 11000) * 0.12;
    elseif taxable_income > 44725 and taxable_income <= 95375 then
        set tax_owed = 5147 + (taxable_income - 44725) * 0.22;
    elseif taxable_income > 95375 and taxable_income <= 182100 then
        set tax_owed = 16290 + (taxable_income - 95375) * 0.24;
    elseif taxable_income > 182100 and taxable_income <= 231250 then
        set tax_owed = 37104 + (taxable_income - 182100) * 0.32;
    elseif taxable_income > 231250 and taxable_income <= 578125 then
        set tax_owed = 52832 + (taxable_income - 231250) * 0.35;
    else
        set tax_owed = 174238.25 + (taxable_income - 578125) * 0.37;
    end if;

    return tax_owed;
end//

delimiter ;

drop procedure if exists PayrollReport;

DELIMITER //

CREATE PROCEDURE PayrollReport (IN department_name VARCHAR(45))
BEGIN
    DECLARE employee_id INT;
    DECLARE full_name VARCHAR(45);
    DECLARE hours_worked INT;
    DECLARE base_pay FLOAT;
    DECLARE overtime_pay FLOAT;
    DECLARE total_pay FLOAT;
    DECLARE tax_owed FLOAT;
    DECLARE done INT DEFAULT FALSE;

    DECLARE employees_cursor CURSOR FOR
        SELECT
            e.id, CONCAT(e.first_name, ' ', e.last_name)
        FROM
            employees e
            INNER JOIN
            departments d ON e.department_id = d.id
        WHERE
            d.name = department_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- this could be a real table if the definition of this task was different

    CREATE TEMPORARY TABLE IF NOT EXISTS timesheets (
        full_names VARCHAR(45),
        hours INT
    );

    INSERT INTO timesheets (full_names, hours) VALUES
        ('Dixie Herda', 2095),
        ('Stephen West', 2091),
        ('Philip Wilson', 2160),
        ('Robin Walker', 2083),
        ('Antoinette Matava', 2115),
        ('Courtney Walker', 2206),
        ('Gladys Bosch', 900);

    CREATE TEMPORARY TABLE IF NOT EXISTS report_data (
        full_names VARCHAR(45),
        base_pay FLOAT(10,2),
        overtime_pay FLOAT(10,2),
        total_pay FLOAT(10,2),
        tax_owed FLOAT(10,2),
        net_income FLOAT(10,2)
    );

    OPEN employees_cursor;

    read_loop: LOOP
        FETCH employees_cursor INTO employee_id, full_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT hours INTO hours_worked
        FROM timesheets AS t
        WHERE t.full_names = full_name;

        CALL CalculateEmployeePay(employee_id, hours_worked, base_pay, overtime_pay, total_pay);
        SET tax_owed = TaxOwed(total_pay);

        INSERT INTO report_data (full_names, base_pay, overtime_pay, total_pay, tax_owed, net_income)
        VALUES (full_name, base_pay, overtime_pay, total_pay, tax_owed, total_pay - tax_owed);
    END LOOP;

    CLOSE employees_cursor;

    DROP TEMPORARY TABLE IF EXISTS timesheets;

    SELECT *
    FROM report_data
    ORDER BY net_income DESC;

    DROP TEMPORARY TABLE IF EXISTS report_data;
END //

DELIMITER ;

call PayrollReport('City Ethics Commission');
```

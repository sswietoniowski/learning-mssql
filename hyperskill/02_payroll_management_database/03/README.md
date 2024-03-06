# Objectives

Create the function called `TaxOwed` that takes an employee's taxable income of an employee and outputs the tax owed.

Output the tax owed by "Philip Wilson" and "Daisy Diamond".

```sql
drop procedure if exists EmployeeTotalPay;

delimiter //

create procedure EmployeeTotalPay (IN first_name VARCHAR(45), IN last_name VARCHAR(45),
    IN total_hours INT, IN normal_hours INT, IN overtime_rate FLOAT(10,2),
    IN max_overtime_pay FLOAT(10,2), OUT total_pay FLOAT(10,2))
begin
    declare hourly_rate FLOAT(10,2);
    declare overtime_hours INT;
    declare overtime_pay FLOAT(10,2);
    declare normal_pay FLOAT(10,2);

    select
        j.hourly_rate
        into hourly_rate
    from
        employees e
        inner join
        jobs j
        on e.job_id = j.id
    where
        e.first_name = first_name
        and e.last_name = last_name;

    set normal_pay = normal_hours * hourly_rate;

    set overtime_hours = total_hours - normal_hours;

    set overtime_pay = least(hourly_rate * (1 + (overtime_rate / 100.00)) * overtime_hours, max_overtime_pay);

    set total_pay = normal_pay + overtime_pay;
end//

drop function if exists TaxOwed;

delimiter //

create function TaxOwed (taxable_income FLOAT(10,2)) returns FLOAT
begin
    declare tax_owed FLOAT;

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

call EmployeeTotalPay("Philip", "Wilson", 2160, (250 + 10) * 8, 50.00, 6000.00, @employee1_total_pay);
call EmployeeTotalPay("Daisy", "Diamond", 2100, (250 + 10) * 8, 50.00, 6000.00, @employee2_total_pay);

select TaxOwed(@employee1_total_pay) as "Philip Wilson", TaxOwed(@employee2_total_pay) as "Daisy Diamond";
```

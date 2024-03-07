# Objectives

Create the procedure called `EmployeeTotalPay` that takes in `first_name`, `last_name`, `total_hours`, `normal_hours`, `overtime_rate`, `max_overtime_pay`, and outputs `total_pay`.

Output the total pay for "Philip Wilson" and "Daisy Diamond".

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

delimiter ;

call EmployeeTotalPay("Philip", "Wilson", 2160, (250 + 10) * 8, 50.00, 6000.00, @employee1_total_pay);
call EmployeeTotalPay("Daisy", "Diamond", 2100, (250 + 10) * 8, 50.00, 6000.00, @employee2_total_pay);

select @employee1_total_pay as "Philip Wilson", @employee2_total_pay as "Daisy Diamond";
```

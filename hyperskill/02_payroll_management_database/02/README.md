# Objectives

Create the procedure called `EmployeeTotalPay` that takes in `first_name`, `last_name`, `total_hours`, `normal_hours`, `overtime_rate`, `max_overtime_pay`, and outputs `total_pay`.

Output the total pay for Philip Wilson and Daisy Diamond.

```sql
create procedure EmployeeTotalPay (IN first_name VARCHAR(45), IN last_name VARCHAR(45), IN total_hours INT, IN normal_hours INT, IN overtime_rate DECIMAL(10, 2), IN max_overtime_pay DECIMAL(10, 2), OUT total_pay DECIMAL(10, 2))
begin
    declare overtime_hours INT;
    declare overtime_pay DECIMAL(10, 2);
    declare normal_pay DECIMAL(10, 2);
    declare max_overtime_pay DECIMAL(10, 2);

    set overtime_hours = total_hours - normal_hours;
    set overtime_pay = least(overtime_hours * overtime_rate, max_overtime_pay);

    if overtime_pay > max_overtime_pay then
        set overtime_pay = max_overtime_pay;
    end if;

    set normal_pay = normal_hours * overtime_rate;

    set output_total_pay = normal_pay + overtime_pay;
end;

call EmployeeTotalPay("Philip", "Wilson", 50, 40, 20.00, 500.00, @employee1_total_pay);
call EmployeeTotalPay("Daisy", "Diamond", 60, 40, 20.00, 500.00, @employee2_total_pay);

select @employee1_total_pay as "Philip Wilson", @employee2_total_pay as "Daisy Diamond";
```

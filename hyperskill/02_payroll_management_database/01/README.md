# Objectives

Create a procedure called `GetEmployeesByDept` that returns the `first_name`, `last_name`, and `job_title` for all employees in a given department.

The output of the procedure is ordered by their `first_name`.

Call the procedure for the "Office of Finance" department.

```sql
create procedure GetEmployeesByDept (IN input_department VARCHAR(45))
begin
    select
        e.first_name
        , e.last_name
        , j.title as job_title
    from
        employees e join departments d on e.department_id = d.id
        join jobs j on e.job_id = j.id
    where d.name = input_department
    order by e.first_name;
end;

call GetEmployeesByDept("Office of Finance");
```

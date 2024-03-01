# Objectives

Create a procedure called `GetEmployeesByDept` that returns the `first_name`, `last_name`, and `job_title` for all employees in a given department.

The output of the procedure is ordered by their `first_name`.

Call the procedure for the "Office of Finance" department.

```sql
CREATE PROCEDURE GetEmployeesByDept(dept_name VARCHAR(45))
BEGIN
    SELECT
        first_name,
        last_name,
        title AS job_title
    FROM
        employees
    JOIN
        jobs
    ON
        employees.job_id = jobs.id
    JOIN
        departments
    ON
        employees.department_id = departments.id
    WHERE
        departments.name = dept_name
    ORDER BY
        first_name;
END;

CALL GetEmployeesByDept("Office of Finance");
```

DROP DATABASE IF EXISTS Payroll_Management;

CREATE DATABASE IF NOT EXISTS Payroll_Management;

USE Payroll_Management;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS insurance_benefits;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS jobs;

CREATE TABLE departments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL
);

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(45) NOT NULL,
    type VARCHAR(45) NOT NULL,
    hourly_rate FLOAT(5,2) NOT NULL
);

CREATE TABLE employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  department_id INT NOT NULL,
  job_id INT NOT NULL,
  date_employed DATE NOT NULL,
  FOREIGN KEY (department_id) REFERENCES departments(id),
  FOREIGN KEY (job_id) REFERENCES jobs(id)
);

CREATE TABLE insurance_benefits (
  id INT PRIMARY KEY AUTO_INCREMENT,
  job_id INT NOT NULL,
  annual_insurance FLOAT(5,2) NOT NULL,
  FOREIGN KEY (job_id) REFERENCES jobs(id)
);

INSERT INTO departments (id, name)
VALUES
    (1, 'HR'), (2, 'IT'),
    (3, 'Finance'),
    (4, 'Marketing');

INSERT INTO jobs (id, title, type, hourly_rate)
VALUES
    (1, 'Manager', 'Salaried', 30.00),
    (2, 'Assistant Manager', 'Salaried', 25.00),
    (3, 'HR Specialist', 'Hourly', 20.00),
    (4, 'IT Specialist', 'Hourly', 20.00),
    (5, 'Accountant', 'Hourly', 20.00),
    (6, 'Marketing Specialist', 'Hourly', 20.00);

INSERT INTO employees (id, first_name, last_name, department_id, job_id, date_employed)
VALUES
    (1, 'John', 'Doe', 1, 1, '2019-01-01'),
    (2, 'Jane', 'Doe', 1, 2, '2019-01-01'),
    (3, 'Jim', 'Doe', 2, 3, '2019-01-01'),
    (4, 'Jill', 'Doe', 3, 4, '2019-01-01'),
    (5, 'Jack', 'Doe', 4, 5, '2019-01-01');

INSERT INTO insurance_benefits (id, job_id, annual_insurance)
VALUES
    (1, 1, 100.00),
    (2, 2, 80.00),
    (3, 3, 60.00),
    (4, 4, 60.00),
    (5, 5, 60.00),
    (6, 6, 60.00);

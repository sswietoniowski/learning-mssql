drop table if exists inventory;
drop table if exists sales;
drop table if exists employees;
drop table if exists customers;
drop table if exists products;
drop table if exists manufacturers;

create table if not exists manufacturers (
    manufacturer_id int primary key auto_increment,
    name varchar(45) not null,
    country varchar(45) not null
);

create table if not exists products (
    product_id int primary key auto_increment,
    manufacturer_id int not null,
    model varchar(45) not null,
    price decimal not null,
    horsepower int not null,
    fuel_efficiency int not null,
    foreign key (manufacturer_id) references manufacturers(manufacturer_id)
);

create table if not exists employees (
    employee_id int primary key auto_increment,
    first_name varchar(45) not null,
    last_name varchar(45) not null,
    position varchar(45) not null,
    salary decimal(10, 2) not null,
    address varchar(45) not null,
    mobile varchar(45) not null,
    is_active tinyint not null
);

create table if not exists customers (
    customer_id int primary key auto_increment,
    first_name varchar(45) not null,
    last_name varchar(45) not null,
    address varchar(45) not null,
    city varchar(45) not null,
    state varchar(45) not null
);

create table if not exists sales (
    sale_id int primary key auto_increment,
    sale_date date not null,
    customer_id int not null,
    product_id int not null,
    employee_id int not null,
    quantity int not null,
    total_price decimal not null,
    foreign key (product_id) references products(product_id),
    foreign key (employee_id) references employees(employee_id),
    foreign key (customer_id) references customers(customer_id)
);

create table if not exists inventory (
    product_id int primary key,
    quantity int not null,
    reorder_level int not null default 2,
    last_inventory_date date not null,
    foreign key (product_id) references products(product_id)
);

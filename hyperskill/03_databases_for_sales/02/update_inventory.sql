drop trigger if exists update_inventory;

delimiter //

create trigger update_inventory
after insert on sales
for each row
begin
    update inventory
    set 
        quantity = quantity - new.quantity,
        last_inventory_date = new.sale_date
    where inventory.product_id = new.product_id;
end//

delimiter ;

INSERT INTO sales (sale_date, customer_id, product_id, employee_id, quantity, total_price) 
VALUES
    (DATE('2023-05-01'), 1, 1, 1, 2, 56000.00),
    (DATE('2023-05-02'), 2, 2, 1, 1, 22000.00),
    (DATE('2023-05-02'), 1, 3, 2, 1, 41250.00),
    (DATE('2023-05-03'), 2, 4, 2, 2, 60000.00),
    (DATE('2023-05-03'), 1, 1, 2, 3, 84000.00);

SELECT * FROM inventory;
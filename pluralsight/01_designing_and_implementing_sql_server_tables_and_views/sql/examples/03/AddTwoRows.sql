USE BobsShoes;
GO

INSERT INTO Orders.OrderTracking(
    OrderDate,     
    RequestedDate, 
    CustName,  
    CustAddress,   
    ShoeStyle,     
    ShoeSize,      
    SKU,           
    UnitPrice,     
    Quantity,    
    Discount,      
    IsExpedited
	)
VALUES 
	('20190315', '20190501', 'Arthur Dent', 'Golgafrincham', 'Boots', '10_D', 'BOOTS001', 50.0, 1, 0, 0),
	('20190315', '20190501', 'Arthur Dent', 'Golgafrincham', 'Slippers', '3', 'SLIPPERS', 20.0, 1, 0, 0);
			
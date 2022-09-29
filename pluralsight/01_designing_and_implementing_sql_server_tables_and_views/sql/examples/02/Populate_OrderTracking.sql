USE BobsShoes;
GO

TRUNCATE TABLE Orders.OrderTracking;
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
	('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'Oxford', '10_D', 'OXFORD01', 50.0, 1, 0, 0),
	('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'BabySneakers', '3', 'BABYSHO1', 20.0, 1, 0, 0),	
	('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'Killer Heels', '7', 'HEELS001', 75.0, 1, 0, 0);

					
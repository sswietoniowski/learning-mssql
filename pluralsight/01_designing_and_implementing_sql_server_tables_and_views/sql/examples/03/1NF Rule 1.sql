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
	-- ('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'Oxford, Wing tip', '10_D', 'OXFORD01', 50.0, 1, 0, 0)
    ('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'Oxford', '10_D', 'OXFORD01', 50.0, 1, 0, 0),
    ('20190301', '20190401', 'Arthur Dent', 'Golgafrincham', 'Wing tip', '10_D', 'OXFORD01', 50.0, 1, 0, 0)

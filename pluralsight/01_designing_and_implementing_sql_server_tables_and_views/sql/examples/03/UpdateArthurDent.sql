-- UPDATE Anomaly

UPDATE Orders.OrderTracking
SET CustAddress = 'Magarathea'
WHERE OrderDate = '20190301'
AND CustName = 'Arthur Dent'

SELECT * FROM Orders.OrderTracking
WHERE CustName = 'Arthur Dent'

-- INSERT Anomaly 

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
    VALUES ( ? ) -- What to put here?

-- DELETE Anomaly    

    DELETE FROM Orders.OrderTracking
    WHERE CustName = 'Arthur Dent'
    AND ShoeSize = '10_D'

    SELECT * FROM Orders.OrderTracking
    WHERE CustName = 'Arthur Dent'
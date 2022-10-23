WHILE (1 = 1)
BEGIN
	DECLARE @Delay int = ABS(CHECKSUM(NEWID()) % 80)
	
	BEGIN TRAN

	/* adjust Quantity for specific StockItems */
	UPDATE 
		Sales.OrderLines
	SET
		Quantity = Quantity - 15
	WHERE
		StockItemID = 156 -- 10 mm Double sided bubble wrap 10m
		OR
		OrderID BETWEEN 1500 AND 2500

	WAITFOR DELAY @Delay -- hold locks

	ROLLBACK TRAN

	WAITFOR DELAY '00:00:15'
END


DECLARE
	@MaxOrderID   int = -1,
	@NextOrderID  int,
  @BatchSize    int = 1000,
	@RC           int = 1,
  @Delay        datetime = '00:00:00.01';
 
-- Delete rows in batches
WHILE (@RC > 0)
BEGIN
 
  -- Find largest OrderID in the next batch
  SELECT TOP (@BatchSize) @NextOrderID = o.OrderID
  FROM Orders.Orders o
  WHERE o.OrderID > @MaxOrderID
    AND o.CustID = 42
  ORDER BY o.OrderID ASC;
 
  -- Delete all matching rows in the batch
  DELETE Orders.Orders
  WHERE CustID = 42
    AND OrderID > @MaxOrderID     -- OrderID of the start of the batch
    AND OrderID <= @NextOrderID;  -- OrderID of the end of the batch
 
  SET @RC = @@ROWCOUNT;           -- Save number of rows deleted
  SET @MaxOrderID = @NextOrderID; -- Update the maximum OrderID found so far

  WAITFOR DELAY @Delay;
 
END

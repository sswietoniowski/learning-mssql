set statistics io on
set statistics time on

/* Sales Quantity Anchored core query */
SELECT 
    [StockItemKey],
    [StockItem],
    [Year],
    [Month],
    [Quantity],
    [QtyAnchorDiff]
FROM 
    [dbo].[udfSalesAnchor](-7, 5)
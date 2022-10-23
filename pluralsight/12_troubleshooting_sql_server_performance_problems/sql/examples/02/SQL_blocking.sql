/* get the session_id */
--SELECT @@SPID as [session_id];

/* blocked dashboard query */
/* expected sum: 2707196 */
SELECT SUM(
CAST([t0].[Quantity] AS BIGINT)
)
 AS [a0]
FROM 
(
(select [$Table].[OrderID] as [OrderID],
    [$Table].[CustomerID] as [CustomerID],
    [$Table].[OrderDate] as [OrderDate],
    [$Table].[OrderLineID] as [OrderLineID],
    [$Table].[StockItemID] as [StockItemID],
    [$Table].[Description] as [Description],
    [$Table].[Quantity] as [Quantity],
    [$Table].[UnitPrice] as [UnitPrice],
    [$Table].[PickedQuantity] as [PickedQuantity],
    [$Table].[CustomerName] as [CustomerName],
    [$Table].[PhoneNumber] as [PhoneNumber]
from [Sales].[ViewPowerBISalesOrdersConsolidated] as [$Table] )
)
 AS [t0]
WHERE 
(
(
([t0].[OrderDate] < CAST( '20150729 00:00:00' AS datetime))
 AND 
([t0].[OrderDate] >= CAST( '20131103 00:00:00' AS datetime))
)
 AND 
(
([t0].[StockItemID] <= 198)
 AND 
([t0].[StockItemID] >= 139)
)
)

 

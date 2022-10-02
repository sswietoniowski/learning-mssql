CREATE OR ALTER VIEW dbo.ShipmentsWithTotals
WITH SCHEMABINDING
AS

SELECT s.ShipmentID,
       s.ClientID,
       s.ReferenceNumber,
       s.Priority,
       SUM(sd.Mass) AS TotalMass,
       SUM(sd.Volume) AS TotalVolume,
       SUM(sd.NumberOfContainers) AS TotalContainers,
	   COUNT_BIG(*) AS NumberOfDetails
	FROM dbo.Shipments s INNER JOIN dbo.ShipmentDetails sd ON sd.ShipmentID = s.ShipmentID
GROUP BY s.ShipmentID,
         s.ClientID,
         s.ReferenceNumber,
         s.Priority

GO

CREATE UNIQUE CLUSTERED INDEX idx_ShipmentsWithTotals 
	ON dbo.ShipmentsWithTotals (ShipmentID);
GO




SELECT s.ShipmentID,
       s.ClientID,
       s.ReferenceNumber,
       s.Priority,
       SUM(sd.Mass) AS TotalMass,
       SUM(sd.Volume) AS TotalVolume,
       SUM(sd.NumberOfContainers) AS TotalContainers
	FROM dbo.Shipments s INNER JOIN dbo.ShipmentDetails sd ON sd.ShipmentID = s.ShipmentID
GROUP BY s.ShipmentID,
         s.ClientID,
         s.ReferenceNumber,
         s.Priority

/*
 SQL Server Execution Times:
   CPU time = 390 ms,  elapsed time = 827 ms.
 */

 SELECT * FROM dbo.ShipmentsWithTotals WITH (NOEXPAND)

 /*
  SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 429 ms.
 */

 SELECT s.ShipmentID,
       s.ReferenceNumber,
       s.Priority,
       SUM(sd.Mass) AS TotalMass,
       SUM(sd.Volume) AS TotalVolume
	FROM dbo.Shipments s INNER JOIN dbo.ShipmentDetails sd ON sd.ShipmentID = s.ShipmentID
GROUP BY s.ShipmentID,
         s.ReferenceNumber,
         s.Priority
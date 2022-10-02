CREATE OR ALTER VIEW dbo.TransactionsForShipmentsToCoreWorlds 
WITH SCHEMABINDING
AS
SELECT t.InvoiceNumber, t.TransactionDate, t.TransactionType
FROM dbo.Transactions t
    INNER JOIN dbo.Shipments s ON s.ShipmentID = t.ReferenceShipmentID
    INNER JOIN dbo.Stations st ON st.StationID = s.DestinationStationID
    INNER JOIN dbo.StarSystems ss ON ss.StarSystemID = st.StarSystemID
	WHERE ss.OfficialName IN ('Sol', 'Procyon', '61 Cygni', '40 Eridani');

GO

CREATE UNIQUE CLUSTERED INDEX idx_TransactionsForShipmentsToCoreWorlds 
	ON dbo.TransactionsForShipmentsToCoreWorlds (InvoiceNumber);


	
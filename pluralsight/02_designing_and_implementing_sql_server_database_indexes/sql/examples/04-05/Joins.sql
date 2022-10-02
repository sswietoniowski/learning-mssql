SELECT ss.Location, s.ShipmentID
	FROM dbo.Stations ss 
		INNER JOIN dbo.Shipments s ON s.OriginStationID = ss.StationID
	WHERE ss.Location = 'Outer Transfer'


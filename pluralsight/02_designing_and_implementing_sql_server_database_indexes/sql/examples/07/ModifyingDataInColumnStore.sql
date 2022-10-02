SELECT * FROM sys.column_store_row_groups





DELETE FROM dbo.ShipmentDetailsColumnStore 
	WHERE ShipmentDetailID IN (SELECT TOP (5) PERCENT ShipmentDetailID FROM dbo.ShipmentDetailsColumnStore ORDER BY NEWID())

INSERT INTO dbo.ShipmentDetailsColumnStore
(
    ShipmentID,
    CustomsCodeID,
    Mass,
    Volume,
    NumberOfContainers,
    IsTemperatureControlled,
    IsHazardous,
    IsLivestock
)
SELECT ShipmentID,
       CustomsCodeID,
       Mass,
       Volume,
       NumberOfContainers,
       IsTemperatureControlled,
       IsHazardous,
       IsLivestock 
FROM dbo.ShipmentDetails
WHERE ShipmentDetailID IN (SELECT TOP (10) PERCENT ShipmentDetailID FROM dbo.ShipmentDetails ORDER BY NEWID())

UPDATE dbo.ShipmentDetailsColumnStore
	SET Mass = Mass*0.5
	WHERE ShipmentDetailID IN (SELECT TOP (1) PERCENT ShipmentDetailID FROM dbo.ShipmentDetailsColumnStore ORDER BY NEWID())
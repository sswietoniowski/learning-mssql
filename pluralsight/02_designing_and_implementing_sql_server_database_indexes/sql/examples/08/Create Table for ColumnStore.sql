SELECT * 
INTO ShipmentDetailsColumnStore
FROM dbo.ShipmentDetails
GO



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

GO 10


USE [WideWorldImporters]
GO

/****** Object:  View [Warehouse].[ViewPowerBIColdRoomTempHistory]    Script Date: 5/1/2020 7:45:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Warehouse].[ViewPowerBIColdRoomTempHistory]
AS
	SELECT TOP 20000
		ColdRoomTemperatureID,
		ColdRoomSensorNumber,
		CAST(RecordedWhen AS smalldatetime) AS RecordedWhen,
		Temperature
	FROM
		Warehouse.ColdRoomTemperatures	
	FOR SYSTEM_TIME ALL	
	ORDER BY RecordedWhen DESC
GO



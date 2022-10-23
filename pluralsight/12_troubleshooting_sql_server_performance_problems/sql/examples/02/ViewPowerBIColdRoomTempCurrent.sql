USE [WideWorldImporters]
GO

/****** Object:  View [Warehouse].[ViewPowerBIColdRoomTempCurrent]    Script Date: 5/1/2020 7:44:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Warehouse].[ViewPowerBIColdRoomTempCurrent]
AS
	SELECT
		ColdRoomTemperatureID,
		ColdRoomSensorNumber,
		RecordedWhen,
		Temperature
	FROM
		Warehouse.ColdRoomTemperatures	
GO



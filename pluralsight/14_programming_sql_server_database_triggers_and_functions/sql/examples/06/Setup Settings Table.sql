CREATE TABLE Application.Settings (
	SettingsID INT IDENTITY,
	SettingName NVARCHAR(100),
	SettingValue NVARCHAR(100)
);

INSERT INTO Application.Settings (SettingName, SettingValue)
	VALUES ('FiscalEndMonth','6');
GO


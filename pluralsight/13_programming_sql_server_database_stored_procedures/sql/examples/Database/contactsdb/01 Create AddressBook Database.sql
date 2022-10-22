USE Master;

IF NOT EXISTS
(
	SELECT 1 FROM sys.databases WHERE [name] = 'Contacts'
)
BEGIN;

	CREATE DATABASE Contacts;

END;

GO
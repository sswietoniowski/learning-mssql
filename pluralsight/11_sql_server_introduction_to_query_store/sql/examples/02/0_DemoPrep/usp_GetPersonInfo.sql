USE [WideWorldImporters];

SET NOCOUNT ON;
SET ARITHABORT ON;

DECLARE @PersonID INT;

WHILE 1=1
BEGIN

	SELECT @PersonID = (
		SELECT TOP 1 [PersonID]
		FROM [Application].[People]
		ORDER BY NEWID());

	EXEC [Application].[usp_GetPersonInfo] @PersonID;

END
GO
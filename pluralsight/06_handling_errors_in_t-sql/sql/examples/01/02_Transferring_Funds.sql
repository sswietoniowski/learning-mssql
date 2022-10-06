-- Run this script to follow along with the demo
USE [ABCCompany];
GO

-- First let's check the balance in our savings and checking account
SELECT SUM(Amount) AS 'Balance', 'Checking' AS 'Account Type'
FROM Bank.Checking
UNION ALL
SELECT SUM(Amount) AS 'Balance', 'Savings' AS 'Account Type'
FROM Bank.Savings;
GO

-- Checking is $350
-- Savings is $4100









-- Transfer funds from the savings account to the checking
INSERT INTO Bank.Savings (Amount, TransactionNotes)
	VALUES (-500,'Sorry mom I really need this game');
GO

INSERT INTO Bank.Checking (Amount, TransactionNotes)
	VALUES (500,'Adding funds out to buy the sealed original Super Mario Bros on NES');
GO









-- Let's check the balance in our savings and checking account
SELECT SUM(Amount) AS 'Balance', 'Checking' AS 'Account Type'
FROM Bank.Checking
UNION ALL
SELECT SUM(Amount) AS 'Balance', 'Savings' AS 'Account Type'
FROM Bank.Savings;
GO








-- Transfer funds from the savings account to the checking
INSERT INTO Bank.Savings (Amount, TransactionNotes)
	VALUES (-500,'Sorry mom I really need this game');

INSERT INTO Bank.Checking (Amount, TransactionNotes)
	VALUES (500,'Adding funds out to buy the sealed original Super Mario Bros on NES');
GO











-- Remove the failed amount
DELETE FROM Bank.Savings 
WHERE Amount = -500 AND TransactionNotes = 'Sorry mom I really need this game';
GO







-- Let's check the balance in our savings and checking account
SELECT SUM(Amount) AS 'Balance', 'Checking' AS 'Account Type'
FROM Bank.Checking
UNION ALL
SELECT SUM(Amount) AS 'Balance', 'Savings' AS 'Account Type'
FROM Bank.Savings;
GO

-- Checking is $350
-- Savings is $4100








BEGIN TRY
	
	BEGIN TRANSACTION;

		INSERT INTO Bank.Savings (Amount, TransactionNotes)
			VALUES (-500,'Sorry mom I really need this game');

		INSERT INTO Bank.Checking (Amount, TransactionNotes)
			VALUES (500,'Adding funds out to buy the sealed original Super Mario Bros on NES');

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	IF (@@TRANCOUNT > 0)

		ROLLBACK TRANSACTION;

		THROW;

END CATCH
GO





-- Let's check the balance in our savings and checking account
SELECT SUM(Amount) AS 'Balance', 'Checking' AS 'Account Type'
FROM Bank.Checking
UNION ALL
SELECT SUM(Amount) AS 'Balance', 'Savings' AS 'Account Type'
FROM Bank.Savings;
GO

-- Checking is $350
-- Savings is $4100
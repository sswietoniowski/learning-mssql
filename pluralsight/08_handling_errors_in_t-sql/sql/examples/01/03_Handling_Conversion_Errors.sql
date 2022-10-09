-- Run this script to follow along with the demo
USE [ABCCompany];
GO






-- Just using CAST
SELECT CAST('31 Dec 12' AS date) AS 'First Date'
	   ,CAST('Dec 12 1776 12:38AM' AS date) AS 'Second Date'
	   ,CAST('Dec 12 1400 12:38AM' AS datetime) AS 'Third Date'
	   ,CAST('Number 3' AS int) AS 'Number 3';
GO





-- TRY_CAST 
SELECT TRY_CAST('30 Dec 06' AS date) AS 'First Date'
	   ,TRY_CAST('Dec 12 1776 12:38AM' AS datetime) AS 'Second Date'
	   ,TRY_CAST('Dec 12 1400 12:38AM' AS datetime) AS 'Third Date'
	   ,TRY_CAST('Number 3' AS int) AS 'Number 3';
GO





-- CONVERT 
SELECT CONVERT(date,'30 Dec 06',101)
	   ,CONVERT(int, '00002A');
GO





-- TRY_CONVERT
SELECT TRY_CONVERT(date,'30 Dec 06',101)
	   ,TRY_CONVERT(int, '00002A');
GO





-- Returns an exception
SELECT TRY_CONVERT(xml,123);
GO





-- Using CASE
SELECT CASE WHEN TRY_CONVERT(int, '00002B') IS NULL 
	THEN 99
	END AS Id;
GO
set statistics io on
set statistics time on

/* Sales Quantity City Population core query */

SELECT 
	City,
	[Latest Recorded Population],
	Quantity
FROM 
	[dbo].[ViewPowerBISalesDW]
WHERE 
	[Latest Recorded Population] > 10000
	AND
	[Latest Recorded Population] < 20000 	

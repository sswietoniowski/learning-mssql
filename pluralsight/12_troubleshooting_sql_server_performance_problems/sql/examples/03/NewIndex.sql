/* create a new nonclustered index on the Dimension.City table */
/* index column = Latest recorded population */
/* INCLUDE column = City */
CREATE NONCLUSTERED INDEX idxLatestRecordedPopulation 
ON Dimension.City ([Latest recorded population])
INCLUDE (City)
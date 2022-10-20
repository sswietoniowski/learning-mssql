/*
	Run the stored procedure to create an
	existing trace to an extended events session
*/

EXECUTE sp_SQLskills_ConvertTraceToExtendedEvents 
		@TraceID = 2, 
		@SessionName = 'XE_ReadsFilter_Trace', 
		@PrintOutput = 1, 
		@Execute = 0;

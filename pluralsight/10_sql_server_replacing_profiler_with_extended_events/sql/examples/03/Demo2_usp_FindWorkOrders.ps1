
$SqlConn = New-Object System.Data.SqlClient.SqlConnection;
$SqlConn.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;Integrated Security=True;Application Name = MyCoolApp";
$SqlConn.Open();
$SqlCmd = $SqlConn.CreateCommand();

$SqlCmd.CommandText = "SELECT DISTINCT DueDate FROM Production.WorkOrder;"
$SqlCmd.CommandType = [System.Data.CommandType]::Text;

$SqlReader2 = $SqlCmd.ExecuteReader();
$Results2 = New-Object System.Collections.ArrayList;

while ($SqlReader2.Read())
{
	$Results2.Add($SqlReader2.GetSqlDateTime(0)) | Out-Null;
}

$SqlReader2.Close();

while(1 -eq 1)
{
	
	$Value2 = Get-Random -InputObject $Results2;

	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "usp_FindWorkOrders"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@date", $Value2);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::DateTime;
	
	$SqlCmd.ExecuteNonQuery();
	
	# Sleep for 5 miliseconds between loops 
    Start-Sleep -Milliseconds 100 
	
}



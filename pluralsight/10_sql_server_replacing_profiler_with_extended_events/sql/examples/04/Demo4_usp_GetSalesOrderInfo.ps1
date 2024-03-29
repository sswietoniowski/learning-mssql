
$SqlConn = New-Object System.Data.SqlClient.SqlConnection;
$SqlConn.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;Integrated Security=True;Application Name = MyCoolApp";
$SqlConn.Open();
$SqlCmd = $SqlConn.CreateCommand();

$SqlCmd.CommandText = "SELECT SalesOrderID FROM Sales.SalesOrderHeader;"
$SqlCmd.CommandType = [System.Data.CommandType]::Text;

$SqlReader3 = $SqlCmd.ExecuteReader();
$Results3 = New-Object System.Collections.ArrayList;

while ($SqlReader3.Read())
{
	$Results3.Add($SqlReader3.GetSqlInt32(0)) | Out-Null;
}

$SqlReader3.Close();

while(1 -eq 1)
{
	
	$Value3 = Get-Random -InputObject $Results3;

	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "usp_GetSalesOrderInfo"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@ID", $Value3);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::Int;
	
	$SqlCmd.ExecuteNonQuery();
	
	# Sleep for 5 miliseconds between loops 
    Start-Sleep -Milliseconds 100 	
	
}



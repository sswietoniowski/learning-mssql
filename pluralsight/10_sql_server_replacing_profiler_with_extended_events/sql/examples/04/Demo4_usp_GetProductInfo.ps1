
$SqlConn = New-Object System.Data.SqlClient.SqlConnection;
$SqlConn.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;Integrated Security=True;Application Name = MyCoolApp";
$SqlConn.Open();
$SqlCmd = $SqlConn.CreateCommand();

$SqlCmd.CommandText = "SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail;";

$SqlCmd.CommandType = [System.Data.CommandType]::Text;

$SqlReader = $SqlCmd.ExecuteReader();
$Results = New-Object System.Collections.ArrayList;

while ($SqlReader.Read())
{
	$Results.Add($SqlReader.GetSqlInt32(0)) | Out-Null;
}

$SqlReader.Close();
 
	# Clear the cache first
	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "DBCC FREEPROCCACHE;"
	$SqlCmd.CommandType = [System.Data.CommandType]::Text;	
	$SqlCmd.ExecuteNonQuery();
	
	#Load Key Lookup Plan First
	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "[Sales].[usp_GetProductInfo]"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@ProductID", 919);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::Int;
	$SqlCmd.ExecuteNonQuery();

while(1 -eq 1)
{
	$Value = Get-Random -InputObject $Results;
	
	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "[Sales].[usp_GetProductInfo]"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@ProductID", $Value);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::Int;
	
	$SqlCmd.ExecuteNonQuery();

	# Sleep for 5 miliseconds between loops 
    Start-Sleep -Milliseconds 100 
}

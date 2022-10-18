
$SqlConn = New-Object System.Data.SqlClient.SqlConnection;
$SqlConn.ConnectionString = "Data Source=PLURALSIGHT\SQL2016;Initial Catalog=WideWorldImporters;Integrated Security=True;Application Name = MyCoolApp";
$SqlConn.Open();
$SqlCmd = $SqlConn.CreateCommand();

$SqlCmd.CommandText = "SELECT DISTINCT(StockItemID) FROM [Sales].[OrderLines];"
$SqlCmd.CommandType = [System.Data.CommandType]::Text;

$SqlReader = $SqlCmd.ExecuteReader();
$Results = New-Object System.Collections.ArrayList;



while ($SqlReader.Read())
{
	$Results.Add($SqlReader.GetSqlInt32(0)) | Out-Null;
}

$SqlReader.Close();


while(1 -eq 1)
{

	$Value = Get-Random -InputObject $Results;
	
	$SqlCmd = $SqlConn.CreateCommand();
	$SqlCmd.CommandText = "[Sales].[usp_GetFullProductInfo]"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@StockItemID", $Value);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::Int;
	
	$SqlCmd.ExecuteNonQuery();

	# Sleep for 5 miliseconds between loops 
    Start-Sleep -Milliseconds 5 
}

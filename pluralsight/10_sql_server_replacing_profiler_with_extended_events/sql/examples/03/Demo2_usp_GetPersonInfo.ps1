
$SqlConn = New-Object System.Data.SqlClient.SqlConnection;
$SqlConn.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;Integrated Security=True;Application Name = MyCoolApp";
$SqlConn.Open();
$SqlCmd = $SqlConn.CreateCommand();

$SqlCmd.CommandText = "SELECT BusinessEntityID FROM Person.Person;"
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
	$SqlCmd.CommandText = "usp_GetPersonInfo"
	$SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	
	$SqlParameter = $SqlCmd.Parameters.AddWithValue("@ID", $Value);
	$SqlParameter.SqlDbType = [System.Data.SqlDbType]::Int;
	
	$SqlCmd.ExecuteNonQuery();

	# Sleep for 5 miliseconds between loops 
    Start-Sleep -Milliseconds 100 
}

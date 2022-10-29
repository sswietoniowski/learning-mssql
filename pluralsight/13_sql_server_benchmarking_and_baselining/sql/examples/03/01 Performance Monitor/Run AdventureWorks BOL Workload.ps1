# Load the SMO assembly 
#[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo"); 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null

# Set the server to run the workload against 
$ServerName = "WIN2008R2PS\SQL2012"; 

# Split the input on the delimeter 
$Queries = Get-Content -Delimiter "------" -Path "PROD_AdventureWorks BOL Workload.sql" 

Trap {
  $err = $_.Exception
  while ( $err.InnerException )
    {
    $err = $err.InnerException
    write-output $err.Message
    };
    continue
  }

WHILE(1 -eq 1) 
{ 
    # Pick a Random Query from the input object 
    $Query = Get-Random -InputObject $Queries; 

    #Get a server object which corresponds to the default instance 
    $srv = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server $ServerName 
	
    # Use the AdventureWorks2008R2 database 
    $srv.ConnectionContext.set_DatabaseName("AdventureWorks2012") 

    # Execute the query with ExecuteNonQuery 
    $srv.ConnectionContext.ExecuteNonQuery($Query); 

    # Disconnect from the server 
    $srv.ConnectionContext.Disconnect(); 
    
    # Sleep for 100 miliseconds between loops 
    Start-Sleep -Milliseconds 100 
} 

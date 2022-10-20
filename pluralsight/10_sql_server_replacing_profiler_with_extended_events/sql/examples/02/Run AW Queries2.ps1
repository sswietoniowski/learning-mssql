# Load the SMO assembly 
[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo"); 

# Set the server to run the workload against 
$ServerName = "PLURALSIGHT\SQL2014"; 

# Split the input on the delimeter 
$Queries = Get-Content -Delimiter "------" -Path "C:\Pluralsight\XE\AdventureWorks Queries2.sql" 

WHILE(1 -eq 1) 
{ 
    # Pick a Random Query from the input object 
    $Query = Get-Random -InputObject $Queries; 

    #Get a server object which corresponds to the default instance 
    $srv = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server $ServerName 

    # Use the AdventureWorks2014 database 
    $srv.ConnectionContext.set_DatabaseName("AdventureWorks2014") 
    $srv.ConnectionContext.set_ApplicationName("AdventureWorks Person Finder")
    $srv.ConnectionContext.set_WorkstationID("UserG")
    # $srv.ConnectionContext.set_Login("aw_webuser")
    # $srv.ConnectionContext.set_Password("12345")

    # Execute the query with ExecuteNonQuery 
    $srv.ConnectionContext.ExecuteNonQuery($Query); 

    # Disconnect from the server 
    $srv.ConnectionContext.Disconnect(); 
    
    # Sleep for 100 miliseconds between loops 
    Start-Sleep -Milliseconds 400 
} 


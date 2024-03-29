## Get ProductIDs from AdventureWorks database
$sqlconnection = New-Object System.Data.SqlClient.SqlConnection
$sqlconnection.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;User Id=aw_webuser;Password=12345;Application Name=AdventureWorks Online Ordering;Workstation ID=AWWEB01";
$sqlconnection.Open();

$productIDs = New-Object System.Collections.Generic.List``1[System.Int32]

$sqlcmd = $sqlconnection.CreateCommand();
$sqlcmd.CommandText = "SELECT ProductID FROM Production.Product;";
$dr = $sqlcmd.ExecuteReader();

while($dr.Read())
{
      $productIDs.Add($dr[0]);
}

$sqlconnection.Close();


## Get Names from AdventureWorks database
$Names = New-Object System.Collections.Generic.List``1[System.String]

$sqlconnection = New-Object System.Data.SqlClient.SqlConnection
$sqlconnection.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;User Id=aw_webuser;Password=12345;Application Name=AdventureWorks Online Ordering;Workstation ID=AWWEB01";
$sqlconnection.Open();

$sqlcmd = $sqlconnection.CreateCommand();
$sqlcmd.CommandText = "SELECT FirstName +'|'+LastName FROM Person.Person;";
$dr = $sqlcmd.ExecuteReader();

while($dr.Read())
{
      $Names.Add($dr.GetString(0));
}

$sqlconnection.Close();


#Set the server to script from 
$ServerName = ".";

$Queries = Get-Content -Delimiter "------" -Path "C:\Pluralsight\XE\AdventureWorks BOL Workload.sql"



WHILE(1 -eq 1)
{
      $rem = $null
      $inputint = Get-Random;
      [Void][Math]::DivRem($inputint, 2, [ref]$rem);
      
      if($rem -eq 0)
      {
      
            $ProductID = Get-Random -InputObject $productIDs;

            $query = [String]::Format("SELECT [t].[TransactionID], [t].[TransactionDate], [p].[ProductID], [p].[Name]
            FROM [Production].[TransactionHistory] [t]
          JOIN [Production].[Product] [p] ON [t].ProductID = [p].ProductID
      WHERE [p].[ProductID]= {0};", $ProductID);

            #Get a server object which corresponds to the default instance 
            
            $sqlconnection = New-Object System.Data.SqlClient.SqlConnection
            $sqlconnection.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;User Id=aw_webuser;Password=12345;Application Name=AdventureWorks Online Ordering;Workstation ID=AWWEB01";
            $sqlconnection.Open();
            
            $sqlcmd = $sqlconnection.CreateCommand();
            $sqlcmd.CommandText = $query 
            
            $sqlcmd.ExecuteNonQuery();
            
            $sqlconnection.Close();
            
            Start-Sleep -Milliseconds 100 
      }
      else
      {
            $name = Get-Random -InputObject $Names;
            $firstname = $Name.Split('|')[0];
            $lastname = $Name.Split('|')[0];
            
            
            $query = [String]::Format("SELECT [c].[CustomerID], [c].[AccountNumber], [p].[FirstName], [p].[LastName], [a].[AddressLine1], [a].[City] 
FROM [Person].[Person] [p]
    JOIN [Sales].[Customer] [c] ON [p].[BusinessEntityID] = [c].[PersonID]
    JOIN [Person].[BusinessEntityAddress] [ba] ON [ba].BusinessEntityID = [c].PersonID
    JOIN [Person].[Address] [a] ON [a].AddressID = [ba].AddressID
    WHERE [p].[FirstName] = '{0}' AND [p].[LastName] = '{1}';", $firstname, $lastname);

            #Get a server object which corresponds to the default instance 
            
            $sqlconnection = New-Object System.Data.SqlClient.SqlConnection
            $sqlconnection.ConnectionString = "Data Source=PLURALSIGHT\SQL2014;Initial Catalog=AdventureWorks2014;User Id=aw_webuser;Password=12345;Application Name=AdventureWorks Online Ordering;Workstation ID=AWWEB01";
            $sqlconnection.Open();
            
            $sqlcmd = $sqlconnection.CreateCommand();
            $sqlcmd.CommandText = $query 
            
            $sqlcmd.ExecuteNonQuery();
            
            $sqlconnection.Close();
            
            Start-Sleep -Milliseconds 1       
      }
      
}

# Set-executionpolicy unrestricted

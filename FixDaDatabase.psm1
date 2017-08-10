function Get-DaDatabaseIndexStatus {
<#
.Synopsis
Adds the Direct Access Database has the index to the internal database

.DESCRIPTION
This function connects to the Windows internal database in order to add the missing index. Not having that index can cause high cpu load on the Server 2012R2 Direct Access server.

.PARAMETER ConnectionTimeout
This parameter indicates the timeout in seconds while trying to establish a connection before terminating the attempt and generating an error.

.NOTES   
Name:        Get-DaDatabaseIndexStatus
Author:      Jaap Brasser
Version:     1.1.0
DateCreated: 2016-04-25
DateUpdated: 2016-08-09
Blog:        http://www.jaapbrasser.com

.EXAMPLE
Get-DaDatabaseIndexStatus

Description:
Will retrieve the status of the index and the local computer name

.EXAMPLE
Get-DaDatabaseIndexStatus -ConnectionTimeout 600

Description:
Will retrieve the status of the index and the local computer name and set the timeout to ten minutes. This gives the server more time to complete the request.
#>

[cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [int] $ConnectionTimeout
    )

    process {
        $ConnectionString = 'Server=np:\\.\pipe\MICROSOFT##WID\tsql\query;Integrated Security=True;Initial Catalog=RaAcctDb;'
        
        if ($ConnectionTimeout) {
            $ConnectionString = $ConnectionString -replace ';$',";Connection Timeout=$ConnectionTimeout;"
        }
        
        Write-Verbose "Connecting using: '$ConnectionString'"

        if ($PSCmdlet.ShouldProcess('.','Querying internal database')) {
            try {
                $Connection = New-Object System.Data.SqlClient.SqlConnection
                $Connection.ConnectionString = $ConnectionString
                $Connection.Open()
            
                $Query = $Connection.CreateCommand()
                $Query.CommandText = 'select name from sys.indexes',
                                     "where name like 'Idx%'",
                                     'order by name asc' -join "`r`n"
                
                Write-Verbose "Executing the following query:`r`n$($Query.CommandText)"
                $SQLOutput = $Query.ExecuteReader()
            
                $Table = New-Object -TypeName 'System.Data.DataTable'
                $Table.Load($SQLOutput)
            
                $HashTable = @{
                    ComputerName = $env:COMPUTERNAME
                }
                
                if (-not $Table) {
                    $HashTable.IndexPresent = $false
                } elseif ($Table.name -contains 'IdxSessionTblSessionState') {
                    $HashTable.IndexPresent = $true
                } else {
                    $HashTable.IndexPresent = $false
                }
                
                return New-Object -TypeName PSCustomObject -Property $HashTable
            } catch {
                throw $_
            }
        }
    }
}

function Add-DaDatabaseIndex {
<#
.Synopsis
Checks if the Direct Access Database has the index

.DESCRIPTION
This function connects to the Windows internal database in order to create the missing index. This can resolve high cpu load issues on the Server 2012R2 Direct Access server.

.PARAMETER ConnectionTimeout
This parameter indicates the timeout in seconds while trying to establish a connection before terminating the attempt and generating an error.

.NOTES   
Name:        Add-DaDatabaseIndex
Author:      Jaap Brasser
Version:     1.1.0
DateCreated: 2016-04-25
DateUpdated: 2016-08-09
Blog:        http://www.jaapbrasser.com

.EXAMPLE
Add-DaDatabaseIndex

Description:
Will create the database index that can resolve cpu load issues on the system

.EXAMPLE
Add-DaDatabaseIndex -ConnectionTimeout 600

Description:
Will create the database index that can resolve cpu load issues on the system and set the timeout to ten minutes. This gives the server more time to complete the request.
#>
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [int] $ConnectionTimeout
    )

    process {
        $ConnectionString = 'Server=np:\\.\pipe\MICROSOFT##WID\tsql\query;Integrated Security=True;Initial Catalog=RaAcctDb;'
        
        if ($ConnectionTimeout) {
            $ConnectionString = $ConnectionString -replace ';$',";Connection Timeout=$ConnectionTimeout;"
        }
        
        Write-Verbose "Connecting using: '$ConnectionString'"

        if ($PSCmdlet.ShouldProcess('.','Creating index')) {
            try {
                $Connection = New-Object System.Data.SqlClient.SqlConnection
                $Connection.ConnectionString = $ConnectionString
                $Connection.Open()

                $Query = $Connection.CreateCommand()
                $Query.CommandText = 'Use RaAcctDb',
                                     'Create NonClustered Index IdxSessionTblSessionState on SessionTable (SessionState,ConnectionID)' -join "`r`n"
                
                Write-Verbose "Executing the following query:`r`n$($Query.CommandText)"
                $Query.ExecuteReader()
            } catch {
                throw $_
            }
        }
    }
}

function Remove-DaDatabaseIndex {
<#
.Synopsis
Remove if the Direct Access Database index

.DESCRIPTION
This function connects to the Windows internal database in order to remove the index created by the Add-DataDatabaseIndex function.

.PARAMETER ConnectionTimeout
This parameter indicates the timeout in seconds while trying to establish a connection before terminating the attempt and generating an error.

.NOTES   
Name:        Remove-DaDatabaseIndex
Author:      Jaap Brasser
Version:     1.1.0
DateCreated: 2016-04-25
DateUpdated: 2016-08-09
Blog:        http://www.jaapbrasser.com

.EXAMPLE
Remove-DaDatabaseIndex

Description:
Will remove the previously created database index

.EXAMPLE
Remove-DaDatabaseIndex -ConnectionTimeout 600

Description:
Will remove the previously created database index and set the timeout to ten minutes. This gives the server more time to complete the request.
#>
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [int] $ConnectionTimeout
    )

    process {
        $ConnectionString = 'Server=np:\\.\pipe\MICROSOFT##WID\tsql\query;Integrated Security=True;Initial Catalog=RaAcctDb;'
        
        if ($ConnectionTimeout) {
            $ConnectionString = $ConnectionString -replace ';$',";Connection Timeout=$ConnectionTimeout;"
        }
        
        Write-Verbose "Connecting using: '$ConnectionString'"

        if ($PSCmdlet.ShouldProcess('.','Removing index')) {
            try {
                $Connection = New-Object System.Data.SqlClient.SqlConnection
                $Connection.ConnectionString = $ConnectionString
                $Connection.Open()

                $Query = $Connection.CreateCommand()
                $Query.CommandText = 'Use RaAcctDb',
                                     'Drop Index IdxSessionTblSessionState.SessionTable'  -join "`r`n"
                
                Write-Verbose "Executing the following query:`r`n$($Query.CommandText)"
                $Query.ExecuteReader()
            } catch {
                throw $_
            }
        }
    }
}
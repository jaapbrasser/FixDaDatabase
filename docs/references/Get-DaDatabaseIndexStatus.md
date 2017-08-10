# Get-DaDatabaseIndexStatus

## SYNOPSIS
Checks if the Direct Access Database has the index

## SYNTAX

```
Get-DaDatabaseIndexStatus [[-ConnectionTimeout] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function connects to the Windows internal database in order to establish if the missing index that can cause high cpu load on the Server 2012R2 Direct Access server.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-DaDatabaseIndexStatus
```

Will retrieve the status of the index and the local computer name

### -------------------------- EXAMPLE 2 --------------------------
```
Get-DaDatabaseIndexStatus -ConnectionTimeout 600
```

Will retrieve the status of the index and the local computer name and set the timeout to ten minutes. This gives the server more time to complete the request.

## PARAMETERS

### --ConnectionTimeout
{{Fill Bot Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
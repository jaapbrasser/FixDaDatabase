# Add-DaDatabaseIndex

## Synopsis
Adds the Direct Access Database has the index to the internal database

## Syntax

```
Add-DaDatabaseIndex [[-ConnectionTimeout] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description
This function connects to the Windows internal database in order to add the missing index. Not having that index can cause high cpu load on the Server 2012R2 Direct Access server.

## Examples

### -------------------------- EXAMPLE 1 --------------------------
```
Add-DaDatabaseIndex
```

Will create the database index that can resolve cpu load issues on the system

### -------------------------- EXAMPLE 2 --------------------------
```
Add-DaDatabaseIndex -ConnectionTimeout 600
```

Will create the database index that can resolve cpu load issues on the system and set the timeout to ten minutes. This gives the server more time to complete the request.

## Parameters

### -ConnectionTimeout
This parameter indicates the timeout in seconds while trying to establish a connection before terminating the attempt and generating an error.

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

### CommonParameters
This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable. For more nformation, see about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

## Notes
Name:        Get-DaDatabaseIndex
Author:      Jaap Brasser
Version:     1.1.0
DateCreated: 2016-04-25
DateUpdated: 2016-08-09
Blog:        http://www.jaapbrasser.com
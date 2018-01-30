Function get-Accesslist
{
<#
.Synopsis
This script help you to get files and folder permission,Scripts requires $sourcepath 
.Description
This script help you to get files and folder permission,Scripts requires $sourcepath
.PARAMETER sourcePath
Enter the Source path from where file needs to copy
.Inputs
None
.Example
get-Accesslist -sourcePath C:\Test | export-csv D:\Sachin\nilesh.csv
.Example

.OUTPUTS
None.

#>   Param
        (
         [parameter(Mandatory =$true,
                    Position=0,
                    HelpMessage="Enter Source path"
                    )]$sourcePath
       
        )
$test =  Get-ChildItem -Path $sourcepath -Recurse | Select-Object PSPath,Mode
$b = "\w+\.\w+\.\w+\\\w+\:\:"
foreach ($t in $test.pspath)
{
 $path = $t -replace "$b",""
 $Access = get-acl -Path $path | select -ExpandProperty Access -Property @{l="Folderpath";e={$path}},Owner,Access
 $Access | Select-Object Folderpath,Owner,IdentityReference,FileSystemRights
}
}


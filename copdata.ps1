Function copy-Data 
{
    $destination = $item.FullName -replace $Sourcedrive,$Destinationdrive
    $destfolderpath1 = Split-Path -Path $destination -Parent
    copy-item -Path $item.FullName -Destination $destfolderpath1 -Force -verbose
    try {get-acl $item.FullName | set-acl -Path "$destfolderpath1\$(split-path -Path $item.FullName -Leaf)" -ErrorVariable $errorlist1}
    catch { Write-host "Not able to change ownership of $($item.fullname)"}
}

Function copy-FileFolder 
{
 <#
.Synopsis
This script help you to Copy files and folder with permission,Scripts requires $sourcepath and $destinationpath exactly equal, except the difference of Drive letter
.Description
This script help you to Copy files and folder with permission,Scripts requires $sourcepath and $destinationpath exactly equal, except the difference of Drive letter
.PARAMETER sourcePath
Enter the Source path from where file needs to copy
.PARAMETER destinationPath
Enter the DEstination path from where file needs to be copied
.Inputs
None
.Example
copy-FileFolder -sourcePath D:\Trial -destinationPath C:\Trial
.Example

.OUTPUTS
None.

#>   Param
        (
         [parameter(Mandatory =$true,
                    Position=0,
                    HelpMessage="Enter Source path"
                    )]$sourcePath,
         [parameter(Mandatory =$true,
                    Position=0,
                    HelpMessage="Enter Source path"
                   )]$destinationPath
        )
        $Sourcepath -match "[\w]\:"
        $Sourcedrive = $Matches.Values
        $Destinationpath -match "[\w]\:"
        $Destinationdrive = $Matches.Values
        $dummyDestinationpath = $destinationPath -replace "$Destinationdrive","$Sourcedrive"

        if ($dummyDestinationPath -eq $sourcepath)#Checks if source and destination is same except for Drive letter
            {
            $Listofitems = Get-childItem -Path $sourcepath -Recurse
            $item = $null
            $destination = $null
            $destfolderpath1 = $null
            $destfolderpath = $null
            new-item -Path $destinationPath -ItemType Directory
            get-acl $sourcePath | set-acl -path $destinationPath
            foreach ($item in $Listofitems)#for Eachloop to Copy file/Folder and permission for each object
                {
                 If ( test-path -path $item.FullName -PathType Leaf)#Check if object is "Leaf" object.
                         {
                         $destination = $item.FullName -replace $Sourcedrive,$Destinationdrive
                         $destfolderpath = Split-Path -Path $destination -Parent
                         copy-item -Path $item.FullName -Destination $destfolderpath
                         if ( Test-path -literalpath $destination)#Make sure if object Actually exist
                                 {
                                 try {get-acl $item.FullName | set-acl -Path "$destfolderpath\$(split-path -Path $item.FullName -Leaf)" -ErrorAction Stop }
                                 catch {Write-host "Not able to change ownership of $($item.fullname)" }
                                 }
                         else 
                                 {
                                  copy-data
                                 }
                         }#End of IF Block
                 Else
                         {
                          $destination = $item.fullname -replace $Sourcedrive,$Destinationdrive
                          $destfolderpath1 = Split-Path -Path $destination -Parent
                          copy-item -Path $item.FullName -Destination $destfolderpath1 -force 
                          if ( Test-path -path $destination)#Make sure if object Actually exist
                                 {
                                 try {get-acl $item.FullName | set-acl -Path "$destfolderpath1\$(split-path -Path $item.FullName -Leaf)" -ErrorAction Stop}
                                 catch { Write-host "Not able to change ownership of $($item.fullname)"  }
                                 }
                          else 
                                 {
                                  copy-data
                                 }
                          }
       

                 }
             }
        Else 
            {
             Write-host 'Kindly mention $sourcepath and $destinationpath exactly equal, except the difference of Drive letter'
            }#This loop executes if $sourcepath and $destinationpath is not exactly equal
  }

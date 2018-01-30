Function Set-SharedfolderAccess
{

<#
.Synopsis 
This script allows to set access to user or group on shared folder. 
.Description 
This script allows to set access to user or group on shared folder. You can set "Fullcontrol","Modify","ReadAndExecute","Read" on shared folder using this script
Also you can set access controltype to allow or Deny
.PARAMETER Username 
Enter the username to whom you want to provide access on shared folder 
.PARAMETER Groupname
Provide groupname to which you want to allow access to
.PARAMETER AccessRight
Provide rights needs to allow/Deny to intended Group/User : "Modify","Fullcontrol","ReadAndExecute","Read"
.PARAMETER AccessControlType
Allow/Deny  rights to intended Group/User
.PARAMETER Pathlist
Provide Pathname on which user\group needs access
.Inputs 
This Script can accept inputs via pipeline 
.Example 
Set-SharedfolderAccess -username "abc" -accessright Read -AccessControlTypetype Allow -pathlist "\\XYZ\TA2"
.Example 
Set-SharedfolderAccess -groupname "DEF" -accessright Modify -AccessControlTypetype Allow -pathlist "\\XYZ\TA2"
.OUTPUTS 
None. 
#>

[cmdletbinding(DefaultParameterSetName="P2")]param(
[parameter(Mandatory=$True,ParameterSetName="P1",position=0)]$username,
[parameter(Mandatory=$True,ParameterSetName="P2",position=0)]$groupname,
[validateset("Modify","Fullcontrol","ReadAndExecute","Read") ][parameter(Mandatory=$True)]$accessright,
[validateset("deny","Allow")][parameter(Mandatory=$True)]$AccessControlType,
[parameter(Mandatory=$True,ValuefromPipeline=$true)][array]$pathlist)

Try { import-module ActiveDirectory -ErrorAction Stop | Out-Null

if ($username)
    {
         try {
                Get-aduser $username -erroraction Stop | Out-Null
                $identity = $username
                
              }
         catch{
                Write-host "$username not found in AD" | out-null
                Exit 
              }
    }
elseif($groupname)
    {
             try {
                    Get-aduser $username -erroraction Stop 
                    $identity = $Groupname
                 }
             catch{
                   Write-host "$groupname not found in AD"
                   Exit
                  }
    } 
foreach ($path in $pathlist)
    {
        $acl = Get-Acl $path
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$accessright,"ContainerInherit,ObjectInherit","None",$AccessControlType)
        $acl.AddAccessRule($accessRule)
        Set-Acl $path $acl
    }
}
catch 
{Write-Error "This Script requires AD powershell Module" -Category CloseError }
<#
The security identifier ($Username);
Access rights (Modify);
Inheritance settings (ContainerInherit,ObjectInherit) which means to force all folders and files underneath the folder to inherit the permission we’re setting here;
Propagation settings (None) which is to not interfere with the inheritance settings;
Type (Allow).#>
}
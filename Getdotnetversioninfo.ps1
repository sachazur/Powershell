function Get-RemoteExecutionPolicy 
{
param ([parameter(Mandatory=$true,
                  ValueFromPipeline=$true,
                  Position=0)][string[]]$computer
       )
$dotNetRegistry  = 'SOFTWARE\Microsoft\NET Framework Setup\NDP'
$dotNet4Registry = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
$dotNet4Builds = @{
	30319  =  '.NET Framework 4.0'
	378389 = '.NET Framework 4.5'
	378675 = '.NET Framework 4.5.1 (8.1/2012R2)'
	378758 = '.NET Framework 4.5.1 (8/7 SP1/Vista SP2)'
	379893 = '.NET Framework 4.5.2' 
	393295 = '.NET Framework 4.6 (Windows 10)'
	393297 = '.NET Framework 4.6 (NON Windows 10)'
}
$RegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $computer)
if ($regKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4\Client') )
{
$netRegKey= $RegKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4\Client')
$netver = ($netRegKey.getvalue(“version”)).tostring()
}
elseif ($regKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4.0\Client') )
{
$netRegKey= $RegKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4.0\Client')
$netver = ($netRegKey.getvalue(“version”)).tostring()
}
elseif ($regKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.5') )
{
$netRegKey= $RegKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.5')
$netver = ($netRegKey.getvalue(“version”)).tostring()
}
elseif ($regKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.0') )
{
$netRegKey= $RegKey.OpenSubKey('SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0')
$netver = ($netRegKey.getvalue(“version”)).tostring()
}
elseif ($regKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v2.0.50727') )
{
$netRegKey= $RegKey.OpenSubKey('SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v2.0.50727')
$netver = ($netRegKey.getvalue(“version”)).tostring()
}

if ($RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\3”)) 
{
$PSRegKey= $RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\1\\ShellIds\\Microsoft.PowerShell”)
$Policy = ($PSRegKey.getvalue(“ExecutionPolicy”)).tostring()
$PSRegKey1= $RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\3\\PowerShellEngine”)
$Version = ($PSRegKey1.getvalue(“PowerShellVersion”)).tostring()
$serviceStatus = Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -computername $computer |select State 
#Return $Policy,$Version,$serviceStatus.state
$property = [ordered]@{
              'Computername'=$computer;
              'PSVersion' = $Version;
              'ExecutionPolicy' = $Policy
              'WinRMStatus' = $serviceStatus.state
              'NetFXVersion' = $netver
              
             }
$x= New-Object -TypeName PSobject -Property $property
$x

}
elseif ($RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\1”))
{
$PSRegKey= $RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\1\\ShellIds\\Microsoft.PowerShell”)
$Policy = ($PSRegKey.getvalue(“ExecutionPolicy”)).tostring()
$PSRegKey1= $RegKey.OpenSubKey(“SOFTWARE\\Microsoft\\Powershell\\1\\PowerShellEngine”)
$Version = ($PSRegKey1.getvalue(“PowerShellVersion”)).tostring()
$serviceStatus = Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -computername $computer |select State
#Return $Policy,$Version,$serviceStatus.state
$property = @{
              'Computername'=$computer;
              'PSVersion' = $Version;
              'ExecutionPolicy' = $Policy
              'WinRMStatus' = $serviceStatus.state
              'NetFXVersion' = $netver
              }
$y = New-Object -TypeName PSobject -Property $property
$y
}
else 
{
$serviceStatus = Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -computername $computer |select State
$property = @{
              'Computername'=$computer;
              'PSVersion' = "Not Installed"
              'ExecutionPolicy' = "Not Installed"
              'WinRMStatus' = $serviceStatus.state
              'NetFXVersion' =  $netver
              }
$z = New-Object -TypeName PSobject -Property $property
$z
}
}



$computerlist = Get-Content C:\sachin\Input.txt
foreach ($computer in $computerlist)
{
Get-RemoteExecutionPolicy -computer $computer | select @{l="COMName";e={$computer}},PSVersion,ExecutionPolicy,WinRMStatus,NetFXVersion | export-csv C:\sachin\PSSTD1.csv -Append
}
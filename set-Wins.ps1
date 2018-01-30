﻿function Set-DNSWINS {

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -ComputerName $_ | where{$_.IPEnabled -eq “TRUE”} 

Foreach($NIC in $NICs) {

$NI SetWINSServer("10.4.50.36","10.2.64.154")

$NIC.SetTcpIPNetBIOS("1")

}

}

function Get-FileName {

$comp1 = Read-Host “Complete Path of Filename”

return $comp1

}

$f = Get-FileName

Get-Content $f | foreach {Set-DNSWINS}


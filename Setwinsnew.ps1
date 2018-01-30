function Set-WINS {

$NICs = Get-WMIObject Win32_HtworkAdapterConfiguration -ComputerName $_ | where{$_.IPEnabled -eq “TRUE”} 

Foreach($NIC in $NICs) {

$NIC.SetWINSServer("10.16.75.53","10.2.64.105")

$NIC.SetTcpIPNetBIOS("1")

}

}

function Get-FileName {

$comp1 = Read-Host “Complete Path of Filename”

return $comp1

}

$f = Get-FileName

Get-Content $f | foreach {Set-WINS}


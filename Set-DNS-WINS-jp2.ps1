function Set-DNSWINS {
$NICs = Get-WM‚bject Win32_NetworkAdapterConfiguration -ComputerName $_ | where{$_.IPEnabled -eq “TRUE”} 
Foreach($NIC in $NICs) {
$DNSServers = "10.16.75.48","10.16.75.49","10.76.40.45","10.2.64.152"
$NIC.SetDNSServerSearchOrder($DNSServers)
$NIC.SetWINSServer("10.16.75.53","10.2.64.105")
$NIC.SetTcpIPNetBIOS("1")
}
}

function Get-FileName {
$comp1 = Read-Host “Complete Path of Filename”
return $comp1
}

$f = Get-FileName
Get-Content $f | foreach {Set-DNSWINS}

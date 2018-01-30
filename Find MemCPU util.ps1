$computer = read-host "enter computername here:"
Invoke-Command -ScriptBlock { Get-Process |Sort-Object -Property PM -Descending | Select-Object -First 5 @{l='Processname';e={$_.ProcessName}}, @{l='Memory Consumed';e={$_.PM/1MB}}, @{l='VM';e={$_.VM/1MB}}, @{l='CPU consumption';e={$_.cpu}}} -ComputerName $computer -credential hqdomain\_sachin.waghmare | Out-GridView
 
                                                    

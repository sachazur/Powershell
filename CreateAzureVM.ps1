function create-azurevm
{
 param(
       [parameter(Mandatory=$True,position=1)]$regionname,
       [parameter(Mandatory=$True,position=2)]
       [ValidateCount(10,15)]$dnsname,        
       [parameter(Mandatory=$false,position=2)]$imagefamily="Windows server 2012 R2 Datacenter",
       #[paramerter(Mandatory=$false)]$DNSname,
       [ValidateSet("ExtraSmall","small","Medium","Large")]$Size,
       [parameter(Mandatory=$false)]$storagename
       
      )

        Set-AzureSubscription -SubscriptionId "1b9dc417-cb58-4baa-b7d0-43d874612b78" 
        $username = "sachin"
        $password = "Cisco@1234"

        $imagename = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20151120-en.us-127GB.vhd"
#Get-AzureVMImage | where {$_.ImageFamily -like $imagefamily} | select imagename -First 1
               

        if (!(Test-AzureName -service $dnsname) -or !((get-azurelocation).DisplayName -contains "uk west"))
        {
          if (!(Get-AzureStorageAccount $storagename ))
          {
          New-AzureStorageAccount -StorageAccountName $storagename -Location $regionname
          start-sleep -Seconds 10
          }
          Set-AzureSubscription -SubscriptionId "1b9dc417-cb58-4baa-b7d0-43d874612b78" -CurrentStorageAccountName $storagename
          New-AzureQuickVM -Name $dnsname -Password $password -Location $regionname -AdminUsername $username -InstanceSize $Size -Verbose -ServiceName $dnsname -ImageName $imagename -Windows
          
        }
        else 
        {
        write-host "Check dnsname and region provided"
        }
         
        }


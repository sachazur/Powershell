[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms").location
[System.Reflection.Assembly]::LoadWithPartialName("System.drawing")
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms.filedialog")
Add-Type -AssemblyName "System.windows.forms"


function Import-ServerFile {
 
 $inputbox = New-Object System.Windows.Forms.OpenFileDialog
 $inputbox.ShowDialog()
 $inputbox.OpenFile()
 #$forms.Controls.Add($inputbox)

 


 $forms.controls.add($Listbox)
 $serverlist = Get-Content -Path $inputbox.FileName
 
 foreach ($server in $serverlist)
        {
         
         $Listbox.Items.Add($server)
        }
        

$gsv.Enabled = $true
$Listbox.Refresh()
$Clear.Enabled = $true
$ImportFile.Enabled = $false


}
function Getserver-Uptime {
 
  
 $label = New-Object System.Windows.Forms.Label
 $Label.Location = New-Object System.Drawing.Size(170,100)
 $Label.size = New-Object System.Drawing.size(80,20)
 $Label.AutoSize = $true
 
 $Serverlist = $Listbox.SelectedItems
 foreach ($server in $Serverlist)
 {
 $serverdetails = gwmi -Class win32_operatingsystem -ComputerName $server | Select-Object __server,@{l="Lastrestart";e={$_.converttodatetime($_.lastbootuptime)}}
 $property = [ordered]@{"Name"=$serverdetails.__SERVER;
                        "Status"=$serverdetails.lastrestart
                        }
  $label.Text = New-Object -TypeName psobject -Property $property
 }
  $forms.controls.add($label)

}

function Clear-listbox {
 
 
$itemcount = $Listbox.Items.Count
if ($itemcount -gt 0) {$Listbox.Items.Clear()}
$ImportFile.Enabled=$true
$gsv.Enabled = $false



}

$ImportFile = New-Object System.Windows.Forms.Button
$ImportFile.Location = New-Object System.Drawing.size(450,100)
$ImportFile.Size = New-Object System.Drawing.size(80,20)
$ImportFile.Text = "ImportFile-ServerFile"
$ImportFile.add_click({Import-ServerFile})
$forms = New-Object System.Windows.Forms.Form
$forms.Width = 500
$forms.Height = 200
$forms.Text = "Get-uptime"
$forms.AutoScale = $true
$forms.Controls.Add($ImportFile)
 
$GSV = New-Object System.Windows.Forms.Button
$GSV.Location = New-Object System.Drawing.size(450,135)
$GSV.Size = New-Object System.Drawing.size(80,20)
$GSV.Text = "GetUptime"
$GSV.add_click({Getserver-Uptime})
$gsv.Enabled = $false
$forms.Controls.Add($GSV)
$Clear = New-Object System.Windows.Forms.Button
$clear.Location = New-Object System.Drawing.size(450,175)
$clear.Size = New-Object System.Drawing.size(80,20)
$clear.Text = "Clear"
$clear.add_click({Clear-listbox})
$clear.Enabled = $false
$forms.Controls.Add($clear)
$global:Listbox = New-Object System.Windows.Forms.Listbox
 $Listbox.Location = New-Object System.Drawing.Size(10,100)
 $Listbox.size = New-Object System.Drawing.size(150,150)
 $Listbox.AutoSize = $true
<#$table = New-Object System.Data.DataTable
$table.Columns.add("Servername")
$table.Columns.add("Uptime")
$forms.Controls.Add($table)#>

$forms.ShowDialog()


#$Listbox.Items.ForEach( gwmi -Class win32_operatingsystem | Select-Object __server,@{l="Lastrestart";e={$_.converttodatetime($_.lastbootuptime)}}



#$forms.MaximumSize =  New-Object System.drawing.size(500,200)
<#$GSV = New-Object System.Windows.Forms.Button
$GSV.Location = New-Object System.Drawing.size(450,175)
$GSV.Size = New-Object System.Drawing.size(80,20)
$GSV.Text = "Get-service"
$GSV.add_click({serviceDisplay})
$forms.Controls.Add($GSV)#>









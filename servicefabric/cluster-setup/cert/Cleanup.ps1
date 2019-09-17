param(
   [string] [Parameter(Position=0, Mandatory = $true)] $Name
)

. "$PSScriptRoot\..\Common.ps1"

CheckLoggedIn

$ResourceGroupName = "ASF-$Name"

$location = (Get-AzureRmResourceGroup -Name $ResourceGroupName).Location
Remove-AzureRmResourceGroup -Name $ResourceGroupName

$dns = "$Name.$location.cloudapp.azure.com"

Remove-Item -Path "$PSScriptRoot\cert\certificate_details\$dns.thumb.txt"
Remove-Item -Path "$PSScriptRoot\cert\certificate_details\$dns.pwd.txt"
Remove-Item -Path "$PSScriptRoot\cert\certificate_details\$dns.base64.txt"

Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.subject -eq "CN=$dns" } | Remove-Item
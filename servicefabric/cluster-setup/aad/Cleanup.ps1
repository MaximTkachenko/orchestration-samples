param(
   [string] [Parameter(Position=0, Mandatory = $true)] $Name
)

. "$PSScriptRoot\..\Common.ps1"

CheckLoggedIn

$ResourceGroupName = "ASF-$Name"

$tenant = Get-AzureRmTenant

Remove-AzureRmResourceGroup -Name $ResourceGroupName

.\CleanupApplications.ps1 -TenantId $tenant.Id -WebApplicationName '$Name-Client' -NativeClientApplicationName '$Name-Cluster'
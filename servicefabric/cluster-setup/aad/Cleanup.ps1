param(
   [string] [Parameter(Position=0, Mandatory = $true)] $Name
)

. "$PSScriptRoot\..\Common.ps1"

CheckLoggedIn

Remove-AzureRmResourceGroup -Name "ASF-$Name"

$tenant = Get-AzureRmTenant

.\CleanupApplications.ps1 -TenantId $tenant.Id
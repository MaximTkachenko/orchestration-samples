param(
   [string] [Parameter(Position=0, Mandatory = $true)] $Name,
   [string] [Parameter(Position=1, Mandatory = $true)] $Location
)

. "$PSScriptRoot\..\Common.ps1"

CheckLoggedIn

$ResourceGroupName = "ASF-$Name"
$rdpPassword = "Password00;;"

Write-Host "Creating resource group..."
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

Write-Host "Creating keyvault..."
$vaultName = "$Name-kv"
$keyVault = New-AzureRmKeyVault -VaultName $vaultName -ResourceGroupName $ResourceGroupName -Location $Location
Set-AzureRmKeyVaultAccessPolicy -VaultName $vaultName -ResourceGroupName $ResourceGroupName -EnabledForTemplateDeployment -EnabledForDeployment

Write-Host "Creating certificate..."
$policy = New-AzureKeyVaultCertificatePolicy -SubjectName "CN=$Name.$Location.cloudapp.azure.com" -IssuerName Self -ValidityInMonths 12
$certificateName = "$Name-cert"
Add-AzureKeyVaultCertificate -VaultName $vaultName -Name $certificateName -CertificatePolicy $policy 

Write-Host "Getting tenantId..."
$tenant = Get-AzureRmTenant

Write-Host "Registering applications..."
$configobj = .\SetupApplications.ps1 -TenantId $tenant.Id -ClusterName $Name -WebApplicationReplyUrl "https://$Name.$Location.cloudapp.azure.com:19080/Explorer/index.html" -AddResourceAccess

Write-Host "Applying cluster template..."

Start-Sleep -Seconds 4
$cert = Get-AzureKeyVaultCertificate -VaultName $vaultName -Name $certificateName

$armParameters = @{
    namePart = $Name;
    certificateThumbprint = $cert.Thumbprint;
    sourceVaultResourceId = $keyVault.ResourceId;
    certificateUrlValue = $cert.SecretId;
    rdpPassword = $rdpPassword;
    vmInstanceCount = 3;
    durabilityLevel = "Bronze";
    reliabilityLevel = "Bronze";
    aadTenantId = $tenant.Id;
    aadClusterApplicationId = $configObj.WebAppId;
    aadClientApplicationId = $configObj.NativeClientAppId;
  }
New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $ResourceGroupName `
  -TemplateFile "$PSScriptRoot\servicefabric.json" `
  -Mode Incremental `
  -TemplateParameterObject $armParameters `
  -Verbose

<#
$dbParameters = @{
  sqlAdministratorLogin = "mtkadmin";
  sqlAdministratorLoginPassword = $rdpPassword;
  transparentDataEncryption = "Enabled";
}
New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $ResourceGroupName `
  -TemplateFile "$PSScriptRoot\..\dbdeploy.json" `
  -Mode Incremental `
  -TemplateParameterObject $dbParameters `
  -Verbose

$queueParameters = @{
  serviceBusNamespaceName = "mtk-sf-ns";
  serviceBusQueueName = "mtk-sf-queue";
}
New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $ResourceGroupName `
  -TemplateFile "$PSScriptRoot\..\queudeploy.json" `
  -Mode Incremental `
  -TemplateParameterObject $queueParameters `
  -Verbose
#>
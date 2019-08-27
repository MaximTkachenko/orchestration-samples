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
$certificateName = "$Name-cert"
$certThumbprint, $certPassword, $certPath = CreateSelfSignedCertificate $certificateName
$cert = ImportCertificateIntoKeyVault $vaultName $certificateName $certPath $certPassword

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
  }

New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $ResourceGroupName `
  -TemplateFile "$PSScriptRoot\servicefabric.json" `
  -Mode Incremental `
  -TemplateParameterObject $armParameters `
  -Verbose
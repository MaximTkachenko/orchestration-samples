[![Build Status](https://dev.azure.com/mtkorg/oss-projects/_apis/build/status/MaximTkachenko.orchestration-samples?branchName=master)](https://dev.azure.com/mtkorg/oss-projects/_build/latest?definitionId=8&branchName=master)

[Azure Resource Manager QuickStart Templates](https://github.com/Azure/azure-quickstart-templates)

## Install resources:
1. manually create key-vault, enable access policies (`Azure Virtual Machines for deployment`, `Azure Resource Manager for template deployment`), create self-signed certificate, update certificate parameters in `arm\sf\sfdeploy.parameters.json`
2. cleanup if needed 
```
az group delete --name mtk-asf
```
3. create resource group
```
az group create --name mtk-asf --location "Central US"
```
4. deploy db 
```
az group deployment create --name dbdeployment --resource-group mtk-asf --template-file dbdeploy.json --parameters dbdeploy.parameters.json
```
5. deploy queue
```
az group deployment create --name queuedeployment --resource-group mtk-asf --template-file queuedeploy.json --parameters queuedeploy.parameters.json
```
6. deploy sf cluster
```
az group deployment create --name sfdeployment --resource-group mtk-asf  --template-file sfdeploy.json --parameters sfdeploy.parameters.json
```

## Configure azure devops pipelines


## Configure gateway


## TODO
1. try to [Set up Azure Active Directory for client authentication](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-setup-aad)
2. try separate certificates for server and client
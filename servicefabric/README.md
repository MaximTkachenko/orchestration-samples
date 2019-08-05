[Azure Resource Manager QuickStart Templates](https://github.com/Azure/azure-quickstart-templates)

manually create key-vault + access policies and certificate and update sfdeploy.parameters.json

db:
```
az group create --name mtk-asf --location "Central US"

az group deployment create --name dbdeployment --resource-group mtk-asf --template-file dbdeploy.json --parameters dbdeploy.parameters.json

az group deployment create --name queuedeployment --resource-group mtk-asf --template-file queuedeploy.json --parameters queuedeploy.parameters.json

az group deployment create --name sfdeployment --resource-group mtk-asf  --template-file sfdeploy.json --parameters sfdeploy.parameters.json
```

```
az group delete --name mtk-asf
```

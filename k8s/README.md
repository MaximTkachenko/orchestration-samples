[Azure Resource Manager QuickStart Templates](https://github.com/Azure/azure-quickstart-templates)

## Steps to run:
1. ????
2. cleanup if needed 
```
az group delete --name mtk-ak8s
```
3. create resource group
```
az group create --name mtk-ak8s --location "Central US"
```
4. deploy db 
```
az group deployment create --name dbdeployment --resource-group mtk-ak8s --template-file dbdeploy.json --parameters dbdeploy.parameters.json
```
5. deploy queue
```
az group deployment create --name queuedeployment --resource-group mtk-ak8s --template-file queuedeploy.json --parameters queuedeploy.parameters.json
```
6. deploy sf cluster
```
az group deployment create --name k8sdeployment --resource-group mtk-ak8s  --template-file k8sdeploy.json --parameters k8sdeploy.parameters.json
```



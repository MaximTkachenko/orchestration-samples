- `aad` folder - install using AAD to access the cluster
- `cert` folder - install using client certificates to access the cluster

To cleanup environment:
- remove created resource group
- remove certificate from `current user/personal/certificates` in case of `cert`
- remive applications registered in AAD in case of `aad`
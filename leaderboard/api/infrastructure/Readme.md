# Infrastructure deployment scripts

## Usage 

### Provisioning Scripts

Login with your PowerShell console. 

```
Login-AzureRmAccount
```

Copy and Edit test.ps1.example. This script is deployment parameter script for testing. 
It will create a whole resources.

Change `YOUR_NUMBER` and `YOUR_PUBLIC_KEY`. You can change `YOUR_NUMBER` for every deployment. 
The whole deployment testing takes time. Some resources can't use the same name as it becomes DNS names. 
I recommend to change the NUMBER everitime not to use the same name to each deployment. Also I recommend 
to change `$environmentHeader` not to use the same name with others. 

```
cp test.ps1.example test.ps1
.\test.ps1
```

This script create these resources with Configuration.

* Resource Group
* CosmosDB
* Azure Functions with Function deployment
* Storage Account to store sharing files
* Azure Container Service (AKS)
* Azure Container Registry (ACR)
* KeyVault
* Proctor VM

### Team endpoint convertor

The application will convert a json file which contains a lot of endpoints of the Teams environment into 
`values.yaml` file of the helm chart. Also this converter upload the file to a blob storage which you create via the provisioning scripts.

```
.\convert.ps1 -ResourceGroup YOUR_RESOURCE_GROUP_NAME -StorageAccountName YOUR_STORAGE_ACCOUNT_NAME
```

## Next step 

Provisioning script deploy all environment with Azure Functions (Backend service works on Azure FunctionApp). Convertor will upload the `values.yaml` file to the storage account. Log in the Proctor VM. You will see the this project is cloned on that VM. 
Get the `values.yaml` from the blob storage then run the helm to deploy sentinel. 

 



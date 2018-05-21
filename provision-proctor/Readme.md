# Infrastructure deployment scripts

## Usage

### Provisioning Scripts

Login with your PowerShell console.

```shell
Login-AzureRmAccount
```

Create a public key using this format:
ssh-keygen -t rsa -b 2048 -C "proctor@microsoft.com" -f ./id_rsa

Change `YOUR_NUMBER`, `YOUR_PUBLIC_KEY`, and `YOUR_LOCATION` below.
The whole deployment takes time and will stop if there are any errors.

```shell
$YOUR_LOCATION = 'eastus'
$YOUR_NUMBER = '' # 3940
$YOUR_PUBLIC_KEY = '' # ssh-rsa AAAAB3NzaC1yc2EAAAADA... @microsoft.com
.\provision-proctor\deploy.ps1 -Location $YOUR_LOCATION -Number $YOUR_NUMBER -PublicKey $YOUR_PUBLIC_KEY
```

This script create these resources with Configuration.

* Resource Group
* CosmosDB
* Azure Functions with Function deployment
* Storage Account to store sharing files
* Azure Container Service (AKS)
* Azure Container Registry (ACR)
* KeyVault

### Team endpoint convertor

The application will convert a json file which contains a lot of endpoints of the Teams environment into `values.yaml` file of the helm chart. Also this converter uploads the file to a blob storage which you create via the provisioning scripts.

```shell
.\convert.ps1 -ResourceGroup YOUR_RESOURCE_GROUP_NAME -StorageAccountName YOUR_STORAGE_ACCOUNT_NAME
```

## Next step

Provisioning script deploy all environment with Azure Functions (Backend service works on Azure FunctionApp). Convertor will upload the `values.yaml` file to the storage account. Log in the Proctor VM. You will see the this project is cloned on that VM. Get the `values.yaml` from the blob storage then run the helm to deploy sentinel.
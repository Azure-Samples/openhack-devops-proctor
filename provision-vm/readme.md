# Infrastructure provisioning VM

## Pre-requisites

Have the Azure CLI installed and the username and password used to logon to the azure subscription.

## Usage

1. Login to the azure subscription

    ```shell
    az login --username='<AzureUserName>' --password='<AzurePassword>'
    ```

1. Create new resource group

    ```shell
    az group create --name="<ResourceGroupName>" --location="<Location>"
    ```

1. Run the deployment in that resource group

    ```shell
    az group deployment create --resource-group="<ResourceGroupName>" --template-file ./nologindeploy.json
    ```

Change `AzureUserName`, `ResourceGroupName`, and `Location` with your values.
This ARM template will run the ```../provision-vm/proctorVMSetup.sh``` script.

This installation does NOT install the team environment and is convinient when necessary to deploy to Azure subscriptions which require 2FA.

Use the private key provided in the OpenHack manual to logon to the team provisioning VM using the `-i <private_key>` parameter.

```shell
ssh -i ..\id_rsa azureuser@procohvm336.westus2.cloudapp.azure.com
```

## Using the portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2Fopenhack-devops-proctor%2Fnologin%2Fprovision-vm%2Flabdeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

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

1. Run the deployment in that resourcegroup

    ```shell
    az group deployment create --resource-group="<ResourceGroupName>" --template-file ./azuredeploy.json --parameters azureUserName='<AzureUserName>' azurePassword='<AzurePassword>'
    ```

Change `AzureUserName`, `AzureUserName`, `ResourceGroupName`, and `Location` with your values.
This ARM template will run the ```../provision-vm/proctorVMSetup.sh``` script and launch ```../provision-team/setup.sh``` as a background task.

The logs of the ```setup.sh``` script are located in ```/home/azureuser/openhack-devops-procotor/provision-team/teamdeploy.out```

**Note:** The ARM Template has been designed for one deployment in a given subscription. Other scenarios are at your own risk.

The full deployment takes about 30 min to complete. If the deployment of the ARM template has completed, it does not mean that the team setup script has completed.

Use the private key provided in the OpenHack manual to logon to the team provisioning VM using the `-i <private_key>` parameter.

```shell
ssh -i ..\id_rsa azureuser@procohvm336.westus2.cloudapp.azure.com
```

## Using the portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2Fopenhack-devops-proctor%2Fmaster%2Fprovision-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

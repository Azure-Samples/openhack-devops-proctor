# Infrastructure provisioning VM
 
## Pre-requisites

Have the Azure CLI installed (tested with version 2.0.49) and the username and password used to logon to the azure subscription.

## Usage

Open a shell promt in the `provision-vm` directory and run the follwing commands

1. Login to the azure subscription using your credentials

    ```shell
    az login --username='<AzureUserName>' --password='<AzurePassword>'
    ```
1. Create a service principal with the role owner in your subscription

    ```shell
    az ad sp create-for-rbac -n "http://DevOpsOHSP" --role owner
    ```

    Take note of the following:
        `appId`
        `password`
        `tenant`

1. Create new resource group

    ```shell
    az group create --name='ProctorVMRG' --location='<Location>'
    ```

1. Run the deployment in that resource group using the values from the service principal created in step 2.

    ```shell
    az group deployment create --resource-group='ProctorVMRG' --template-file ./azuredeploy.json --parameters spUserName=http://DevOpsOHSP spPassword='<password>' spTenant='<tenant>' spAppId='<appId>'
    ```

The deployment will first deploy and configure a virtual machine using the ```../provision-vm/proctorVMSetup.sh``` script. Subsequently ```../provision-team/setup.sh``` will be executed as a detached task on that virtual machine.

If needed for troubleshooting purposes, the logs of the ```setup.sh``` script are located in ```/home/azureuser/openhack-devops-procotor/provision-team/teamdeploy.out```

**Note:** The ARM Template has been designed for one deployment in a given subscription. Other scenarios are at your own risk.

The full deployment takes about 45 minutes to complete. The deployment of the ARM template will complete before the provisioning of the team environment has completed.

## Using the portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2Fopenhack-devops-proctor%2Fmaster%2Fprovision-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

# Team Infrastructure script

## Description

This script is used to install the Openhack team environment for the DevOps OpenHack.  This script will deploy all the necessary resources and configure the environment for a team to participate in the OpenHack.

## Pre-requisites

- Access to [MyDriving github repository](https://github.com/Azure-Samples/openhack-devops-team)
- [Generate ssh key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) to get openhack-team-cli
- [Helm](https://docs.helm.sh/using_helm/#installing-helm)
- Azure [AZ cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Docker](https://docs.docker.com/install/)
- [JQ](https://stedolan.github.io/jq/) (sudo apt-get install jq)

## Usage

    `./setup.sh -i <subscriptionId> -g <resourceGroupName> -l <resourceGroupLocation> -n <teamName> -e <teamNumber>`

**NOTE:** You must login to the target subscription, if you have not already done so using the azure cli, prior to executing the setup script for a team.

### Parameters

- SubscriptionId - id of the subscription to deploy the team infrastructure to
- resourceGroupLocation - Azure region to deploy to.  **_Must be a region that supports ACR, AKS, and KeyVault._**
- teamName - name of the team.  This value is used for the base name of all of the resources provisioned in Azure.  **_Must be all lowercase alphanumeric characters_**
- teamNumber (optional) - specific number for a team to provision.  If this is not specified, a random (3 character + 1 number) will be auto-generated.

An example command to provision with a random team number:

`./setup.sh -i 9d05a3cd-f0f4-439f-883e-c855e054 -l eastus -n devopsoh`

An example command to provision with a specific team number:
`./setup.sh -i 9d05a3cd-f0f4-439f-883e-c855e054 -l eastus -n devopsoh -e 01`

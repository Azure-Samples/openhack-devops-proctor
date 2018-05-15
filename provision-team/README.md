# Team Infrastructure script

## Description

## Pre-requisites

- Access to [MyDriving github repository](https://github.com/Azure-Samples/openhack-devops)
- Generete ssh key to get openhack-team-cli https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
- [Helm](https://docs.helm.sh/using_helm/#installing-helm)
- Azure [AZ cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [.net core 2.0.4](https://www.microsoft.com/net/download/) [Linux install](https://www.microsoft.com/net/download/linux-package-manager/ubuntu16-04/sdk-current)
- [Docker](https://docs.docker.com/install/)
- [JQ](https://stedolan.github.io/jq/) (sudo apt-get install jq)

## Usage

    `./setup.sh -i <subscriptionId> -g <resourceGroupName> -r <registryName> -c <clusterName> -l <resourceGroupLocation> -n <teamName>`

**NOTE:** You will be asked to login to your subscription if you have not already done so using the azure cli.

### Parameters

- SubscriptionId - id of the subscription to deploy the team infrastructure to
- resourceGroupLocation - Azure region to deploy to.  **_Must be a region that supports ACR, AKS, and KeyVault._**
- teamName - name of the team.  Containers and apps will use this value in provisioning.  **_Must be all lowercase alphanumeric characters_**

An example command to provision might look like the following:

`./setup.sh -i e57679d8-3a04-4828-97e6-35169ea30349 -l eastus -n devopsoh`
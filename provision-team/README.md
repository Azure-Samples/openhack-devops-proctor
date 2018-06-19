# Team Infrastructure script

## Description

This script is used to install the Openhack team environment for the DevOps OpenHack.  This script will deploy all the necessary resources and configure the environment for a team to participate in the OpenHack.

## Pre-requisites

The required pre-requisites for installing a tea environment are installed as part of proctor VM Setup.  The [setup script](https://raw.githubusercontent.com/Azure-Samples/openhack-devops-proctor/master/provision-vm/proctorVMSetup.sh) list all pre-reqs along with required versions.

## Usage

    `./setup.sh -i <subscriptionId> -l <resourceGroupLocation> -n <teamName> -e <teamNumber> `

**NOTE:** You must login to the target subscription, if you have not already done so using the azure cli, prior to executing the setup script for a team.

### Parameters

- SubscriptionId - id of the subscription to deploy the team infrastructure to
- resourceGroupLocation - Azure region to deploy to.  **_Must be a region that supports ACR, AKS, and KeyVault._**
- teamName - name of the team.  This value is used for the base name of all of the resources provisioned in Azure.  **_Must be all lowercase alphanumeric characters_**
- teamNumber (optional) - specific number for a team to provision.  If this is not specified, a random (3 character + 1 number) will be auto-generated.

An example command to provision with a random team number:

`./setup.sh -i <subscriptionId> -l eastus -n devopsoh`

An example command to provision with a specific team number:
`./setup.sh -i <subscriptionId> -l eastus -n devopsoh -e 01`
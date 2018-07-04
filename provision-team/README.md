# Team Infrastructure script

## Description

This script is used to install the Openhack team environment for the DevOps OpenHack.  This script will deploy all the necessary resources and configure the environment for a team to participate in the OpenHack.

## Pre-requisites

The required pre-requisites for installing a team environment are installed as part of proctor VM Setup.  The [setup script](https://raw.githubusercontent.com/Azure-Samples/openhack-devops-proctor/master/provision-vm/proctorVMSetup.sh) lists all pre-reqs along with required versions.

## Usage

    `nohup ./setup.sh -i <subscriptionId> -l <resourceGroupLocation> -n <teamName> -e <teamNumber> ><teamName><teamNumber>.out`

**NOTE: You must login to the target subscription, if you have not already done so using the azure cli, prior to executing the setup script for a team.**

### Parameters

- SubscriptionId - id of the subscription to deploy the team infrastructure to
- resourceGroupLocation - Azure region to deploy to.  **_Must be a region that supports ACR, AKS, and KeyVault._**
- teamName - name of the team.  This value is used for the base name of all of the resources provisioned in Azure.  **_Must be all lowercase alphanumeric characters_**
- teamNumber (optional) - specific number for a team to provision.  If this is not specified, a random (3 character + 1 number) will be auto-generated.

An example command to provision with a random team number:

`nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsoh >devopoh-random.out`

An example command to provision with a specific team number:

`nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsoh -e 1 >devopsoh1.out`

**Important** - The specific team number format should be used when provisioning an event with sequential numbers starting at 1 in order for the sentinels in the proctor environment to work properly. For example:

```bash
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 1 >devopsohseawa1.out
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 2 >devopsohseawa2.out
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 3 >devopsohseawa3.out
```

### After Script Execution

The `nohup` executes the script in the background even if the terminal disconnects. The output of what is currently running can be found by replacing `devopsoh1.out` with the value you specified and then executing the following from the same path where you ran the setup script:

```bash
tail -f devopsoh1.out
```

**Important** - Do not \<Ctrl\>+C break out of the window where you initiated the `nohup` setup script or the script will terminate.  Closing out the terminal window is acceptable and the script will continue to run assuming wherever the script host machine is run continues to have internet access.

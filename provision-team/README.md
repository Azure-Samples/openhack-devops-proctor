# Team Infrastructure script

## Description

This script is used to install the Openhack team environment for the DevOps OpenHack.  This script will deploy all the necessary resources and configure the environment for a team to participate in the OpenHack.

## Pre-requisites

The required pre-requisites for installing a team environment are installed as part of proctor VM Setup.  The [setup script](https://raw.githubusercontent.com/Azure-Samples/openhack-devops-proctor/master/provision-vm/proctorVMSetup.sh) lists all pre-reqs along with required versions.

## Usage

**NOTE**: Prior to executing the setup script below for a team, you must login against the target subscription. Skip it if you have already done so using the azure cli.

**NOTE**: Do not run this command as root (`sudo su` or `sudo [command]`). Run it using the standard user.

    `nohup ./setup.sh -i <subscriptionId> -l <resourceGroupLocation> -n <teamName> -e <teamNumber> ><teamName><teamNumber>.out &`

### Parameters

- SubscriptionId - id of the subscription to deploy the team infrastructure to
- resourceGroupLocation - Azure region to deploy to.  **_Must be a region that supports ACR, AKS, and KeyVault._**
- teamName - name of the team.  This value is used for the base name of all of the resources provisioned in Azure.  **_Must be all lowercase alphanumeric characters_**
- teamNumber (optional) - specific number for a team to provision.  If this is not specified, a random (3 character + 1 number) will be auto-generated.

An example command to provision with a random team number:

`nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsoh >devopoh-random.out &`

An example command to provision with a specific team number:

`nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsoh -e 1 >devopsoh1.out &`

**Important** - The specific team number format should be used when provisioning an event with sequential numbers starting at 1 in order for the sentinels in the proctor environment to work properly. For example:

```bash
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 1 >devopsohseawa1.out &
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 2 >devopsohseawa2.out &
nohup ./setup.sh -i <subscriptionId> -l eastus -n devopsohseawa -e 3 >devopsohseawa3.out &
```

The `nohup` command prevents the long running script (`setup.sh`) from being aborted when you exit the shell or logout.
The `&` indicates to run the script in the background to not block your current session.

The standard out of the script is written to the file indicated after the sign `>`.
Use the `tail` command to from the same path where you ran the setup script to monitor in real time what is written to the file:

```bash
tail -f devopsoh1.out
```

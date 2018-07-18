#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage:  ./deploy_jenkins.sh -g <resourceGroupName> -l <resourceGroupLocation> -p <jenkinsVMPassword> -u <jenkinsURL>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceGroupLocation=""
declare jenkinsVMPassword=""
declare jenkinsURL=""

    # Create a resource group.
    az group create --name $resourceGroupName --location $resourceGroupLocation

    # Create a new virtual machine, this creates SSH keys if not present.
    az vm create --resource-group $resourceGroupName --name $jenkinsURL --admin-username jenkins --admin-password $jenkinsVMPassword --image UbuntuLTS --public-ip-address-dns-name $jenkinsURL

    # Open port 22
    az vm open-port --port 80 --resource-group $resourceGroupName --name $jenkinsURL  --priority 101

    # Open port 80
    az vm open-port --port 22 --resource-group $resourceGroupName --name $jenkinsURL --priority 102

    # Open port 8080
    az vm open-port --port 8080 --resource-group $resourceGroupName --name $jenkinsURL --priority 103

    # Use CustomScript extension to install.
    az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $jenkinsURL --resource-group $resourceGroupName --settings '{"fileUris": ["https://raw.githubusercontent.com/OguzPastirmaci/openhack-jenkins-docker/master/config.sh"],"commandToExecute": "./config.sh"}'
#!/bin/bash

set -euox pipefail
IFS=$'\n\t'

usage() { echo "Usage:  ./deploy_jenkins.sh -g <resourceGroupName> -l <resourceGroupLocation> -p <jenkinsVMPassword> -u <jenkinsURL>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceGroupLocation=""
declare jenkinsVMPassword=""
declare jenkinsURL=""

# Initialize parameters specified from command line
while getopts ":g:l:p:u:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        p)
            jenkinsVMPassword=${OPTARG}
        ;;
        u)
            jenkinsURL=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing
if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "
    echo "Enter resource group location:"
    read resourceGroupLocation
    [[ "${resourceGroupLocation:?}" ]]
fi

if [[ -z "$jenkinsVMPassword" ]]; then
    echo "Enter a password for the Jenkins VM:"
    read jenkinsVMPassword
fi

if [[ -z "$jenkinsURL" ]]; then
    echo "Enter a DNS label for the Jenkins VM:"
    read jenkinsURL
fi


    # Create a resource group.
    az group create --name $resourceGroupName --location $resourceGroupLocation

    # Create a new virtual machine, this creates SSH keys if not present.
    az vm create --resource-group $resourceGroupName --name $jenkinsURL --admin-username jenkins --admin-password $jenkinsVMPassword --image UbuntuLTS --public-ip-address-dns-name $jenkinsURL

    # Open port 22
    az vm open-port --port 22 --resource-group $resourceGroupName --name $jenkinsURL  --priority 101

    # Open port 8080
    az vm open-port --port 8080 --resource-group $resourceGroupName --name $jenkinsURL --priority 102

    # Use CustomScript extension to install.
    # az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $jenkinsURL --resource-group $resourceGroupName --settings '{"fileUris": ["https://raw.githubusercontent.com/Azure-Samples/openhack-devops-proctor/jenkins-security/provision-team/configure_jenkins.sh"],"commandToExecute": "./configure_jenkins.sh $jenkinsVMPassword"}'
    az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $jenkinsURL --resource-group $resourceGroupName --protected-settings "{\"fileUris\": [\"https://raw.githubusercontent.com/Azure-Samples/openhack-devops-proctor/jenkins-security/provision-team/configure_jenkins.sh\"], \"commandToExecute\": \"./configure_jenkins.sh $jenkinsVMPassword\"}"
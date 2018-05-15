#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: provision_acr.sh -i <subscriptionId> -g <resourceGroupName> -r <registryName> -l <resourceGroupLocation>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare registryName=""
declare resourceGroupLocation=""

# Initialize parameters specified from command line
while getopts ":i:g:r:l:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
        ;;
        g)
            resourceGroupName=${OPTARG}
        ;;
        r)
            registryName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
    echo "Your subscription ID can be looked up with the CLI using: az account show --out json "
    echo "Enter your subscription ID:"
    read subscriptionId
    [[ "${subscriptionId:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$registryName" ]]; then
    echo "Enter a name for the Azure Container Registry you want to create:"
    read registryName
fi

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "

    echo "Enter resource group location:"
    read resourceGroupLocation
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$registryName" ]; then
    echo "Either one of subscriptionId, resourceGroupName, registryName is empty"
    usage
fi

echo "Creating Registry..."
(
    set -x
    az acr create -g $resourceGroupName --name $registryName --location $resourceGroupLocation --sku Basic --admin-enabled true 1> /dev/null
)

if [ $? == 0 ];
then
    echo "Azure Container Registry" $registryName "created successfully..."
fi

# This step so that we don't need to do role assignement
echo "Enable Registry for admin authentication" 
(
    az acr update -n $registryName --admin-enabled true
)

if [ $? == 0 ];
then
    echo "Azure Container Registry" $registryName "successfully enabled for admin..."
fi
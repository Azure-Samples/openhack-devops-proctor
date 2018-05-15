#!/bin/bash

usage() { echo "Usage: provision_kv.sh -i <subscriptionId> -g <resourceGroupName> -k <keyVaultName> -l <keyVaultLocation>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare keyVaultName=""
declare keyVaultLocation=""

# Initialize parameters specified from command line
while getopts ":i:g:k:l:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
        ;;
        g)
            resourceGroupName=${OPTARG}
        ;;
        k)
            keyVaultName=${OPTARG}
        ;;
        l)
            keyVaultLocation=${OPTARG}
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

if [[ -z "$keyVaultLocation" ]]; then
    echo "You can lookup locations with the CLI using"

    echo "Enter KeyVault location:"
    read keyVaultLocation
fi

if [[ -z "$keyVaultName" ]]; then
    echo "Name of KeyVault"

    echo "Enter KeyVault Name:"
    read keyVaultName
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$keyVaultName" ]; then
    echo "Either one of subscriptionId, resourceGroupName, keyVaultName is empty"
    usage
fi

echo "KeyVault..."
(
    set -x
    az keyvault create -g $resourceGroupName --name $keyVaultName --location $keyVaultLocation > /dev/null
)

if [ $? == 0 ];
then
    echo " KeyVault" $keyVaultName "created successfully..."
fi

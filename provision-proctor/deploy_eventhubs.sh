#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy_eventhubs.sh -g <resourceGroupName> -n <namespaceName> -l <location>" 1>&2; exit 1; }

declare resourceGroupName=""
declare namespaceName=""
declare location=""
# Initialize parameters specified from command line
while getopts ":g:n:l:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        n)  
            namespaceName=${OPTARG}
        ;;
        l)
            location=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))


if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi


if [[ -z "$namespaceName" ]]; then
    echo "Enter the name of the namespace name of the EventHubs:"
    read namespaceName
fi

if [[ -z "$location" ]]; then
    echo "Enter the name of the location of the EventHubs:"
    read location
fi


#DEBUG
echo $resourceGroupName
echo $namespaceName
echo $location
echo -e "\n"

# create EventHubs namespace , name must be lowercase.
az eventhubs namespace create -n $namespaceName -g $resourceGroupName -l $location --sku Basic 
az eventhubs namespace create -g dooh2tsushipro0109-rg -n dooh2tsushisome -l eastus --sku Basic

# create EventHub name

 az eventhubs eventhub create --name downtime --namespace-name $namespaceName -g $resourceGroupName --message-retention 1 --partition-count 2


#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy.sh -g <resourceGroupName> -n <cosmosDBName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceBaseName=""
# Initialize parameters specified from command line
while getopts ":g:n:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        n)  
            cosmosDBName=${OPTARG}
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


if [[ -z "$cosmosDBName" ]]; then
    echo "Enter the name of the cosmosDB:"
    read cosmosDBName
fi

#DEBUG
echo $resourceGroupName
echo $cosmosDBName
echo -e "\n"

# create cosmosdb database, name must be lowercase.
az cosmosdb create --name $cosmosDBName --resource-group $resourceGroupName 


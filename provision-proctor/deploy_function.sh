#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy.sh -g <resourceGroupName>  -l <location> -s <storageAccountName> -f <functionAppName> -c <cosmosDBName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare location=""
declare storageAccountName=""
declare functionAppName=""
declare cosmosDBName=""
# Initialize parameters specified from command line
while getopts ":g:l:s:f:c:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        l)  
            location=${OPTARG}
        ;;
        s)  
            storageAccountName=${OPTARG}
        ;;        
        f)  
            functionAppName=${OPTARG}
        ;;
        c)
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

if [[ -z "$location" ]]; then
    echo "Enter the resources location where the proctor environment were provisioned:"
    read location
fi

if [[ -z "$storageAccountName" ]]; then
    echo "Enter the storage account name used by the Azure function:"
    read location
fi

if [[ -z "$functionAppName" ]]; then
    echo "Enter the azure function name which is used for the Function App:"
    read functionAppName
fi

if [[ -z "$cosmosDBName" ]]; then
    echo "Enter the azure function name which is used for the Function App:"
    read cosmosDBName
fi


#DEBUG
echo $resourceGroupName
echo $location
echo $functionAppName
echo $storageAccountName
echo $cosmosDBName
echo -e "\n"


# create a storage account 
az storage account create --name $storageAccountName --location $location  --resource-group $resourceGroupName --sku Standard_LRS

# upload

# TODO upload zipfile to the storage account.
#  https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli


# Retrieve cosmosdb connection string
cosmosdbEndpoint=$(az cosmosdb show --name $cosmosDBName  --resource-group $resourceGroupName --query documentEndpoint --output tsv)
cosmosdbKey=$(az cosmosdb list-keys --name $cosmosDBName  --resource-group $resourceGroupName --query primaryMasterKey --output tsv)

# create a new function app, assign it to the resource group you have just created
az functionapp create --name $functionAppName --resource-group $resourceGroupName --storage-account $storageAccountName --consumption-plan-location $location


# configure function app settings to use cosmosdb connection string
# This part include Run-From-Zip deployment
# TODO:
# enalbe Application Insights (currently not supported on Azure CLI)
# enable beta version (just add AppSettings, I'll do it after wake up.)
# Run-From-Zip deployment. https://github.com/Azure/app-service-announcements/issues/84
az functionapp config appsettings set --name $functionAppName --resource-group $resourceGroupName --setting CosmosDB_Endpoint=$cosmosdbEndpoint CosmosDB_Key=$cosmosdbKey WEBSITE_RUN_FROM_ZIP=HERE_IS_ZIP_URL
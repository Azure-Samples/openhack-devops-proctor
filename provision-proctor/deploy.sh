#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy.sh -r <resourceGroupName>  -l <location> -b <resourceBaseName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare location=""
declare resourceBaseName=""
# Initialize parameters specified from command line
while getopts ":r:l:b:" arg; do
    case "${arg}" in
        r)
            resourceGroupName=${OPTARG}
        ;;
        l)  
            location=${OPTARG}
        ;;
        b)  
            resourceBaseName=${OPTARG}
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

if [[ -z "$resourceBaseName" ]]; then
    echo "Enter the resource base name which is used for the base name of Function App and Storage Account:"
    read resourceBaseName
fi

functionAppName=$resourceBaseName
storageAccountBase=$resourceBaseName

# Generate Random value to avoid duplication of the Storage Account

footerNum=$(( $RANDOM % 100000 + 1))
footer=$(printf "%06d" $i)
storageAccount=$storageAccountBase$footer

#DEBUG
echo $resourceGroupName
echo $location
echo $functionAppName
echo $storageAccount 
echo -e `\n`


# create a resource group with location
az group create \
  --name $resourceGroupName \
  --location $location

# create a storage account 
storageAccountPostFix="dbstore"

az storage account create \
  --name $resourceBaseName$storageAccountPostFix \
  --location $location \
  --resource-group $resourceGroupName \
  --sku Standard_LRS

# upload

# TODO upload zipfile to the storage account.
#  https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli


# create a new function app, assign it to the resource group you have just created
functionappPostFix="cosmosdb"
functionappName=$resourceBaseName$functionappPostFix
az functionapp create \
  --name $functionappName \
  --resource-group $resourceGroupName \
  --storage-account $storageAccount \
  --consumption-plan-location $location

# create cosmosdb database, name must be lowercase.
cosmosDBPostFix="cosmosdb"
cosmosDBName=$resourceBaseName$cosmosDBPostFix
az cosmosdb create \
  --name $cosmosDBName \
  --resource-group $resourceGroupName

# Retrieve cosmosdb connection string
endpoint=$(az cosmosdb show \
  --name $cosmosDBName \
  --resource-group $resourceGroupName \
  --query documentEndpoint \
  --output tsv)

key=$(az cosmosdb list-keys \
  --name $cosmosDBName \
  --resource-group $resourceGroupName \
  --query primaryMasterKey \
  --output tsv)

# configure function app settings to use cosmosdb connection string
# This part include Run-From-Zip deployment
# TODO:
# enalbe Application Insights (currently not supported on Azure CLI)
# enable beta version (just add AppSettings, I'll do it after wake up.)
# Run-From-Zip deployment. https://github.com/Azure/app-service-announcements/issues/84
az functionapp config appsettings set \
  --name $functionappName \
  --resource-group $resourceGroupName \
  --setting CosmosDB_Endpoint=$endpoint CosmosDB_Key=$key WEBSITE_RUN_FROM_ZIP=HERE_IS_ZIP_URL
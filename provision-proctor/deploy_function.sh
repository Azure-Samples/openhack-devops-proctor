#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy_function.sh -g <resourceGroupName>  -l <location> -s <storageAccountName> -f <functionAppName> -c <cosmosDBName> -z <zipFileName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare location=""
declare storageAccountName=""
declare functionAppName=""
declare cosmosDBName=""
declare zipFileName=""
# Initialize parameters specified from command line
while getopts ":g:l:s:f:c:z:" arg; do
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
        z)
            zipFileName=${OPTARG}
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

if [[ -z "$zipFileName" ]]; then
    echo "Enter the azure function app zip file name which is used for the Function App:"
    read zipFileName
fi

#DEBUG
echo $resourceGroupName
echo $location
echo $functionAppName
echo $storageAccountName
echo $cosmosDBName
echo $zipFileName
echo -e "\n"

echo -e "Creating a storage account\n"
az storage account create --name $storageAccountName --location $location  --resource-group $resourceGroupName --sku Standard_LRS

echo -e "Uploading zipfile to the storage account\n"
storageConnectionString=$(az storage account show-connection-string -g $resourceGroupName -n $storageAccountName --query connectionString --output tsv)
az storage container create --name container --public-access blob --connection-string $storageConnectionString
az storage blob upload --container-name container --file $zipFileName --name $zipFileName --connection-string $storageConnectionString

zipFileUrl=https://$storageAccountName.blob.core.windows.net/container/$zipFileName

echo -e "Retrieving cosmosdb connection string\n"
cosmosdbEndpoint=$(az cosmosdb show --name $cosmosDBName  --resource-group $resourceGroupName --query documentEndpoint --output tsv)
cosmosdbKey=$(az cosmosdb list-keys --name $cosmosDBName  --resource-group $resourceGroupName --query primaryMasterKey --output tsv)

echo -e "Creating a new function app, assigning it to the resource group just created\n"
az functionapp create --name $functionAppName --resource-group $resourceGroupName --storage-account $storageAccountName --consumption-plan-location $location

echo -e "Configuring function app settings to use cosmosdb connection string\n"
az functionapp config appsettings set --name $functionAppName --resource-group $resourceGroupName --setting CosmosDB_Endpoint=$cosmosdbEndpoint CosmosDB_Key=$cosmosdbKey WEBSITE_RUN_FROM_ZIP=$zipFileUrl FUNCTIONS_EXTENSION_VERSION=beta

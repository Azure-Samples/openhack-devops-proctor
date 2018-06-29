#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy_stream_analytics.sh -g <resourceGroupName> -n <streamAnalyticsJobName> -l <location> -e <eventHubsNamespace> -c <cosmosDBName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare streamAnalyticsJobName=""
declare location=""
declare eventHubsNamespace="" # Input_downtime_serviceBusNamespace
# declare eventHubPrimaryKey="" # Input_downtime_sharedAccessPolicyKey
declare cosmosDBName="" # Output_cosmosdb_accountId
# declare cosmosDBKey=""  # Output_cosmosdb_accountKey

# Initialize parameters specified from command line
while getopts ":g:n:l:e:c:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        n)
            streamAnalyticsJobName=${OPTARG}
        ;;        
        l)  
            location=${OPTARG}
        ;;
        e)  
            eventHubsNamespace=${OPTARG}
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

if [[ -z "$streamAnalyticsJobName" ]]; then
    echo "Enter the stream analytics job name:"
    read streamAnalyticsJobName
    [[ "${streamAnalyticsJobName:?}" ]]
fi

if [[ -z "$location" ]]; then
    echo "Enter the resources location where the proctor environment were provisioned:"
    read location
fi

if [[ -z "$eventHubsNamespace" ]]; then
    echo "Enter the eventhubs namespace:"
    read eventHubsNamespace
fi

if [[ -z "$cosmosDBName" ]]; then
    echo "Enter the cosmosDBName:"
    read cosmosDBName
fi

#DEBUG
echo $resourceGroupName
echo $streamAnalyticsJobName
echo $location
echo $eventHubsNamespace
echo $cosmosDBName
echo -e "\n"

echo -e "Retrieving cosmosdb connection string\n"
cosmosdbKey=$(az cosmosdb list-keys --name $cosmosDBName  --resource-group $resourceGroupName --query primaryMasterKey --output tsv)

echo -e "Retriving eventhubs primary key string\n"
eventhubsKey=$(az eventhubs namespace authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventHubsNamespace --name RootManageSharedAccessKey --query primaryKey --output tsv)

az group deployment create --name StreamAnalyticsDeployment --resource-group $resourceGroupName --template-file stream_analytics_arm_template.json --parameters @stream_analytics_arm_parameter.json --parameters StreamAnalyticsJobName=$streamAnalyticsJobName Location=$location Input_downtime_serviceBusNamespace=$eventHubsNamespace Input_downtime_sharedAccessPolicyKey=$eventhubsKey Output_cosmosdb_accountId=$cosmosDBName Output_cosmosdb_accountKey=$cosmosdbKey


# Start Stream Analytics Job

echo -e "Starting Stream Analytics Job\n"
token=$(az account get-access-token --query accessToken --output tsv)
subscriptionId=$(az account show --query id --output tsv)

curl -X POST https://management.azure.com/subscriptions/$subscriptionId/re
sourceGroups/$resourceGroupName/providers/Microsoft.StreamAnalytics/streamingjobs/$streamAnalyticsJobName/start?api-version=
2015-10-01 -H "Authorization: Bearer $token" -H "Content-type: application/json" -d '{"outputStartMode" : "JobStartTime"}' -v

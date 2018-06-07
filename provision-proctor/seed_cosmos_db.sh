#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: seed_cosmos_db.sh -g <resourceGroupName>  -c <cosmosDBName> -s <openhackStartTime> -e <openhackEndTime> -n <number of challenges>" 1>&2; exit 1; }

declare resourceGroupName=""
declare cosmosDBName=""
declare openhackStartTime=""
declare openhackEndTime=""
declare databaseId="leaderboard"
declare nubmerOfChallenges=""

# Initialize parameters specified from command line
while getopts ":g:c:s:e:n:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        c)  
            cosmosDBName=${OPTARG}
        ;;
        s)  
            openhackStartTime=${OPTARG}
        ;;        
        e)  
            openhackEndTime=${OPTARG}
        ;;
        n)  
            nubmerOfChallenges=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))


if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$cosmosDBName" ]]; then
    echo "Enter the cosmosDBName where the proctor environment were provisioned:"
    read cosmosDBName
fi

if [[ -z "$openhackStartTime" ]]; then
    echo "Enter the start time of the openhack. (e.g. 2018-09-10T08:00:00):"
    read openhackStartTime
fi

if [[ -z "$openhackEndTime" ]]; then
    echo "Enter the end time of the openhack (e.g. 2018-09-12T17:00:00):"
    read openhackEndTime
fi

if [[ -z "$nubmerOfChallenges" ]]; then
    echo "Enter the number of the challenges of the openhack:"
    read nubmerOfChallenges
fi

#DEBUG
echo $resourceGroupName
echo $cosmosDBName
echo $openhackStartTime
echo $openhackEndTime
echo $nubmerOfChallenges
echo -e "\n"


# Build the DB Seed. 
pushd .
cd ../leaderboard/api/CLI
dotnet restore
dotnet build

# cd bin/Release/netcoreapp2.0/publish

# Getting CosmosDB Endpoint and keys
echo -e "Retrieving cosmosdb connection string\n"
cosmosdbEndpoint=$(az cosmosdb show --name $cosmosDBName  --resource-group $resourceGroupName --query documentEndpoint --output tsv)
cosmosdbKey=$(az cosmosdb list-keys --name $cosmosDBName  --resource-group $resourceGroupName --query primaryMasterKey --output tsv)

# Pass the environment varialbes 

export COSMOSDB_ENDPOINT_URL=$cosmosdbEndpoint
export COSMOSDB_PRIMARY_KEY=$cosmosdbKey
export COSMOSDB_DATABASE_ID=$databaseId
export NUMBER_OF_CHALLENGES=$nubmerOfChallenges
export OPENHACK_START_TIME=$openhackStartTime
export OPENHACK_END_TIME=$openhackEndTime

# TODO: Currently, I use service.json to get Endpoint for Service collection.
# However, now we don't need it. We can remove it if we don't need it on the cosmos db.
if [ -f team_service_config.json ]; then
# Execute the command 
    dotnet run
else 
echo "Missing the config file team_service_config.json Please create one. "
exit 1
fi 

popd
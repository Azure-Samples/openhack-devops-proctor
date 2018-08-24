#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#script requires latest version of .netcore to be installed ()

usage() { echo "Usage: build_deploy_leaderboard_batch.sh -r <resourceGroupName> -l <location> -t <image tag> -g <registry name> -m <proctorName> -u <proctorNumber>" 1>&2; exit 1; }


declare resourceGroupName=""
declare imageTag=""
declare registryName=""
declare proctorName=""
declare proctorNumber=""

# Initialize parameters specified from command line
while getopts ":r:l:t:g:m:u" arg; do
    case "${arg}" in
        r)
            resourceGroupName=${OPTARG}
        ;;
        l)
            location=${OPTARG}
        ;;
        t)
            imageTag=${OPTARG}
        ;;
        g)
            registryName=${OPTARG}
        ;;
        m)
            proctorName=${OPTARG}
        ;;
        u)
            proctorNumber=${OPTARG}
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
    echo "You can lookup locations with the CLI using"

    echo "Enter location:"
    read location
fi

if [[ -z "$imageTag" ]]; then
    echo "This script requires name and optionally a tag in the 'name:tag' format"
    echo "Enter an image tag "
    read imageTag
    [[ "${imageTag:?}" ]]
fi

if [ -z "$resourceGroupName" ] || [ -z "$location"] || [ -z "$imageTag" ] ; then
    echo "Either one of resourceGroupName, location, or imageTag is empty"
    usage
fi

#DEBUG
echo "Resource Group:" $resourceGroupName
echo "Image:" $imageTag

#get the acr repository id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/"$imageTag

echo "TAG: "$TAG

pushd ../leaderboard/batch/Batch

docker build . -t $TAG

docker push $TAG

echo -e "\nSuccessfully pushed image: "$TAG

popd

# create a storage account for azure function
randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo $(( $RANDOM % 10 ))
}


storageAccountName="opdevopssa$(randomChar;randomChar;ranomChar;randomNum;)" 

az storage account create --name $storageAccountName --location $location  --resource-group $resourceGroupName --sku Standard_LRS

# Fetching Storage Account connection string

storageConnectionString=$(az storage account show-connection-string -g $resourceGroupName -n $storageAccountName --query connectionString --output tsv)

# Fetching SQL connection string from 

sqlServerName=$(kvstore get ${proctorName}${proctorNumber} sqlServerName)
sqlServerUserName=$(kvstore get ${proctorName}${proctorNumber} sqlServerUserName)
sqlServerPassword=$(kvstore get ${proctorName}${proctorNumber} sqlServerPassword)
sqlDbName=$(kvstore get ${proctorName}${proctorNumber} sqlDbName)

sqlConnectionString="Server=tcp:$sqlServerName.database.windows.net,1433;Initial Catalog=$sqlDbName;Persist Security Info=False;User ID=$sqlServerUserName;Password=$sqlServerPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

# Create a secrets for Storage Account and SQL database conection string

kubectl create secret generic functions --type=string --from-literal=storage_connection_string="$storageConnectionString" --from-literal=sql_connection_string="$sqlConnectionString"

installPath="../leaderboard/batch/helm"
echo -e "\nhelm install from: " $installPath "\n\n"

helm install $installPath --name leaderboardbatch --set image.repository=$TAG

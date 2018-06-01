#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: build_deploy_sentinel.sh -r <resourceGroupName> -g <acr registry name> -n <teamName> -e <number of teams> -l <location> -a <apiUrl>" 1>&2; exit 1; }

declare resourceGroupName=""
declare imageTag=""
declare registryName=""
declare resourceGroupLocation=""

# Initialize parameters specified from command line
while getopts ":r:g:n:e:a:" arg; do
    case "${arg}" in
        r)
            resourceGroupName=${OPTARG}
        ;;
        g)  
            registryName=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        e)
            totalTeams=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        a)
            apiUrl=${OPTARG}
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

if [[ -z "$registryName" ]]; then
    echo "This script requires the acr registry name"
    echo "Enter a registry name"
    read registryName
    [[ "${registryName:?}" ]]
fi

if [ -z "$resourceGroupName" ] || [ -z "$registryName" ]; then
    echo "One of resourceGroupName, imageTag, or registryName are empty"
    usage
fi

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "

    echo "Enter resource group location:"
    read resourceGroupLocation
fi

#DEBUG
echo $resourceGroupName
echo $imageTag

echo -e '\n'

#get the acr repsotiory id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/sentinel"

echo "TAG: "$TAG

pushd ../leaderboard/sentinel

docker build . -t $TAG

docker push $TAG
echo "Successfully pushed image: "$TAG

popd

installPath="../leaderboard/sentinel/helm"
echo -e "\nhelm install ... from: " $installPath

helm install $installPath --name sentinel --set image.repository=$TAG,teams.totalNumber=$totalTeams,teams.location=$resourceGroupLocation,teams.baseName=$teamName,teams.apiUrl=$apiURL

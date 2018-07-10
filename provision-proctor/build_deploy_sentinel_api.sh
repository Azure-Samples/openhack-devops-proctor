#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#script requires latest version of .netcore to be installed ()

usage() { echo "Usage: build_deploy_sentinel_api.sh -b <build flavor> -r <resourceGroupName>  -t <image tag> -d <dns host Url> -n <team name> -g <registry name>" 1>&2; exit 1; }

declare buildFlavor=""
declare resourceGroupName=""
declare imageTag=""
declare dnsUrl=""
declare teamName=""
declare registryName=""

# Initialize parameters specified from command line
while getopts ":b:r:t:d:n:g:" arg; do
    case "${arg}" in
        b)
            buildFlavor=${OPTARG}
        ;;
        r)
            resourceGroupName=${OPTARG}
        ;;
        t)
            imageTag=${OPTARG}
        ;;
        d)
            dnsUrl=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        g)
            registryName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$buildFlavor" ]]; then
    echo "Enter a build flavor (Debug, Release)"
    read buildFlavor
    [[ "${buildFlavor:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$imageTag" ]]; then
    echo "This script requires name and optionally a tag in the 'name:tag' format"
    echo "Enter an image tag "
    read imageTag
    [[ "${imageTag:?}" ]]
fi

if [[ -z "$dnsUrl" ]]; then
    echo "Public DNS address where the API will be hosted behind."
    echo "Enter public DNS name."
    read dnsUrl
    [[ "${dnsUrl:?}" ]]
fi

if [ -z "$buildFlavor" ] || [ -z "$resourceGroupName" ] || [ -z "$imageTag" ] || [ -z "$dnsUrl" ]; then
    echo "Either one of buildFlavor, resourceGroupName, imageTag, or dnsUrl is empty"
    usage
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name for the helm chart values filename:"
    read teamName
fi

#DEBUG
echo "Build Flavor:" $buildFlavor
echo "Resource Group:" $resourceGroupName
echo "Image:" $imageTag
echo "DNS Url:" $dnsUrl

#get the acr repository id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/"$imageTag

echo "TAG: "$TAG

pushd ../leaderboardv2/api/web

docker build . -t $TAG

docker push $TAG

echo -e "\nSuccessfully pushed image: "$TAG

popd

installPath="../leaderboardv2/api/web/helm"
echo -e "\nhelm install from: " $installPath "\n\n"

BASE_URI='http://'$dnsUrl
echo "Base URI: $BASE_URI"
helm install $installPath --name sentinel-api --set repository.image=$TAG,env.webServerBaseUri=$BASE_URI,ingress.rules.endpoint.host=$dnsUrl

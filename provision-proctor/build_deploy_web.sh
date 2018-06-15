#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: build_deploy_web.sh -m <proctorName> -f <functionAppName> -d <dnsURL>" 1>&2; exit 1; }

declare proctorName=""
declare functionAppName=""

# Initialize parameters specified from command line
while getopts ":m:f:d:" arg; do
    case "${arg}" in
        m)
            proctorName=${OPTARG}
        ;;
        f)
            functionAppName=${OPTARG}
        ;;
        d)
            dnsURL=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))


# if [[ -z "$resourceGroupName" ]]; then
#     echo "This script will look for an existing resource group, otherwise a new one will be created "
#     echo "You can create new resource groups with the CLI using: az group create "
#     echo "Enter a resource group name"
#     read resourceGroupName
#     [[ "${resourceGroupName:?}" ]]
# fi

if [[ -z "$proctorName" ]]; then
    echo "Enter a team name for the helm chart values filename:"
    read proctorName
fi

if [[ -z "$dnsURL" ]]; then
    echo "Public DNS address where the API will be hosted behind."
    echo "Enter public DNS name."
    read dnsUrl
    [[ "${dnsURL:?}" ]]
fi

if [ -z "$proctorName" ] || [ -z "$dnsURL" ]; then
    echo "A parameter is missing."
    usage
fi

if [[ -z "$functionAppName" ]]; then
    echo "Enter the azure function name which is used for the Function App:"
    read functionAppName
fi

declare resourceGroupName="${proctorName}-rg"
declare registryName="${proctorName}acr"

#DEBUG
echo $resourceGroupName
echo $dnsURL
echo $proctorName
echo -e '\n'

#get the acr repsotiory id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/"leaderboard

echo "TAG: "$TAG

pushd ../leaderboard/web

docker build --build-arg FUNCTION_NAME="${functionAppName}" . -t $TAG

docker push $TAG
echo "Successfully pushed image: "$TAG

popd

installPath="../leaderboard/web/helm"
echo -e "\nhelm install ... from: " $installPath

BASE_URI='http://'$dnsURL
echo "Base URI: $BASE_URI"
helm install $installPath --name leaderboard --set repository.image=$TAG,ingress.rules.endpoint.host=$dnsURL

#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: build_deploy_tripviewer.sh -m <teamName> -d <dnsURL> -j <bingAPIkey>" 1>&2; exit 1; }

declare teamName=""
declare dnsURL=""
declare bingAPIkey=""

# Initialize parameters specified from command line
while getopts ":d:j:m:" arg; do
    case "${arg}" in
        d)
            dnsURL=${OPTARG}
        ;;
        j)
            bingAPIkey=${OPTARG}
        ;;
        m)
            teamName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$teamName" ]]; then
    echo "Enter a team name for the helm chart values filename:"
    read teamName
fi

if [[ -z "$dnsURL" ]]; then
    echo "Public DNS address where the API will be hosted behind."
    echo "Enter public DNS name."
    read dnsURL
    [[ "${dnsURL:?}" ]]
fi

if [[ -z "$bingAPIkey" ]]; then
    echo "Enter Bing API Key."
    read bingAPIkey
    [[ "${bingAPIkey:?}" ]]
fi

if [ -z "$teamName" ] || [ -z "$dnsURL" ] || [ -z "$bingAPIkey" ]; then
    echo "A parameter is missing."
    usage
fi

declare resourceGroupName="${teamName}rg"
declare registryName="${teamName}acr"

#DEBUG
echo $resourceGroupName
echo $dnsURL
echo $bingAPIkey
echo $teamName
echo -e '\n'

#get the acr repsotiory id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/"tripviewer

echo "TAG: "$TAG

pushd ../tripviewer/

docker build --build-arg DNS_URL="${dnsURL}" . -t $TAG

docker push $TAG
echo "Successfully pushed image: "$TAG

popd

installPath="../tripviewer/helm"
echo -e "\nhelm install ... from: " $installPath

BASE_URI='http://'$dnsURL
echo "Base URI: $BASE_URI"
helm install $installPath --name web --set repository.image=$TAG,ingress.rules.endpoint.host=$dnsURL,viewer.mapkey=$bingAPIkey

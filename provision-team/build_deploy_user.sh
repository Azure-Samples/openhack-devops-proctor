#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#script requires latest version of .netcore to be installed ()


usage() { echo "Usage: build_deploy_poi.sh -b <build flavor> -r <resourceGroupName>  -t <image tag> -s <relative save location> -d <dns host Url> -n <team name>" 1>&2; exit 1; }

declare buildFlavor=""
declare resourceGroupName=""
declare imageTag=""
declare relativeSaveLocation=""
declare dnsUrl=""
declare teamName""

# Initialize parameters specified from command line
while getopts ":b:r:t:s:d:n:" arg; do
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
        s)
            relativeSaveLocation=${OPTARG}
        ;;
        d)
            dnsUrl=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
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

if [[ -z "$relativeSaveLocation" ]]; then
    echo "Path relative to script in which to download and build the app"
    echo "Enter an relative path to save location "
    read relativeSaveLocation
    [[ "${relativeSaveLocation:?}" ]]
fi

if [[ -z "$dnsUrl" ]]; then
    echo "Public DNS address where the API will be hosted behind."
    echo "Enter public DNS name."
    read dnsUrl
    [[ "${dnsUrl:?}" ]]
fi

if [ -z "$buildFlavor" ] || [ -z "$resourceGroupName" ] || [ -z "$imageTag" ] || [ -z "$relativeSaveLocation" ] || [ -z "$dnsUrl" ]; then
    echo "Either one of buildFlavor, resourceGroupName, imageTag, relativeSaveLocation, or dnsUrl is empty"
    usage
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name for the helm chart values filename:"
    read teamName
fi

#DEBUG
echo $buildFlavor
echo $resourceGroupName
echo $imageTag
echo $relativeSaveLocation
echo $dnsUrl
echo -e '\n'

ACR=`az acr list -g $resourceGroupName --query "[].{acrName:name}" --output json | jq .[].acrName | sed 's/\"//g'`

#login to ACR
az acr login --name $ACR

#get the acr repsotiory id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

TAG=$ACR_ID"/devopsoh/"$imageTag

echo "TAG: "$TAG

pushd $relativeSaveLocation/openhack-devops/src/MobileAppServiceV2/UserProfileService

docker build . -t $TAG

docker push $TAG
echo "Successfully pushed image: "$TAG

popd

installPath=$relativeSaveLocation"/openhack-devops/src/MobileAppServiceV2/UserProfileService/helm"
echo -e "\nhelm install ... from: " $installPath

sed -i -e "s/dnsurlreplace/$dnsUrl/g" $installPath"/values.yaml"

cat $installPath"/values.yaml" \
    | sed "s/dnsurlreplace/$dnsUrl/g" \
    | tee "values-user-$teamName.yaml"

helmTeamValues="values-user-$teamName.yaml"

helm install $installPath --name api-user -f $helmTeamValues --set repository.image=$TAG

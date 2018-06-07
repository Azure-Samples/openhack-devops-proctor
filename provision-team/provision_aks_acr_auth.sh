#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: provision_aks_acr_auth.sh -i <subscriptionId> -g <resourceGroupName> -c <clusterName> -r <registryName> -l <resourceGroupLocation> -n <teamName>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare clusterName=""
declare registryName=""
declare resourceGroupLocation=""
declare teamName=""

# Initialize parameters specified from command line
while getopts ":i:g:c:r:l:n:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
        ;;
        g)
            resourceGroupName=${OPTARG}
        ;;
        c)
            clusterName=${OPTARG}
        ;;
        r)
            registryName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
    echo "Your subscription ID can be looked up with the CLI using: az account show --out json "
    echo "Enter your subscription ID:"
    read subscriptionId
    [[ "${subscriptionId:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$clusterName" ]]; then
    echo "Enter a name for the Azure AKS Cluster you want to create:"
    read clusterName
fi

if [[ -z "$registryName" ]]; then
    echo "Enter a name for the Azure Container Registry you want to create:"
    read registryName
fi

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "

    echo "Enter resource group location:"
    read resourceGroupLocation
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name to be used in app provisioning:"
    read teamName
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$clusterName" ] || [ -z "$registryName" ] || [ -z "$teamName" ]; then
    echo "Either one of subscriptionId, resourceGroupName, clusterName, registryName or teamName is empty"
    usage
fi

echo "Retrieving client id..."

CLIENT_ID="$(az aks show -g $resourceGroupName -n $clusterName --query "servicePrincipalProfile.clientId" --output tsv)"

echo "Client Id:"$CLIENT_ID

echo "Retrieving Registry ID..."

ACR_ID="$(az acr show -n $registryName -g $resourceGroupName --query "id" --output tsv)"

echo "Registry Id:"$ACR_ID

kvstore set ${teamName} ACR_URI $ACR_ID

echo "Granting AKS " $clusterName " access to ACR " $registryName "..."
(
    set -x
    az role assignment create --assignee $CLIENT_ID --role Reader --scope $ACR_ID
)

if [ $? == 0 ];
then
    echo "Access Granted..."
fi
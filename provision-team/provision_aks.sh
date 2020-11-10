#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: provision_aks.sh -a <appId> -n <appName> -p <appPassword> -i <subscriptionId> -g <resourceGroupName> -c <clusterName> -l <resourceGroupLocation>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare clusterName=""
declare resourceGroupLocation=""
declare appId=""
declare appName=""
declare appPassword=""

# Initialize parameters specified from command line
while getopts ":a:i:g:c:l:n:p:" arg; do
    case "${arg}" in
        a)
            appId=${OPTARG}
        ;;
        i)
            subscriptionId=${OPTARG}
        ;;
        g)
            resourceGroupName=${OPTARG}
        ;;
        c)
            clusterName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        n)
            appName=${OPTARG}
        ;;
        p)
            appPassword=${OPTARG}
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

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "

    echo "Enter resource group location:"
    read resourceGroupLocation
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$clusterName" ]; then
    echo "Either one of subscriptionId, resourceGroupName, clusterName is empty"
    usage
fi

if [ -f "~/.azure/aksServicePrincipal.json" ]; then
    NOW=$(date +"%Y%m%d-%H%M")
    mv ~/.azure/aksServicePrincipal.json ~/.azure/aksServicePrincipal_$NOW.json
    echo "renamed existing local AKS Service Principal to ~/.azure/aksServicePrincipal_"$NOW".json"
fi

teamName=${resourceGroupName:0:-2}

# Create SPN if not provided
if [ -z "${appName}" ] || [ -z "${appId}" ] || [ -z "${appPassword}" ]; then
    echo "One service principal value is missing\n Creating ServicePrincipal for AKS Cluster.."
    export SP_JSON=`az ad sp create-for-rbac --role="Contributor"`
    export SP_NAME=`echo $SP_JSON | jq -r '.name'`
    export SP_PASS=`echo $SP_JSON | jq -r '.password'`
    export SP_ID=`echo $SP_JSON | jq -r '.appId'`
else
    echo "Using provided Service Principal for AKS Cluster"
    export SP_NAME=`echo $appName`
    export SP_PASS=`echo $appPassword`
    export SP_ID=`echo $appId`
fi

echo "Service Principal Name: " $SP_NAME
echo "Service Principal Password: " $SP_PASS
echo "Service Principal Id: " $SP_ID
kvstore set ${teamName} SPName ${SP_NAME}
kvstore set ${teamName} SPPass ${SP_PASS}
kvstore set ${teamName} SPID ${SP_ID}

echo "Retrieving Registry ID..."

ACR_ID="$(az acr show -n ${teamName}acr -g $resourceGroupName --query "id" --output tsv)"

echo "Registry Id:"$ACR_ID

kvstore set ${teamName} ACR_URI $ACR_ID

echo "Granting Service Princpal " $SP_NAME " access to ACR " $teamName"acr" "..."
(
    set -x
    az role assignment create --assignee $SP_ID --role acrpull --scope $ACR_ID
)

if [ $? == 0 ];
then
    echo "Access Granted..."
fi

echo "Creating AKS Cluster..."
(
    set -x
    az aks create -g $resourceGroupName -n $clusterName -l $resourceGroupLocation --node-count 3 --generate-ssh-keys -k 1.17.11 --service-principal $SP_ID --client-secret $SP_PASS
)

if [ $? == 0 ];
then
    echo "Cluster AKS:" $clusterName "created successfully..."
fi

if [ $? == 0 ];
then
    echo "kubernetes CLI for AKS:" $clusterName "installed successfully..."
fi

echo "Getting Credentials for AKS cluster..."
(
    set -x
    az aks get-credentials --resource-group=$resourceGroupName --name=$clusterName
)

if [ $? == 0 ];
then
    echo "Credentials for AKS: "$clusterName" retrieved successfully..."
fi

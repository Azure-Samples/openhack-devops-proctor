#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage:  ./deploy_jenkins.sh -g <resourceGroupName> -l <resourceGroupLocation> -p <jenkinsVMPassword> -u <jenkinsURL>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceGroupLocation=""
declare jenkinsVMPassword=""
declare jenkinsURL=""

# Initialize parameters specified from command line
while getopts ":g:l:p:u:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        p)
            jenkinsVMPassword=${OPTARG}
        ;;
        u)
            jenkinsURL=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing
if [[ -z "$resourceGroupName" ]]; then
    echo "This script will look for an existing resource group, otherwise a new one will be created "
    echo "You can create new resource groups with the CLI using: az group create "
    echo "Enter a resource group name"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$resourceGroupLocation" ]]; then
    echo "If creating a *new* resource group, you need to set a location "
    echo "You can lookup locations with the CLI using: az account list-locations "
    echo "Enter resource group location:"
    read resourceGroupLocation
    [[ "${resourceGroupLocation:?}" ]]
fi

if [[ -z "$jenkinsVMPassword" ]]; then
    echo "Enter a password for the Jenkins VM:"
    read jenkinsVMPassword
fi

if [[ -z "$jenkinsURL" ]]; then
    echo "Enter a DNS label for the Jenkins VM:"
    read jenkinsURL
fi

#Check for existing RG
if [ `az group exists -n $resourceGroupName -o tsv` == false ]; then
    echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        az group create --name $resourceGroupName --location $resourceGroupLocation
    )
else
    echo "Using existing resource group..."
fi

az group deployment create \
    --name "${resourceGroupName}deployment" \
    --resource-group $resourceGroupName \
    --template-file ../jenkins/azuredeploy.json \
    --parameters adminPassword=$jenkinsVMPassword jenkinsDnsPrefix=$jenkinsURL

#!/bin/bash 
set -euo pipefail
IFS=$'\n\t'

# Script to deploy the sentinel containers on the proctor cluster
# If no team is specified it will read the entries in the kvstore and deploy sentinel for the successfull ones
# If a team is specified it will deploy sentinel only for this one

usage() { echo "Usage: deploy_sentinel.sh -r <resourceGroupName> -n <teamName> -a <apiUrl> -d <dnsUrl> -g <registry name>" 1>&2; exit 1; }

declare resourceGroupName=""
declare apiUrl=""
declare teamName=""
declare dnsUrl=""
declare registryName=""

# Initialize parameters specified from command line
while getopts ":r:n:a:d:g:" arg; do
    case "${arg}" in
        r)
            resourceGroupName=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        a)
            apiUrl=${OPTARG}
        ;;        
        d)
            dnsUrl=${OPTARG}
        ;;        
        g)
            registryName=${OPTARG}
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

if [[ -z "$teamName" ]]; then
    echo "Enter the name of the team environment selected"
    read teamName
    [[ "${teamName:?}" ]]
fi

if [[ -z "$apiUrl" ]]; then
    echo "Enter the Url of the sentinel api"
    read apiUrl
    [[ "${apiUrl:?}" ]]
fi

if [[ -z "$dnsUrl" ]]; then
    echo "Enter the Url of the DNS"
    read dnsUrl
    [[ "${dnsUrl:?}" ]]
fi

chartPath="../leaderboard/sentinel/helm"
echo -e "\nhelm install ... from: " $chartPath

#get the acr repsotiory id to tag image with.
ACR_ID=`az acr list -g $resourceGroupName --query "[].{acrLoginServer:loginServer}" --output json | jq .[].acrLoginServer | sed 's/\"//g'`

echo "ACR ID: "$ACR_ID

#Get the acr admin password and login to the registry
acrPassword=$(az acr credential show -n $registryName -o json | jq -r '[.passwords[0].value] | .[]')

docker login $ACR_ID -u $registryName -p $acrPassword
echo "Authenticated to ACR with username and password"

TAG=$ACR_ID"/devopsoh/sentinel"

echo "TAG: "$TAG

echo "Deploying monitoring for $teamName at http://$dnsUrl"
(helm install $chartPath --name $teamName --set image.repository=$TAG,teams.endpointUrl="http://$dnsUrl",teams.apiUrl=$apiUrl,teams.name=$teamName) || true

# Collecting the status of the deployment
helm ls 

echo "############ END OF SENTINEL DEPLOYMENT ############"



#!/bin/bash 
set -euo pipefail
IFS=$'\n\t'

# Script to deploy the sentinel containers on the proctor cluster
# If no team is specified it will read the entries in the kvstore and deploy sentinel for the successfull ones
# If a team is specified it will deploy sentinel only for this one

usage() { echo "Usage: deploy_sentinel.sh -n <teamName> -a <apiUrl> -d <dnsUrl> " 1>&2; exit 1; }

declare apiUrl=""
declare teamName=""
declare dnsUrl=""

# Initialize parameters specified from command line
while getopts ":n:a:d:" arg; do
    case "${arg}" in
        n)
            teamName=${OPTARG}
        ;;
        a)
            apiUrl=${OPTARG}
        ;;        
        d)
            dnsUrl=${OPTARG}
        ;;        
    esac
done
shift $((OPTIND-1))

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

TAG=$registryName"/devopsoh/sentinel"

echo "Deploying monitoring for $teamName at http://$dnsUrl"
(helm install $chartPath --name $teamName --set image.repository=$TAG,teams.endpointUrl="http://$dnsUrl",teams.apiUrl=$apiUrl,teams.name=$teamName) || true

# Collecting the status of the deployment
helm ls 

echo "############ END OF SENTINEL DEPLOYMENT ############"



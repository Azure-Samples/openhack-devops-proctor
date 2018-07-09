#!/bin/bash 
set -euo pipefail
IFS=$'\n\t'

# Script to deploy the sentinel containers on the proctor cluster
# If no team is specified it will read the entries in the kvstore and deploy sentinel for the successfull ones
# If a team is specified it will deploy sentinel only for this one

usage() { echo "Usage: deploy_sentinel.sh -p <proctorEnvironmentName> -n <teamName - Optional>" 1>&2; exit 1; }

declare -a keys
declare registryName=""
declare apiUrl=""
declare teamList=""
declare teamName=""
declare teamEndPoint=""

# Initialize parameters specified from command line
while getopts ":p:n:" arg; do
    case "${arg}" in
        p)  
            proctorEnvName=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$proctorEnvName" ]]; then
    echo "Enter the name of the proctor environment selected"
    read proctorEnvName
    [[ "${proctorEnvName:?}" ]]
fi

chartPath="../leaderboard/sentinel/helm"
echo -e "\nhelm install ... from: " $chartPath

# Getting the registry name and the apiUrl from kvstore
registryName="$(kvstore get $proctorEnvName ACR).azurecr.io"
apiUrl="http://$(kvstore get $proctorEnvName functionAppName).azurewebsites.net/api/ReportStatus"

if [[ -z "$teamName" ]]; then
  teamList=$(kvstore ls)
else
  teamList=$teamName
fi

for team in $teamList; do
  keys=$(kvstore keys $team)

  if [[ " ${keys[@]} " =~ "endpoint" ]]; then
     teamEndPoint=$(kvstore get $team endpoint)
     echo "Deploying monitoring for $team at http://$teamEndPoint"
     helm install $chartPath --name $team --set image.repository=$registryName,teams.endpointUrl="http://$teamEndPoint",teams.apiUrl=$apiUrl,teams.name=$team
  fi

done





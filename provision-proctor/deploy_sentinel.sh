#!/bin/bash 

# Script to deploy the sentinel containers on the proctor cluster
# Read the kvstore entries and deploy sentinel for the successfull ones
# The script will only deploy the entries that have not been already deployed

# KVSTORE_DIR is the environment var where the store is located

declare -a keys
declare registryName=""
declare apiUrl=""

# Initialize parameters specified from command line
while getopts ":r:n:a:" arg; do
    case "${arg}" in
        r)  
            registryName=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
            # Currently inactive - to be updated to support the deployment for one team
        ;;
        a)
            apiUrl=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$registryName" ]]; then
    echo "This script requires the acr registry name"
    echo "Enter a registry name"
    read registryName
    [[ "${registryName:?}" ]]
fi

if [[ -z "$apiUrl" ]]; then
    echo "Enter the Azure functions api URL i.e. https://teamnamefun.azurewebsites.net/api/ReportStatus :"
    read apiUrl
    [[ "${apiUrl:?}" ]]
fi

chartPath="../leaderboard/sentinel/helm"
echo -e "\nhelm install ... from: " $installPath

for team in $(kvstore ls); do
  keys=$(kvstore keys $team)

  if [[ " ${keys[@]} " =~ "endpoint" ]]; then
     teamEndpoint=$(kvstore get $team endpoint)
     echo "Deploying monitoring for $team at http://$teamEndPoint"
     helm install $chartPath --name $team --set image.repository=$registryName,\
                                                     teams.endpointUrl="http://$teamEndpoint",\
                                                     teams.apiUrl=$apiUrl,\
                                                     teams.name=$team
  fi

done





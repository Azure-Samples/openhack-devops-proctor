#!/bin/bash 
set -euo pipefail
IFS=$'\n\t'

# Script to deploy the sentinel containers on the proctor cluster
# If no team is specified it will read the entries in the kvstore and deploy sentinel for the successfull ones
# If a team is specified it will deploy sentinel only for this one

usage() { echo "Usage: deploy_sentinel.sh -p <proctorEnvironmentName> -n <teamName - Optional> -f credentials.csv -y <localEnv - Optional>" 1>&2; exit 1; }

declare -a keys
declare registryName=""
declare apiUrl=""
declare teamList=""
declare teamName=""
declare teamEndPoint=""
declare csvFile=""
declare localEnv="no"

# Initialize parameters specified from command line
while getopts ":f:p:n:y:" arg; do
    case "${arg}" in
        f)
            csvFile=${OPTARG}
        ;;
        p)  
            proctorEnvName=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        y)
            localEnv=${OPTARG}
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

if [[ $localEnv == "no" ]]; then

    if [[ -z "$csvFile" ]]; then
        echo "Speficy the location of file containing the teams' Azure credentials"
        read csvFile
        [[ "${csvFile:?}" ]]
    fi

    if [ ! -f $csvFile ]; then
        echo "File $csvFile not found"
        exit 1
    fi

    # Obtain the kvstore files from the teams 
    UNIQUECRED=$(awk -F, '!seen[$3]++' $csvFile)

    for cred in $UNIQUECRED
    do 
        # echo "Line: $cred"
        subid=$(echo $cred | awk -F ", " '{ print $3 }')
        username=$(echo $cred | awk -F ", " '{ print $5 }')
        password=$(echo $cred | awk -F ", " '{ print $6 }')
        #echo "Subscription: $subid"
        #echo "username: $username"
        #echo "Password: $password"
        GUID=$(echo $subid | sed -E -e 's/.{8}-.{4}-.{4}-.{4}-.{12}/guid/')
        if [[ $GUID == "guid" ]]; then
            az login --username=$username --password=$password > /dev/null
            ipaddress=$(az vm list-ip-addresses --resource-group=ProctorVMRG --name=proctorVM --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -otsv)
            if [[ $ipaddress =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                teamAAD=$(echo "$username"  | sed -e 's/.*?*@\(.*\)ops.onmicrosoft.com/\1/')
                curl -o /home/azureuser/team_env/kvstore/$teamAAD http://${ipaddress}:2018/ohteamvalues 
                echo "$teamAAD is at $ipaddress"
            fi
        fi
    done
fi

# Getting the registry name and the apiUrl from kvstore
registryName="$(kvstore get $proctorEnvName ACR).azurecr.io"
apiUrl="$(kvstore get $proctorEnvName apiUrl)"

if [[ -z "$teamName" ]]; then
  teamList=$(kvstore ls)
else
  teamList=$teamName
fi
TAG=$registryName"/devopsoh/sentinel"

for team in $teamList; do
    if [[ "$team" != *"monitoring"* ]]; then
        keys=$(kvstore keys $team)

        if [[ " ${keys[@]} " =~ "endpoint" ]]; then
            teamEndPoint=$(kvstore get $team endpoint)
            echo "Deploying monitoring for $team at http://$teamEndPoint"
            helm install $chartPath --name $team --set image.repository=$TAG,teams.endpointUrl="http://$teamEndPoint",teams.apiUrl=$apiUrl,teams.name=$team
        fi
    fi
done





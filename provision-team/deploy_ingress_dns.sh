#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy_app_aks.sh -s <relative save location> -n <teamName> -l <resource group location>" 1>&2; exit 1; }

declare relativeSaveLocation=""
declare resourceGroupLocation=""
declare teamName=""

# Initialize parameters specified from command line
while getopts ":s:l:n:" arg; do
    case "${arg}" in
        s)
            relativeSaveLocation=${OPTARG}
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

if [[ -z "$relativeSaveLocation" ]]; then
    echo "Enter a source code path:"
    read relativeSaveLocation
    [[ "${relativeSaveLocation:?}" ]]
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

echo "Upgrading tiller (helm server) to match client version."

helm init --upgrade

tiller=$(kubectl get pods --all-namespaces | grep tiller | awk '{print $4}')

echo "Waiting for tiller ..."

while [ $tiller != "Running" ]; do
        echo "Waiting for tiller ..."
        tiller=$(kubectl get pods --all-namespaces | grep tiller | awk '{print $4}')
        sleep 5
done

echo "tiller upgrade complete."

echo "Updating repo information"
helm repo update

echo -e "\nUpdate the Traefik Ingress DNS name configuration ..."
cat "./traefik-values.yaml" \
    | sed "s/akstraefikreplaceme/akstraefik$teamName/g" \
    | sed "s/locationreplace/$resourceGroupLocation/g" \
    | tee $relativeSaveLocation"/traefik$teamName.yaml"

echo -e "\n\nInstalling Traefik Ingress controller ..."
echo -e "Waiting for tiller to be ready" 
time=0 
while true; do
        TILLER_STATUS=$(kubectl get pods --all-namespaces --selector=app=helm -o json | jq -r '.items[].status.phase')
        if [[ "${TILLER_STATUS}" == "Running" ]]; then break; fi
        sleep 10
        time=$(($time+10))
        echo $time "seconds waiting"
done

helm install stable/traefik --name team-ingress --version 1.27.0 -f $relativeSaveLocation"/traefik$teamName.yaml"

echo "Waiting for public IP:"
time=0
while true; do
        INGRESS_IP=$(kubectl get svc team-ingress-traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        if [[ "${INGRESS_IP}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then break; fi
        sleep 10
        time=$(($time+10))
        echo $time "seconds waiting"
done

INGRESS_IP=$(kubectl get svc team-ingress-traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

DNS_HOSTNAME=akstraefik$teamName.$resourceGroupLocation.cloudapp.azure.com
echo -e "\n\nExternal DNS hostname is https://"$DNS_HOSTNAME "which maps to IP " $INGRESS_IP

# TODO: Export the DNS Hostname to a file on proctor VM
echo "Writing the public IP of the team endpoint"

# Verify that the teamConfig file exist
if [ ! -d "$HOME/team_env" ]; then
   mkdir $HOME/team_env
fi

if [ ! -f "$HOME/team_env/teamConfig.json" ]; then
   touch $HOME/team_env/teamConfig.json
else
    existingEnv="$(<$HOME/team_env/teamConfig.json)"
    teamEndPoint="{
        \"$teamName\": {
         \"endpoint\": \"$DNS_HOSTNAME\"
    }
}"
echo $teamEndPoint $existingEnv | jq -s add > $HOME/team_env/teamConfig.json
fi


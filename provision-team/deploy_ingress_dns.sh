#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy_ingress_dns.sh -s <relative save location> -l <resource group location> -n <teamName>" 1>&2; exit 1; }

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

helm init --upgrade --wait

kubectl create serviceaccount --namespace kube-system tiller

kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller

tiller=$(kubectl get pods --all-namespaces | grep tiller | awk '{print $4}')

while [ $tiller != "Running" ]; do
        echo "Waiting for tiller ..."
        tiller=$(kubectl get pods --all-namespaces | grep tiller | awk '{print $4}')
        sleep 5
done

echo "tiller upgrade complete."

echo "Updating information of available charts locally from chart repositories"
helm repo update

echo -e "\nUpdate the Traefik Ingress DNS name configuration ..."
cat "${0%/*}/traefik-values.yaml" \
    | sed "s/akstraefikreplaceme/akstraefik$teamName/g" \
    | sed "s/locationreplace/$resourceGroupLocation/g" \
    | tee $relativeSaveLocation"/traefik$teamName.yaml"

time=0
while true; do
        TILLER_STATUS=$(kubectl get pods --all-namespaces --selector=app=helm -o json | jq -r '.items[].status.phase')
        echo -e "\n\nVerifying tiller is ready"
        if [[ "${TILLER_STATUS}" == "Running" ]]; then break; fi
        sleep 10
        time=$(($time+10))
        echo $time "seconds waiting"
done

# Adding sleep 45 as per https://github.com/kubernetes/charts/commit/977d130375c88dd1b0a23977522db8d748fd49d3#diff-3e80d6cfbb2cf233c8f914f6fde79ec5
echo -e "\nSleeping for 45 seconds to ensure Traefik is ready\n"
sleep 45


echo -e "\n\nInstalling Traefik Ingress controller ..."

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

kvstore set ${teamName} ingressIp ${INGRESS_IP}

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
declare timeout=120  #Number of loops before timeout on check on tiller
declare wait=5       #Number of seconds between to checks on tiller

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

echo -e "adding RBAC ServiceAccount and ClusterRoleBinding for tiller\n\n"

kubectl create serviceaccount --namespace kube-system tillersa
if [ $? -ne 0 ]; then
    echo "[ERROR] Creation of tillersa failed"
    exit 1
fi

kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tillersa
if [ $? -ne 0 ]; then
    echo "[ERROR] Creation of the tiller-cluster-rule failed"
    exit 1
fi

kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
if [ $? -ne 0 ]; then
    echo "[ERROR] Creation of dashboard-admin failed"
    exit 1
fi

echo "Upgrading tiller (helm server) to match client version."

helm init --upgrade --service-account tillersa
if [ $? -ne 0 ]; then
    echo "[ERROR] The helm init command failed"
    exit 1
fi

count=0
until kubectl get pods --all-namespaces | grep -E "kube-system(\s){3}tiller.*1\/1\s*Running+"
do
        sleep ${wait}
        if [ ${count} -gt ${timeout} ]; then
            printf "Timeout - Waited %s seconds on tiller to be Running\n" "$(($count*$wait))"
            exit 1
        fi
        printf "Waiting for tiller ... %s seconds\n" "$(($count*$wait))"
        (( ++count ))
done

echo "tiller upgrade complete."

# echo "Updating information of available charts locally from chart repositories"
# helm repo update

# echo -e "\nUpdate the Traefik Ingress DNS name configuration ..."
DASHBOARD_URL="akstraefik$teamName.$resourceGroupLocation.cloudapp.azure.com"
DNS_LABEL="akstraefik$teamName"

# cat "${0%/*}/traefik-values.yaml" \
#     | sed "s/akstraefikreplaceme/akstraefik$teamName/g" \
#     | sed "s/locationreplace/$resourceGroupLocation/g" \
#     | tee $relativeSaveLocation"/traefik$teamName.yaml"

time=0
while true; do
        TILLER_STATUS=$(kubectl get pods --all-namespaces --selector=app=helm -o json | jq -r '.items[].status.phase')
        echo -e "\n\nVerifying tiller is ready"
        if [[ "${TILLER_STATUS}" == "Running" ]]; then break; fi
        sleep 10
        time=$(($time+10))
        echo $time "seconds waiting"
done

echo -e "\n\nWaiting 15 seconds then installing Traefik Ingress controller ..."

sleep 15
APISERVER=$(kubectl config view --minify=true | grep server | cut -f 2- -d ":" | tr -d " ")
echo "Apiserver is: " $APISERVER

# Prodution POD
helm install --name team-ingress ./traefik -f traefik-values.yaml --set kubernetes.endpoint="${APISERVER}",dashboard.domain="${DASHBOARD_URL}",service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="${DNS_LABEL}" --debug
#Staging POD
helm install --name team-ingress-stage ./traefik -f traefik-values.yaml --set kubernetes.endpoint="${APISERVER}",dashboard.domain="stage${DASHBOARD_URL}",service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="stage${DNS_LABEL}" --debug

#Wait for Prod IP
echo "Waiting for PROD public IP:"
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
echo -e "\n\nExternal PROD DNS hostname is https://"$DNS_HOSTNAME "which maps to IP " $INGRESS_IP

kvstore set ${teamName} ingressIp ${INGRESS_IP}

#Wait for Staging IP
echo "Waiting for Staging public IP:"
time=0
while true; do
        STAGE_INGRESS_IP=$(kubectl get svc team-ingress-stage-traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        if [[ "${STAGE_INGRESS_IP}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then break; fi
        sleep 10
        time=$(($time+10))
        echo $time "seconds waiting"
done

STAGE_INGRESS_IP=$(kubectl get svc team-ingress-stage-traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

STAGE_DNS_HOSTNAME=stageakstraefik$teamName.$resourceGroupLocation.cloudapp.azure.com
echo -e "\n\nExternal STAGING DNS hostname is https://"$STAGE_DNS_HOSTNAME "which maps to IP " $STAGE_INGRESS_IP

kvstore set ${teamName} stageIngressIp ${STAGE_INGRESS_IP}
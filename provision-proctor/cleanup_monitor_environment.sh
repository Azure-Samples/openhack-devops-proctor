#!/bin/bash

usage() { echo "Usage: cleanup_environment.sh -c <clusterName> -r <resourceGroupName> -t <monitoringName>" 1>&2; exit 1; }

while getopts ":c:r:t:" arg; do
    case "${arg}" in
        c)
            clusterName=${OPTARG}
        ;;
        r)
            resourceGroupName=${OPTARG}
        ;;
        t)
            monitoringName=${OPTARG}
        ;;
    esac
done

if [[ -z "$monitoringName" ]]; then
    echo "Enter the monitoringName to use for filepath"
    read monitoringName
fi

if [[ -z "$resourceGroupName" ]]; then
    echo "Enter the resourceGroupName to use for filepath"
    read resourceGroupName
fi

if [[ -z "$clusterName" ]]; then
    echo "Enter the clusterName to use for filepath"
    read clusterName
fi

# Copy the kubeconfig file
kubeconfiglocation="/home/azureuser/team_env/$monitoringName/kubeconfig-$monitoringName"
echo "Getting Credentials for AKS cluster..."
(
    set -x
    az aks get-credentials --resource-group=$resourceGroupName --name=$clusterName --file $kubeconfiglocation
)
echo "Downloaded the kubeconfig file to $kubeconfiglocation"

# Adding the location of kubeconfig in kvstore
kvstore set $monitoringName kubeconfig $kubeconfiglocation

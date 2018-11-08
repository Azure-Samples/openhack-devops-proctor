#!/bin/bash

usage() { echo "Usage: cleanup_environment.sh -t <monitoringName>" 1>&2; exit 1; }

while getopts ":t:" arg; do
    case "${arg}" in
        t)
            monitoringName=${OPTARG}
        ;;
    esac
done

if [[ -z "$monitoringName" ]]; then
    echo "Enter the monitoringName to use for filepath"
    read monitoringName
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

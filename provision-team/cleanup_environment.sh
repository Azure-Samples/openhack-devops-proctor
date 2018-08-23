#!/bin/bash

usage() { echo "Usage: cleanup_environment.sh -t <teamName>" 1>&2; exit 1; }

while getopts ":t:" arg; do
    case "${arg}" in
        t)
            teamName=${OPTARG}
        ;;
    esac
done

if [[ -z "$teamName" ]]; then
    echo "Enter the teamName to use to rename the aksServicePrincipal file to"
    read teamName
fi

if [ -z "$teamName" ] ; then
    echo "The team name is empty"
    usage
fi

# 1- Rename /home/azureuser/.azure/aksServicePrincipal.json to /home/azureuser/.azure/aksServicePrincipal-team-number.json
if [ -f /home/azureuser/.azure/aksServicePrincipal.json ]; then
    aksSPlocation="/home/azureuser/team_env/$teamName/aksServicePrincipal-$teamName.json"
    cp /home/azureuser/.azure/aksServicePrincipal.json $aksSPlocation
    kvstore set $teamName aksSPlocation $aksSPlocation
    echo "The aksServicePrincipal.json file has been moved to $aksSPlocation"
fi

# 2- Copy the kubeconfig file
if [ -f /home/azureuser/.kube/config ]; then
    kubeconfiglocation="/home/azureuser/team_env/$teamName/kubeconfig-$teamName"
    cp /home/azureuser/.kube/config $kubeconfiglocation
    kvstore set $teamName kubeconfig $kubeconfiglocation
    echo "Copied the kubeconfig file to $kubeconfiglocation"
fi

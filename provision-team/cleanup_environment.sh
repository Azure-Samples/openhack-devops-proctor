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

# 1- Rename $HOME/.azure/aksServicePrincipal.json to $HOME/.azure/aksServicePrincipal-team-number.json
if [ -f $HOME/.azure/aksServicePrincipal.json ]; then
    aksSPlocation="$HOME/team_env/$teamName/aksServicePrincipal-$teamName.json"
    mv $HOME/.azure/aksServicePrincipal.json $aksSPlocation
    kvstore set $teamName aksSPlocation $aksSPlocation
    echo "The aksServicePrincipal.json file has been moved to $aksSPlocation"
fi

# 2- Copy the kubeconfig file
if [ -f $HOME/.kube/config ]; then
    kubeconfiglocation="$HOME/team_env/$teamName/kubeconfig-$teamName"
    mv $HOME/.kube/config $kubeconfiglocation
    kvstore set $teamName kubeconfig $kubeconfiglocation
    echo "Copied the kubeconfig file to $kubeconfiglocation"
fi

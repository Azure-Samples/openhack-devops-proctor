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
    mv $HOME/.azure/aksServicePrincipal.json $HOME/team_env/$teamName/aksServicePrincipal-$teamName.json
    echo "The aksServicePrincipal.json file has been move to team-env/$teamName/aksServicePrincipal-$teamName.json"
fi

# 2- Copy the kubeconfig file
if [ -f $HOME/.kube/config ]; then
    mv $HOME/.kube/config $HOME/team_env/$teamName/kubeconfig-$teamName
    echo "Copied the kubeconfig file to $HOME/team_env/$teamName/kubeconfig-$teamName"
fi

# 3- Delete the working directory
rm -rf ./test_fetch_build
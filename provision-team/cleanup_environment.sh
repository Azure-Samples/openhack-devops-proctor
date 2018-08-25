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

# create a www directory
if [[ ! -d "/home/azureuser/www" ]]; then
    mkdir -p /home/azureuser/www
fi 

sudo zip /home/azureuser/www/teamfiles.zip /root/.kube/config /root/.azure/aksServicePrincipal.json /home/azureuser/team_env/kvstore/${teamName}
sudo cp /home/azureuser/team_env/kvstore/${teamName} /home/azureuser/www/ohteamvalues
sudo cp /home/azureuser/openhack-devops-proctor/provision-team/nginx/index.html /home/azureuser/www/index.html

# 1- Rename /home/azureuser/.azure/aksServicePrincipal.json to /home/azureuser/.azure/aksServicePrincipal-team-number.json
if [ -f /home/root/.azure/aksServicePrincipal.json ]; then
    aksSPlocation="/home/azureuser/team_env/$teamName/aksServicePrincipal-$teamName.json"
    cp /home/azureuser/.azure/aksServicePrincipal.json $aksSPlocation
    kvstore set $teamName aksSPlocation $aksSPlocation
    echo "The aksServicePrincipal.json file has been moved to $aksSPlocation"
fi

# 2- Copy the kubeconfig file
if [ -f /home/root/.kube/config ]; then
    kubeconfiglocation="/home/azureuser/team_env/$teamName/kubeconfig-$teamName"
    cp /home/azureuser/.kube/config $kubeconfiglocation
    kvstore set $teamName kubeconfig $kubeconfiglocation
    echo "Copied the kubeconfig file to $kubeconfiglocation"
fi


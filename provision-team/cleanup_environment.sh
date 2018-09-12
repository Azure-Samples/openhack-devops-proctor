#!/bin/bash

usage() { echo "Usage: cleanup_environment.sh -t <teamName> -p <password>" 1>&2; exit 1; }

while getopts ":t:p:" arg; do
    case "${arg}" in
        t)
            teamName=${OPTARG}
        ;;
        p)
            password=${OPTARG}
        ;;
    esac
done

if [[ -z "$teamName" ]]; then
    echo "Enter the teamName to use for filepath"
    read teamName
fi
if [[ -z "$password" ]]; then
    echo "Enter the password to encrypt the zip file"
    read password
fi
# create a www directory
if [[ ! -d "/home/azureuser/www" ]]; then
    mkdir -p /home/azureuser/www
fi 

# Copy the kubeconfig file
kubeconfiglocation="/home/azureuser/team_env/$teamName/kubeconfig-$teamName"
sudo cp /root/.kube/config /home/azureuser/www/kubeconfig
sudo cp /root/.kube/config $kubeconfiglocation
kvstore set $teamName kubeconfig $kubeconfiglocation
echo "Copied the kubeconfig file to $kubeconfiglocation"

kvstore set $teamName zippassword $password

# Setup files to serve via nginx
sudo cp /home/azureuser/team_env/kvstore/${teamName} /home/azureuser/www/ohteamvalues
sudo zip -e --password ${password} /home/azureuser/www/teamfiles.zip /home/azureuser/www/kubeconfig /home/azureuser/www/ohteamvalues /home/azureuser/team_env/kvstore/${teamName}
echo "Zipped /home/azureuser/www/teamfiles.zip with password $password"
sudo cp /home/azureuser/openhack-devops-proctor/provision-team/nginx/index.html /home/azureuser/www/index.html

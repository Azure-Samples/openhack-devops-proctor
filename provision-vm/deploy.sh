#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: deploy.sh -l <location> -n <number> -k <publickey>" 1>&2; exit 1; }

declare publickey=""
declare location=""
declare number=""

# Initialize parameters specified from command line
while getopts ":k:l:n:" arg; do
    case "${arg}" in
        k)
            publickey=${OPTARG}
        ;;
        l)
            location=${OPTARG}
        ;;
        n)
            number=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$publickey" ]]; then
    echo "Please specify a public key value"
    read publickey
fi

if [[ -z "$location" ]]; then
    echo "Enter a location"
    read location
    [[ "${location:?}" ]]
fi

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo -n $(( $RANDOM % 10 ))
}

if [[ -z "$number" ]]; then
    echo "Using a random proctor number since not specified."
    number="$(randomChar;randomChar;randomChar;randomNum;)"
fi

AdminUser="azureuser"
proctorDNSName="procohvm${number}"
resourceGroupName="ProctorVM${number}"

#Check for existing RG
if [ `az group exists -n $resourceGroupName -o tsv` == false ]; then
    echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        az group create --name $resourceGroupName --location $location
    )
else
    echo "Using existing resource group..."
fi

echo "Deploying Proctor Virtual Machine..."

az group deployment create \
    --name "${resourceGroupName}deployment" \
    --resource-group $resourceGroupName \
    --template-file azuredeploy.json \
    --parameters adminUsername=$AdminUser dnsNameForPublicIP=$proctorDNSName sshKeyData="$publickey"

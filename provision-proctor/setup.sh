#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: setup.sh -i <subscriptionId> -l <resourceGroupLocation> -n <teamName> " 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupLocation=""
declare teamName=""
declare totalTeams=""
declare apiUrl=""
# declare keyVaultName=""

# Initialize parameters specified from command line
while getopts ":i:l:n:e:a:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        e)
            totalTeams=${OPTARG}
        ;;
        a)
            apiUrl=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))
numberTeams -l $location -a $apiUrl
# Check if kubectl is installed or that we can install it
type -p kubectl
if [ ! $? == 0 ]; then
    if [[ ! $EUID == 0 ]]; then
        echo "kubectl not found, install and re-run setup."
        exit 1
    fi
fi

# Check if az is installed and that we can install it
type -p az
if [ ! $? == 0 ]; then
    # is az is not present we need to install it
    echo "The script need the az command line to be installed\n"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest"
    exit 1
fi

#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
    echo "Your subscription ID can be looked up with the CLI using: az account show --out json "
    echo "Enter your subscription ID:"
    read subscriptionId
    [[ "${subscriptionId:?}" ]]
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

if [[ -z "$totalTeams" ]]; then
    echo "Enter the total number of teams provisioned:"
    read totalTeams
fi

if [[ -z "$apiUrl" ]]; then
    echo "Enter the Azure functions api URL i.e. https://mysite.azurewebsites.net :"
    read apiUrl
    [[ "${apiUrl:?}" ]]
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupLocation" ] || [ -z "$teamName" ] || [[ -z "$apiUrl" ]]; then
    echo "Parameter missing..."
    usage
fi

# declare random4Chars="$(randomChar;randomChar;randomChar;randomNum;)"
declare resourceGroupTeam="${teamName}-rg";
declare registryName="${teamName}acr"
declare clusterName="${teamName}aks"
# declare keyVaultName="${teamName}kv${random4Chars}"

echo "=========================================="
echo " VARIABLES"
echo "=========================================="
echo "subscriptionId            = "${subscriptionId}
echo "resourceGroupLocation     = "${resourceGroupLocation}
echo "teamName                  = "${teamName}
# echo "keyVaultName              = "${keyVaultName}
echo "resourceGroupTeam         = "${resourceGroupTeam}
echo "registryName              = "${registryName}
echo "clusterName               = "${clusterName}
echo "=========================================="

#login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
    az login
fi

#set the default subscription id
echo "Setting subscription to $subscriptionId..."

az account set --subscription $subscriptionId

#TODO need to check if provider is registered and if so don't run this command.  Also probably need to sleep a few minutes for this to finish.
echo "Registering ContainerServiceProvider..."
az provider register -n Microsoft.ContainerService

set +e

#Check for existing RG
if [ `az group exists -n $resourceGroupTeam -o tsv` == false ]; then
    echo "Resource group with name" $resourceGroupTeam "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        az group create --name $resourceGroupTeam --location $resourceGroupLocation
    )
else
    echo "Using existing resource group..."
fi

# echo "0-Provision KeyVault  (bash ./provision_kv.sh -i $subscriptionId -g $resourceGroupTeam -k $keyVaultName -l $resourceGroupLocation)"
# bash ./provision_kv.sh -i $subscriptionId -g $resourceGroupTeam -k $keyVaultName -l $resourceGroupLocation

echo "1-Provision ACR  (bash ./provision_acr.sh -i $subscriptionId -g $resourceGroupTeam -r $registryName -l $resourceGroupLocation)"
bash ../provision-team/provision_acr.sh -i $subscriptionId -g $resourceGroupTeam -r $registryName -l $resourceGroupLocation

echo "2-Provision AKS  (bash ./provision_aks.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -l $resourceGroupLocation)"
bash ../provision-team/provision_aks.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -l $resourceGroupLocation

# Remove do to the permission with the role assignment
echo "3-Set AKS/ACR permissions  (bash ./provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -r $registryName -l $resourceGroupLocation)"
bash ../provision-team/provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -r $registryName -l $resourceGroupLocation

echo "4-Deploy ingress  (bash ./deploy_ingress_dns.sh -s ./test_fetch_build -l $resourceGroupLocation -n ${teamName})"
bash ../provision-team/deploy_ingress_dns.sh -s ./test_fetch_build -l $resourceGroupLocation -n ${teamName}

# Save the public DNS address to be provisioned in the helm charts for each service
dnsURL='akstraefik'${teamName}'.'$resourceGroupLocation'.cloudapp.azure.com'
echo -e "DNS URL for "${teamName}" is:\n"$dnsURL

echo "5-Build and deploy sentinel to AKS  (bash ./build_deploy_sentinel.sh -r $resourceGroupTeam -g $registryName -n ${teamName} -e $numberTeams -l $location -a $apiUrl)"
bash ./build_deploy_sentinel.sh -r $resourceGroupTeam -g $registryName -n ${teamName} -e $numberTeams -l $resourceGroupLocation -a $apiUrl

# echo "6-Build and deploy leaderboard website to AKS  (bash ./build_deploy_web.sh -r $resourceGroupTeam -g $registryName -n ${teamName} )"
# bash ./build_deploy_web.sh -r $resourceGroupTeam -g $registryName -n ${teamName}

echo "7-Clean the working environment"
bash ../provision-team/cleanup_environment.sh -t ${teamName}

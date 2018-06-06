#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: setup.sh -i <subscriptionId> -l <resourceGroupLocation> -m <proctorName> -u <proctorNumber> -n <teamName> -e <totalTeams>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupLocation=""
declare proctorName=""
declare proctorNumber=""
declare teamName=""
declare totalTeams=""

# Initialize parameters specified from command line
while getopts ":i:l:m:u:n:e:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        m)
            proctorName=${OPTARG}
        ;;
        u)
            proctorNumber=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        e)
            totalTeams=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

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

if [[ -z "$proctorName" ]]; then
    echo "Enter a team name to be used in app provisioning:"
    read proctorName
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name to be used in app provisioning:"
    read teamName
fi

if [[ -z "$totalTeams" ]]; then
    echo "Enter the total number of teams provisioned:"
    read totalTeams
fi

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupLocation" ] || [ -z "$proctorName" ] || [ -z "$teamName" ] || [[ -z "$apiUrl" ]]; then
    echo "Parameter missing..."
    usage
fi

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo $(( $RANDOM % 10 ))
}

if [[ -z "$proctorNumber" ]]; then
    echo "Using a random proctor environment number since not specified."
    proctorNumber="$(randomChar;randomChar;randomChar;randomNum;)"
fi

declare resourceGroupProctor="${proctorName}${proctorNumber}-rg";
declare registryName="${proctorName}${proctorNumber}acr"
declare clusterName="${proctorName}${proctorNumber}aks"
declare cosmosDBName="${proctorName}${proctorNumber}db"
declare storageAccount="${proctorName}${proctorNumber}sa"
declare functionAppName="${proctorName}${proctorNumber}fun"
declare apiUrl="https://"$functionAppName".azurewebsites.net"

echo "=========================================="
echo " VARIABLES"
echo "=========================================="
echo "subscriptionId            = "${subscriptionId}
echo "resourceGroupLocation     = "${resourceGroupLocation}
echo "proctorName               = "${proctorName}
echo "proctorNumber             = "${proctorNumber}
echo "teamName                  = "${teamName}
echo "resourceGroupProctor      = "${resourceGroupProctor}
echo "registryName              = "${registryName}
echo "clusterName               = "${clusterName}
echo "cosmosDBName              = "${cosmosDBName}
echo "storageAccount            = "${storageAccount}
echo "functionAppName           = "${functionAppName}
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
if [ `az group exists -n $resourceGroupProctor -o tsv` == false ]; then
    echo "Resource group with name" $resourceGroupProctor "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        az group create --name $resourceGroupProctor --location $resourceGroupLocation
    )
else
    echo "Using existing resource group..."
fi

echo "1-Provision CosmosDB"
bash ./deploy_cosmos_db.sh -g $resourceGroupProctor -n $cosmosDBName

echo "2-Provision Azure Function"
bash ./deploy_function.sh -g $resourceGroupProctor -l $resourceGroupLocation -s $storageAccount -f $functionAppName -c $cosmosDBName

echo "3-Provision ACR  (bash ./provision_acr.sh -i $subscriptionId -g $resourceGroupProctor -r $registryName -l $resourceGroupLocation)"
bash ../provision-team/provision_acr.sh -i $subscriptionId -g $resourceGroupProctor -r $registryName -l $resourceGroupLocation

echo "4-Provision AKS  (bash ./provision_aks.sh -i $subscriptionId -g $resourceGroupProctor -c $clusterName -l $resourceGroupLocation)"
bash ../provision-team/provision_aks.sh -i $subscriptionId -g $resourceGroupProctor -c $clusterName -l $resourceGroupLocation

# Remove do to the permission with the role assignment
echo "5-Set AKS/ACR permissions  (bash ./provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupProctor -c $clusterName -r $registryName -l $resourceGroupLocation)"
bash ../provision-team/provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupProctor -c $clusterName -r $registryName -l $resourceGroupLocation

echo "6-Deploy ingress  (bash ./deploy_ingress_dns.sh -s ./test_fetch_build -l $resourceGroupLocation -n ${proctorName})"
bash ../provision-team/deploy_ingress_dns.sh -s . -l $resourceGroupLocation -n ${proctorName}

# Save the public DNS address to be provisioned in the helm charts for each service
dnsURL='akstraefik'${proctorName}'.'$resourceGroupLocation'.cloudapp.azure.com'
echo -e "DNS URL for "${proctorName}" is:\n"$dnsURL

echo "7-Build and deploy sentinel to AKS  (bash ./build_deploy_sentinel.sh -r $resourceGroupProctor -g $registryName -n ${teamName} -e $numberTeams -l $location -a $apiUrl)"
bash ./build_deploy_sentinel.sh -r $resourceGroupProctor -g $registryName -n ${teamName} -e $numberTeams -l $resourceGroupLocation -a $apiUrl

echo "8-Build and deploy leaderboard website to AKS  (bash ./build_deploy_web.sh -m $proctorName -d <dnsURL>)"
bash ./build_deploy_web.sh -m $proctorName -d $dnsURL

echo "9-Clean the working environment"
bash ../provision-team/cleanup_environment.sh -t ${proctorName}

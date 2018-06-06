#!/bin/bash

# set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: setup.sh -i <subscriptionId> -l <resourceGroupLocation> -n <teamName> -e <teamNumber> " 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupLocation=""
declare teamName=""
declare teamNumber=""

# Initialize parameters specified from command line
while getopts ":i:l:n:e:" arg; do
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
            teamNumber=${OPTARG}
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

type -p sqlcmd
if [ ! $? == 0 ]; then
    echo "sqlcmd not found, install and re-run setup."
    exit 1
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

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupLocation" ] || [ -z "$teamName" ] ; then
    echo "Parameter missing..."
    usage
fi

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo -n $(( $RANDOM % 10 ))
}

randomCharUpper() {
    s=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    p=$(( $RANDOM % 26))
    echo -n ${s:$p:1}
}

if [[ -z "$teamNumber" ]]; then
    echo "Using a random team number since not specified."
    teamNumber="$(randomChar;randomChar;randomChar;randomNum;)"
fi

declare resourceGroupTeam="${teamName}${teamNumber}rg";
declare registryName="${teamName}${teamNumber}acr"
declare clusterName="${teamName}${teamNumber}aks"
declare keyVaultName="${teamName}${teamNumber}kv"
declare sqlServerName="${teamName}${teamNumber}sql"
declare hostingPlanName="${teamName}${teamNumber}plan"
declare mobileAppName="${teamName}${teamNumber}app"
declare sqlServerUsername="${teamName}${teamNumber}sa"
declare sqlServerPassword="$(randomChar;randomCharUpper;randomNum;randomChar;randomChar;randomNum;randomCharUpper;randomChar;randomNum)pwd"
declare sqlDBName="mydrivingDB"

echo "=========================================="
echo " VARIABLES"
echo "=========================================="
echo "subscriptionId            = "${subscriptionId}
echo "resourceGroupLocation     = "${resourceGroupLocation}
echo "teamName                  = "${teamName}
echo "teamNumber                = "${teamNumber}
echo "keyVaultName              = "${keyVaultName}
echo "resourceGroupTeam         = "${resourceGroupTeam}
echo "registryName              = "${registryName}
echo "clusterName               = "${clusterName}
echo "sqlServerName             = "${sqlServerName}
echo "sqlServerUsername         = "${sqlServerUsername}
echo "sqlServerPassword         = "${sqlServerPassword}
echo "sqlDBName                 = "${sqlDBName}
echo "hostingPlanName           = "${hostingPlanName}
echo "mobileAppName             = "${mobileAppName}
echo "=========================================="


#login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
    az login
    exit 0
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

# Verify that the teamConfig dir exist
if [ ! -d "$HOME/team_env" ]; then
   mkdir $HOME/team_env
fi

# Verify that the team dir exist
if [ ! -d "$HOME/team_env/${teamName}${teamNumber}" ]; then
   mkdir $HOME/team_env/${teamName}${teamNumber}
fi

#create the initial team_service_config.json
if [ ! -f "$HOME/team_env/team_service_config.json" ]; then
   touch $HOME/team_env/team_service_config.json
fi

initialJson="{\"teams:[]\"}"

echo $initialJson > $HOME/team_env/team_service_config.json

echo "0-Provision KeyVault  (bash ./provision_kv.sh -i $subscriptionId -g $resourceGroupTeam -k $keyVaultName -l $resourceGroupLocation)"
bash ./provision_kv.sh -i $subscriptionId -g $resourceGroupTeam -k $keyVaultName -l $resourceGroupLocation

echo "1-Provision ACR  (bash ./provision_acr.sh -i $subscriptionId -g $resourceGroupTeam -r $registryName -l $resourceGroupLocation)"
bash ./provision_acr.sh -i $subscriptionId -g $resourceGroupTeam -r $registryName -l $resourceGroupLocation

echo "2-Provision AKS  (bash ./provision_aks.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -l $resourceGroupLocation)"
bash ./provision_aks.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -l $resourceGroupLocation

# Remove do to the permission with the role assignment
echo "3-Set AKS/ACR permissions  (bash ./provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -r $registryName -l $resourceGroupLocation)"
bash ./provision_aks_acr_auth.sh -i $subscriptionId -g $resourceGroupTeam -c $clusterName -r $registryName -l $resourceGroupLocation

echo "4-Clone repo"
bash ./git_fetch.sh -u https://github.com/Azure-Samples/openhack-devops-team -s ./test_fetch_build

echo "5-Deploy ingress  (bash ./deploy_ingress_dns.sh -s ./test_fetch_build -l $resourceGroupLocation -n ${teamName}${teamNumber})"
bash ./deploy_ingress_dns.sh -s ./test_fetch_build -l $resourceGroupLocation -n ${teamName}${teamNumber}

echo "6-Provision SQL & Mobile App  (bash ./provision_sql_mobileapp.sh -s ./test_fetch_build -g $resourceGroupTeam -l $resourceGroupLocation -q $sqlServerName -m $mobileAppName -h $hostingPlanName -k $keyVaultName -u $sqlServerUsername -p $sqlServerPassword -d $sqlDBName)"
bash ./provision_sql_mobileapp.sh -g $resourceGroupTeam -l $resourceGroupLocation -q $sqlServerName -m $mobileAppName -h $hostingPlanName -k $keyVaultName -u $sqlServerUsername -p $sqlServerPassword -d $sqlDBName

echo "7-Configure SQL  (bash ./configure_sql.sh -s ./test_fetch_build -g $resourceGroupTeam -u $sqlServerUsername -n ${teamName}${teamNumber} -k $keyVaultName -d $sqlDBName)"
bash ./configure_sql.sh -s ./test_fetch_build -g $resourceGroupTeam -u $sqlServerUsername -n ${teamName}${teamNumber} -k $keyVaultName -d $sqlDBName

# Save the public DNS address to be provisioned in the helm charts for each service
dnsURL='akstraefik'${teamName}${teamNumber}'.'$resourceGroupLocation'.cloudapp.azure.com'
echo -e "DNS URL for "${teamName}" is:\n"$dnsURL

echo "8-Build and deploy POI API to AKS  (bash ./build_deploy_poi.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-poi' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName)"
bash ./build_deploy_poi.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-poi' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName

echo "9-Build and deploy User API to AKS  (bash ./build_deploy_user.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-user' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName)"
bash ./build_deploy_user.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-user' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName

echo "10-Build and deploy Trip API to AKS  (# bash ./build_deploy_trip.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-trip' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName)"
bash ./build_deploy_trip.sh -s ./test_fetch_build -b Release -r $resourceGroupTeam -t 'api-trip' -d $dnsURL -n ${teamName}${teamNumber} -g $registryName

echo "11-Build and deploy the simulator (# bash Usage: build_deploy_simulator.sh -n ${teamName}${teamNumber} -q 18000 -t <image tag optional>)"
bash ./build_deploy_simulator.sh -n ${teamName}${teamNumber} -q '18000'

echo "12-Check services (# bash ./service_check.sh -d ${dnsURL} -n ${teamName}${teamNumber})"
bash ./service_check.sh -d ${dnsURL} -n ${teamName}${teamNumber}

echo "13-Clean the working environment"
bash ./cleanup_environment.sh -t ${teamName}

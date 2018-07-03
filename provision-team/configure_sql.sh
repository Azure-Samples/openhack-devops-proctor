#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: configure_sql.sh -s <relative save location> -g <resourceGroupName> -u <sql server user name> -n <teamName> -k <keyVaultName> -d <sqlDBName>" 1>&2; exit 1; }

declare relativeSaveLocation=""
declare resourceGroupName=""
declare sqlServerUsername=""
declare teamName=""
declare keyVaultName=""
declare sqlDBName=""

# Initialize parameters specified from command line
while getopts ":s:g:n:u:k:d:" arg; do
    case "${arg}" in
        s)
            relativeSaveLocation=${OPTARG}
        ;;
        g)
            resourceGroupName=${OPTARG}
        ;;
        u)
            sqlServerUsername=${OPTARG}
        ;;
        n)
            teamName=${OPTARG}
        ;;
        k)
            keyVaultName=${OPTARG}
        ;;
        d)
            sqlDBName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$relativeSaveLocation" ]]; then
    echo "Enter a source code path:"
    read relativeSaveLocation
    [[ "${relativeSaveLocation:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
    echo "Enter the resource group name:"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$sqlServerUsername" ]]; then
    echo "Enter the sql server user name:"
    read sqlServerUsername
    [[ "${sqlServerUsername:?}" ]]
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name to be used in app provisioning:"
    read teamName
fi

if [[ -z "$keyVaultName" ]]; then
    echo "Enter the name of the keyvault that was provisioned in shared infrastructure:"
    read keyVaultName
fi

if [[ -z "$sqlDBName" ]]; then
    echo "Enter the name of the SQL Server DB that was provisioned in shared infrastructure:"
    read sqlDBName
fi

INGRESS_IP=$(kubectl get svc team-ingress-traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get the name of the SQL server
sqlServer=$(az keyvault secret show --vault-name $keyVaultName --name sqlServerName -o tsv --query value)

# Add firewall rule to allow APIs to connect to SQL server database
az sql server firewall-rule create -n allow-k8s-ingress -g $resourceGroupName -s $sqlServer --start-ip-address $INGRESS_IP --end-ip-address $INGRESS_IP

echo -e "\n\nSQL Server Firewall rule added to allow $INGRESS_IP."

# Get the values to update the SQL Server secrets yaml file and create it on the cluster
sqlServerFQDN=$(az keyvault secret show --vault-name $keyVaultName --name sqlServerFQDN -o tsv --query value)
sqlPassword=$(az keyvault secret show --vault-name $keyVaultName --name sqlServerPassword -o tsv --query value)

# Base64 encode the values are required for K8s secrets
sqlServerFQDNbase64=$(echo -n $sqlServerFQDN | base64)
sqlPasswordbase64=$(echo -n $sqlPassword | base64)
sqlUserbase64=$(echo -n $sqlServerUsername | base64)

# Replace the secrets file with encoded values and create the secret on the cluster
cat "./sql-secret.yaml" \
    | sed "s/userreplace/$sqlUserbase64/g" \
    | sed "s/passwordreplace/$sqlPasswordbase64/g" \
    | sed "s/serverreplace/$sqlServerFQDNbase64/g" \
    | tee $relativeSaveLocation"/sql-secret-$teamName.yaml"
kubectl apply -f $relativeSaveLocation"/sql-secret-$teamName.yaml"


#Create firewall rule to run schema create
az sql server firewall-rule create -n allow-create-schema -g $resourceGroupName -s $sqlServer --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.254

#Create schema in db
sqlcmd -U $sqlServerUsername -P $sqlPassword -S $sqlServerFQDN -d $sqlDBName -i ./MYDrivingDB.sql -e

#Add Sample data
bash ./sql_data_init.sh -s $sqlServerFQDN -u $sqlServerUsername -p $sqlPassword -d $sqlDBName

#Remove firewall rule
az sql server firewall-rule delete -n allow-create-schema -g $resourceGroupName -s $sqlServer

#Create launch.json and tasks.json files
bash ./build_launch_json.sh -s $sqlServer -u $sqlServerUsername -p $sqlPassword -t $teamName
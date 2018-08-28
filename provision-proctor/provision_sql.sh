#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: provision_sql_backend.sh -g <resourceGroupName> -l <resourceGroupLocation> -s <sqlServerName> -k <keyVaultName> -u <sqlServerUsername> -p <sqlServerPassword> -d <sqlDBName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceGroupLocation=""
declare sqlServerName=""
declare keyVaultName=""
declare sqlServerUsername=""
declare sqlServerPassword=""
declare sqlDBName=""

# Initialize parameters specified from command line
while getopts ":g:l:q:k:u:p:d:" arg; do
    case "${arg}" in
        g)
            resourceGroupName=${OPTARG}
        ;;
        l)
            resourceGroupLocation=${OPTARG}
        ;;
        q)
            sqlServerName=${OPTARG}
        ;;
        k)
            keyVaultName=${OPTARG}
        ;;
        u)
            sqlServerUsername=${OPTARG}
        ;;
        p)
            sqlServerPassword=${OPTARG}
        ;;
        d)
            sqlDBName=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

echo "Creating SQL Server..."
(
	set -x
	az sql server create --name $sqlServerName --resource-group $resourceGroupName \
	--location $resourceGroupLocation --admin-user $sqlServerUsername --admin-password $sqlServerPassword
)

if [ $? == 0 ];
then
    echo "SQL Server" $sqlServerName "created successfully..."
fi

echo "Setting firewall rules of SQL Server..."
(
	set -x
    az sql server firewall-rule create --resource-group $resourceGroupName \
    --server $sqlServerName -n "Allow Access To Azure Services" --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
)

if [ $? == 0 ];
then
    echo "Firewall rules of SQL Server" $sqlServerName "created successfully..."
fi


echo "Creating the database..."
(
	set -x
	az sql db create --server $sqlServerName --resource-group $resourceGroupName --name $sqlDBName \
	--service-objective S6 --collation 'SQL_Latin1_General_CP1_CI_AS'
)

if [ $? == 0 ];
then
    echo "Database" $sqlDBName "created successfully..."
fi


echo "Adding values to Key Vault..."
(
	set -x
    sqlServerFQDN=$(az sql server show -g $resourceGroupName -n $sqlServerName --query "fullyQualifiedDomainName" --output tsv)
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerName' --value $sqlServerName
    az keyvault secret set --vault-name $keyVaultName --name 'sqlDBName' --value $sqlDBName
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerUsername' --value $sqlServerUsername'@'$sqlServerFQDN
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerPassword' --value $sqlServerPassword
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerFQDN' --value $sqlServerFQDN
)


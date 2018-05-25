#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: provision_sql_mobileapp.sh -g <resourceGroupName> -l <resourceGroupLocation> -s <sqlServerName> -m <mobileAppName> -h <hostingPlanName> -k <keyVaultName> -u <sqlServerUsername> -p <sqlServerPassword> -d <sqlDBName>" 1>&2; exit 1; }

declare resourceGroupName=""
declare resourceGroupLocation=""
declare sqlServerName=""
declare mobileAppName=""
declare hostingPlanName=""
declare keyVaultName=""
declare sqlServerUsername=""
declare sqlServerPassword=""
declare sqlDBName=""

# Variables
startip="0.0.0.0"
endip="255.255.255.255"

# Initialize parameters specified from command line
while getopts ":g:l:q:m:h:k:u:p:d:" arg; do
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
        m)  
            mobileAppName=${OPTARG}
        ;;
        h)  
            hostingPlanName=${OPTARG}
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

echo "$(tput setaf 3)Creating App Service plan...$(tput sgr 0)"
(
	set -x
	az appservice plan create --name $hostingPlanName --resource-group $resourceGroupName \
	--location $resourceGroupLocation
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)App Service plan" $hostingPlanName "created successfully...$(tput sgr 0)"
fi


echo "$(tput setaf 3)Creating web app...$(tput sgr 0)"
(
	set -x
	az webapp create --name $mobileAppName --plan $hostingPlanName --resource-group $resourceGroupName
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)Web app" $mobileAppName "created successfully...$(tput sgr 0)"
fi

echo "$(tput setaf 3)Creating SQL Server...$(tput sgr 0)"
(
	set -x
	az sql server create --name $sqlServerName --resource-group $resourceGroupName \
	--location $resourceGroupLocation --admin-user $sqlServerUsername --admin-password $sqlServerPassword
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)SQL Server" $sqlServerName "created successfully...$(tput sgr 0)"
fi

echo "$(tput setaf 3)Setting firewall rules of SQL Server...$(tput sgr 0)"
(
	set -x
	az sql server firewall-rule create --server $sqlServerName --resource-group $resourceGroupName \
	--name AllowYourIp --start-ip-address $startip --end-ip-address $endip
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)Firewall rules of SQL Server" $sqlServerName "created successfully...$(tput sgr 0)"
fi


echo "$(tput setaf 3)Creating the database...$(tput sgr 0)"
(
	set -x
	az sql db create --server $sqlServerName --resource-group $resourceGroupName --name $sqlDBName \
	--service-objective S0 --collation 'SQL_Latin1_General_CP1_CI_AS'
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)Database" $sqlDBName "created successfully...$(tput sgr 0)"
fi

echo "$(tput setaf 3)Getting the connections string and assigning it to the app settings of the we app...$(tput sgr 0)"
(
	set -x
	connstring=$(az sql db show-connection-string --name $sqlDBName --server $sqlServerName \
	--client ado.net --output tsv)
	connstring=${connstring//<username>/$sqlServerUsername}
	connstring=${connstring//<password>/$sqlServerPassword}
	az webapp config appsettings set --name $mobileAppName --resource-group $resourceGroupName \
	--settings "SQLSRV_CONNSTR=$connstring"
)

if [ $? == 0 ];
then
    echo "$(tput setaf 2)Connection string added to web app" $mobileAppName " successfully...$(tput sgr 0)"
fi

echo "$(tput setaf 3)Adding values to Key Vault...$(tput sgr 0)"
(
	set -x
    sqlServerFQDN=$(az sql server show -g $resourceGroupName -n $sqlServerName --query "fullyQualifiedDomainName" --output tsv)
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerName' --value $sqlServerName
    az keyvault secret set --vault-name $keyVaultName --name 'sqlDBName' --value $sqlDBName
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerUsername' --value $sqlServerUsername'@'$sqlServerFQDN
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerPassword' --value $sqlServerPassword
    az keyvault secret set --vault-name $keyVaultName --name 'sqlServerFQDN' --value $sqlServerFQDN
    az keyvault secret set --vault-name $keyVaultName --name 'mobileAppName' --value $mobileAppName
)


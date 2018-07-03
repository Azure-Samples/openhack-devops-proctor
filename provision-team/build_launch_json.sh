#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#script requires latest version of .netcore to be installed ()


usage() { echo "Usage: build_launch_json.sh -t <teamName> -s <sql server name>  -u <sql server username> -p <sql server password>" 1>&2; exit 1; }

declare SQL_PASSWORD=""
declare SQL_SERVER=""
declare SQL_USER=""
declare teamName=""

# Initialize parameters specified from command line
while getopts ":t:s:u:p:" arg; do
    case "${arg}" in
        t)
            teamName=${OPTARG}
        ;;
        s)
            SQL_SERVER=${OPTARG}
        ;;
        u)
            SQL_USER=${OPTARG}
        ;;
        p)
            SQL_PASSWORD=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$SQL_SERVER" ]]; then
    echo "Enter a sql server name:"
    read relativeSaveLocation
    [[ "${SQL_SERVER:?}" ]]
fi

if [[ -z "$SQL_USER" ]]; then
    echo "Enter a sql user name name:"
    read resourceGroupName
    [[ "${SQL_USER:?}" ]]
fi

if [[ -z "$SQL_PASSWORD" ]]; then
    echo "Enter the sql server password:"
    read sqlServerUsername
    [[ "${SQL_PASSWORD:?}" ]]
fi

if [[ -z "$teamName" ]]; then
    echo "Enter a team name"
    read teamName
fi
touch $HOME/team_env/$teamName/launch.json
touch $HOME/team_env/$teamName/tasks.json
cp ./templates/launch.json.template $HOME/team_env/$teamName/launch.json
cp ./templates/tasks.json.template $HOME/team_env/$teamName/tasks.json

sed -i -e 's/{SQL_PASSWORD}/'$SQL_PASSWORD'/g' $HOME/team_env/$teamName/launch.json
sed -i -e 's/{SQL_SERVER}/'$SQL_SERVER'/g' $HOME/team_env/$teamName/launch.json
sed -i -e 's/{SQL_USER}/'$SQL_USER'/g' $HOME/team_env/$teamName/launch.json

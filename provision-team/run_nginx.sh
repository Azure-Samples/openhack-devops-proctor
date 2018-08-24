#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: run_nginx  -n ${teamName}${teamNumber}" 1>&2; exit 1; }

declare teamId=""

# Initialize parameters specified from command line
while getopts ":n:" arg; do
    case "${arg}" in
        n)
            teamId=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$teamId" ]]; then
    echo "teamId was not set properly"
    read teamId
fi


# Copy the team kvstore file to a known name
sudo cp /home/azureuser/team_env/kvstore/${teamId} /home/azureuser/team_env/kvstore/ohteamvalues

# Add nginx to the script
udo docker run -v /home/azureuser/openhack-devops-proctor/provision-team/nginx/:/etc/nginx/conf.d/ -v /home/azureuser/team_env/kvstore/:/usr/share/nginx/html -p 2018:80 -d nginx
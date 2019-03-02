#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: run_nginx.sh" 1>&2; exit 1; }

# create a www directory
if [[ ! -d "/home/azureuser/www" ]]; then
    mkdir -p /home/azureuser/www
fi 

cp -R /home/azureuser/openhack-devops-proctor/provision-team/nginx/* /home/nginx/config

# Add nginx to the script
docker run --restart always -v /home/nginx/config/:/etc/nginx/conf.d/ -v /home/nginx/contents/:/usr/share/nginx/html -p 2018:80 -d nginx

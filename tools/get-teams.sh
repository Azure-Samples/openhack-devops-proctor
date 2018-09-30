#!/bin/bash

usage() { echo "Usage: getteams.sh -p <credentials.csv> -i <ssh_private_key>" 1>&2; exit 1; }

while getopts ":p:i:" arg; do
    case "${arg}" in
        p)
            csvFile=${OPTARG}
        ;;
        i)
            ID_RSA_FILE=${OPTARG}
        ;;
    esac
done

if [[ -z "$csvFile" ]]; then
    echo "Indicate the path to the csvfile that was downloaded from the classroom management portal"
    read csvFile
fi
if [[ -z "$ID_RSA_FILE" ]]; then
    echo "Indicate the path to the ssh secret key to connect to the provisioning VMs"
    read ID_RSA_FILE
fi

DEPLOYMENTSTATUS=0

if [ ! -f $csvFile ]; then
    echo "File $csvFile not found"
    exit 1
fi

uniquecred=$(awk -F, '!seen[$3]++' $csvFile)
touch ./errors.log

IFS=$'\n'
for cred in $uniquecred
do 
    portalUserName=$(echo $cred | awk -F ", " '{ print $1 }')
    subid=$(echo $cred | awk -F ", " '{ print $3 }')
    username=$(echo $cred | awk -F ", " '{ print $5 }')
    password=$(echo $cred | awk -F ", " '{ print $6 }')
    GUID=$(echo $subid | sed -E -e 's/.{8}-.{4}-.{4}-.{4}-.{12}/guid/')
    if [[ $GUID == "guid" ]]; then
        az login --username=$username --password=$password > /dev/null
        ipaddress=$(az vm list-ip-addresses --resource-group=ProctorVMRG --name=proctorVM --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -otsv)
        if [[ $ipaddress =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            teamAAD=$(echo "$username"  | sed -e 's/.*?*@\(.*\)ops.onmicrosoft.com/\1/')
            #echo "$teamAAD is at $ipaddress"
            if [[ ! -d "$teamAAD" ]]; then
                mkdir -p $teamAAD
            fi 

            scp -o StrictHostKeyChecking=no -i $ID_RSA_FILE -r azureuser@$ipaddress:/home/azureuser/team_env/* ./$teamAAD/
            if [ $? -ne 0 ]; then
                echo "[ERROR] Getting team_env directory failed" >> errors.log
            fi

            scp -o StrictHostKeyChecking=no -i $ID_RSA_FILE azureuser@$ipaddress:/home/azureuser/openhack-devops-proctor/provision-team/teamdeploy.out ./$teamAAD/
            if [ $? -ne 0 ]; then
                echo "[ERROR] Getting teamdeploy.out file failed" >> errors.log
            fi

            grep -x '############ END OF TEAM PROVISION ############' ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of $teamAAD has failed in subscription $subid and portal username $portalUserName" >> errors.log 
            fi
        fi
    fi
done

# Packaging the results
zip -r teamfiles.zip *

echo "Data from the teams deployment are in teamfiles.zip"

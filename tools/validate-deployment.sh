#!/bin/bash
# This script verifies the successfull deployment of the resources needed for the DevOps OpenHack.
# You need to provide the CSV file with all the credentials of the Azure subscriptions from the classroom management portal and a private / public SSH keypair that will be used to access the provisioning VMs
# The error log file is where will be logged the informations regarding the failed deployments. If not provided, it defaults to error.log. 

usage() { echo "Usage: validate-deployment.sh -f <errorlog_file> -u <service principal username> -x < service principal password> -t < service principal tenant>" 1>&2; exit 1; }

while getopts ":f:u:x:t:" arg; do
    case "${arg}" in
        f)
            ERROR_FILE=${OPTARG}
        ;;
        u)
            USERNAME=${OPTARG}
        ;;
        x)
            PASSWORD=${OPTARG}
        ;;
        t)
            TENANT=${OPTARG}
        ;;
    esac
done

KEY_DIR=~/devopsohkeys
mkdir -p ${KEY_DIR}
ID_RSA_PRIVATE=${KEY_DIR}/devops_openhack_key
ID_RSA_PUBLIC=${KEY_DIR}/devops_openhack_key.pub
ssh-keygen -t rsa -C "DevOps OpenHack" -f ${ID_RSA_PRIVATE} -P ""

echo "Keys have been generated"

if [[ -z "$ERROR_FILE" ]]; then
    ERROR_FILE="./errors.log"
fi

DEPLOYMENTSTATUS=0

touch $ERROR_FILE

az login --service-principal -u $USERNAME -p $PASSWORD --tenant $TENANT

ipaddress=$(az vm list-ip-addresses --resource-group=ProctorVMG --name=proctorVM --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -otsv)
echo IPADDRESS:$ipaddress

location=$(az group show -n ProctorVMG --query location | tr -d '"')
date=$(date '+%d/%m/%Y')

if [[ $ipaddress =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    teamAAD=$location
    echo TEAM:$teamAAD
    
    if [[ ! -d "$teamAAD" ]]; then
    mkdir -p $teamAAD
    fi
    
    # Changing the SSH key if asked 
    if [[ -n "$ID_RSA_PUBLIC" ]]; then
        echo "Resetting public key to ProctorVM "
        az vm user update --resource-group=ProctorVMG --name=proctorVM --username azureuser --ssh-key-value $ID_RSA_PUBLIC
    else
        echo "[ERROR] Public key missing when resetting key for ProctorVM for $teamAAD - Subscription $subid - Exiting ..."
    fi

    scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE -r azureuser@$ipaddress:/home/azureuser/logs/* ./$teamAAD/
    if [ $? -ne 0 ]; then
        echo "[ERROR] Getting team_env directory failed" >> $ERROR_FILE
    fi
    # Getting stderr and stdout from custom script extension.
    ssh -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress "bash -s" << EOF
        sudo cp /var/lib/waagent/custom-script/download/0/stderr .;
        sudo chown azureuser:azureuser ./stderr;
EOF
    scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:./stderr ./$teamAAD/
    ssh -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress "bash -s" << EOF
        sudo cp /var/lib/waagent/custom-script/download/0/stdout .;
        sudo chown azureuser:azureuser ./stdout;
EOF
    errorflag=true
    scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:./stdout ./$teamAAD/
    # Getting deployment logs 
    scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:/home/azureuser/openhack-devops-proctor/provision-team/teamdeploy.out ./$teamAAD/
    if [ $? -ne 0 ]; then
        echo "[ERROR] Getting teamdeploy.out file failed for subscription $subid, portal username $portalUserName, AAD $teamAAD, VM IP is $ipaddress" >> $ERROR_FILE
        errorflag=false
    fi

    grep -x "poi   \[X\]" ./$teamAAD/teamdeploy.out
    if [ $? -ne 0 ]; then
        echo "[ERROR] - Deployment of API poi has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE
        errorflag=false 
    fi

    grep -x "user  \[X\]" ./$teamAAD/teamdeploy.out
    if [ $? -ne 0 ]; then
        echo "[ERROR] - Deployment of API user has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE
        errorflag=false 
    fi

    grep -x "trips \[X\]" ./$teamAAD/teamdeploy.out
    if [ $? -ne 0 ]; then
        echo "[ERROR] - Deployment of API trips has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE
        errorflag=false
    fi

    grep -x "user-java \[X\]" ./$teamAAD/teamdeploy.out
     if [ $? -ne 0 ]; then
        echo "[ERROR] - Deployment of API user-java has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE
        errorflag=false 
    fi
    
    grep -x '############ END OF TEAM PROVISION ############' ./$teamAAD/teamdeploy.out
    if [ $? -ne 0 ]; then
        echo "[ERROR] - Deployment of $teamAAD has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE 
        errorflag=false  
    fi
fi
        
# Packaging the results
if [[ $ZIP_FILES ]]; then
    zip -r teamfiles.zip OTA*
    echo "Data from the teams deployment are in teamfiles.zip"
fi

if [ "$errorflag" = false ]; then
    echo "Failures encountered during checking API"
    exit 1
else
    echo "success"
    exit 0
fi

echo "######## End of validation script ########"

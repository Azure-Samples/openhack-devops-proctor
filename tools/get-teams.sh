#!/bin/bash

# This script verifies the successfull deployment of the resources needed for the DevOps OpenHack.
# You need to provide the CSV file with all the credentials of the Azure subscriptions from the classroom management portal and a private / public SSH keypair that will be used to access the provisioning VMs
# The error log file is where will be logged the informations regarding the failed deployments. If not provided, it defaults to error.log. 

usage() { echo "Usage: getteams.sh -c <credentials.csv> -k <ssh_private_key> -p <ssh_public_key> -l <errorlog_file> " 1>&2; exit 1; }

while getopts ":c:k:l:p:" arg; do
    case "${arg}" in
        c)
            csvFile=${OPTARG}
        ;;
        k)
            ID_RSA_PRIVATE=${OPTARG}
        ;;
        l)
            ERROR_FILE=${OPTARG}
        ;;
        p)
            ID_RSA_PUBLIC=${OPTARG}
        ;;
    esac
done

declare ZIP_FILES=0

if ! [[ -x "$(gunip --version)" ]]; then
    echo -e "zip is not installed, you will have to package the files manually.\nRun the following command on Ubuntu: sudo apt-get install zip\nDo you want to continue? (yes|no)"
    read INSTALL_ZIP 
    if [[ "$INSTALL_ZIP" != "y" && "$INSTALL_ZIP" != "yes"  ]]; then 
        echo "Exiting ..."
        exit 1 
    else
        ZIP_FILES=1
    fi
fi

if [[ -z "$csvFile" ]]; then
    echo "Indicate the path to the csvfile that was downloaded from the classroom management portal"
    read csvFile
fi

if [[ -z "$ID_RSA_PRIVATE" ]]; then
    echo "No private key provided, will generate a new pair devops_openhack_key"
    # Create a new rsa key - leaving the prompt to avoid overwritting existing keys.
    ssh-keygen -t rsa -C "DevOps OpenHack" -f devops_openhack_key -P ""
    if [ $? -ne 0 ]; then
        echo "[ERROR] Creating the ssh keypair for the proctorVM failed "
    fi
    ID_RSA_PRIVATE="./devops_openhack_key"
    ID_RSA_PUBLIC="./devops_openhack_key.pub"
    echo "Keys have been generated"
else
    if [[ -z "$ID_RSA_PUBLIC" ]]; then
        echo "Path to public key file is missing"
        read ID_RSA_PUBLIC
    fi
fi

if [[ -z "$ERROR_FILE" ]]; then
    ERROR_FILE="./errors.log"
fi

DEPLOYMENTSTATUS=0

if [ ! -f $csvFile ]; then
    echo "File $csvFile not found"
    exit 1
fi

uniquecred=$(awk -F, '!seen[$3]++' $csvFile)
touch $ERROR_FILE

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
            if [[ ! -d "$teamAAD" ]]; then
                mkdir -p $teamAAD
            fi

            # Changing the SSH key if asked 
            if [[ -n "$ID_RSA_PUBLIC" ]]; then
                echo "Resetting public key to ProctorVM "
                az vm user update --resource-group=ProctorVMRG --name=proctorVM --username azureuser --ssh-key-value $ID_RSA_PUBLIC
            else
                echo "[ERROR] Public key missing when resetting key for ProctorVM for $teamAAD - Subscription $subid"
            fi

            scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE -r azureuser@$ipaddress:/home/azureuser/team_env/* ./$teamAAD/
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
            scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:./stdout ./$teamAAD/

            # Getting deployment logs 
            scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:/home/azureuser/openhack-devops-proctor/provision-team/teamdeploy.out ./$teamAAD/
            if [ $? -ne 0 ]; then
                echo "[ERROR] Getting teamdeploy.out file failed for subscription $subid, portal username $portalUserName, AAD $teamAAD, VM IP is $ipaddress" >> $ERROR_FILE
            fi

            grep -x "poi   \[X\]" ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of API poi has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE 
            fi

            grep -x "user  \[X\]" ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of API user has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE
            fi

            grep -x "trips \[X\]" ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of API trips has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE 
            fi

            grep -x "user-java \[X\]" ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of API user-java has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE 
            fi

            grep -x '############ END OF TEAM PROVISION ############' ./$teamAAD/teamdeploy.out
            if [ $? -ne 0 ]; then
                echo "[ERROR] - Deployment of $teamAAD has failed in subscription $subid, portal username $portalUserName, AAD $teamAAD - VM IP is $ipaddress" >> $ERROR_FILE  
            fi
        fi
    fi
done

# Packaging the results
if [[ $ZIP_FILES]]; then
    zip -r teamfiles.zip OTA*
    echo "Data from the teams deployment are in teamfiles.zip"
fi

echo "######## End of validation script ########"

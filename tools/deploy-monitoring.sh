#!/bin/bash

# This script deploys the monitoring infrastructire of the DevOps OpenHack.
# You need to provide the 
#  

usage() { echo "Usage: ./deploy-monitoring -l <location> -u '<azure_username>' -p '<azure_password>' -k <ssh_private_key> -f <log_file>" 1>&2; exit 1; }

while getopts ":f:k:l:p:u:" arg; do
    case "${arg}" in
        f)
            LOGFILE=${OPTARG}
        ;;
        k)
            ID_RSA_PRIVATE=${OPTARG}
        ;;
        l)
            AZURE_LOCATION=${OPTARG}
        ;;
        p)
            AZURE_PASSWORD=${OPTARG}
        ;;
        u)
            AZURE_USERNAME=${OPTARG}
        ;;
    esac
done

if [[ -z "$AZURE_USERNAME" ]]; then
    echo "Indicate the Azure username to access the subscription where the monitoring tools will be deployed"
    read AZURE_USERNAME
    if [[ -z "$AZURE_USERNAME" ]]; then
        echo -e "Azure username is empty\nExiting ..."
        exit 1
    fi
fi

if [[ -z "$AZURE_PASSWORD" ]]; then
    echo "Indicate the Azure password to access the subscription where the monitoring tools will be deployed"
    read AZURE_PASSWORD
    if [[ -z "$AZURE_PASSWORD" ]]; then
        echo -e "Azure password is empty\nExiting ..."
        exit 1
    fi
fi

if [[ -z "$AZURE_LOCATION" ]]; then
    echo -e "Indicate the location where the monitoring tools will be deployed\nIt has to be a region that supports AKS\nPress Enter to accept the default value, westus"
    read AZURE_LOCATION
    AZURE_LOCATION=${AZURE_LOCATION:-westus}
fi

if [[ -z "$ID_RSA_PRIVATE" ]]; then
    echo "No private key provided, will generate a new pair devops_openhack_key"
    # Create a new rsa key - leaving the prompt to avoid overwritting existing keys.
    KEY_DIR=~/devopsohkeys
    mkdir -p ${KEY_DIR}
    ID_RSA_PRIVATE=${KEY_DIR}/devops_openhack_key
    ID_RSA_PUBLIC=${KEY_DIR}/devops_openhack_key.pub

    ssh-keygen -t rsa -C "DevOps OpenHack" -f ${ID_RSA_PRIVATE} -P ""
    if [ $? -ne 0 ]; then
        echo "[ERROR] Creating the ssh keypair for the proctorVM failed "
    fi
    echo "Keys have been generated"
else
    if [[ -z "$ID_RSA_PUBLIC" ]]; then
        echo "Path to public key file is missing"
        read ID_RSA_PUBLIC
    fi
fi

LOGFILE=${LOGFILE:-./monitoringdeploy.out}

# Obtain the IP Address of the Proctor VM on the specified subscription
az login --username=$AZURE_USERNAME --password=$AZURE_PASSWORD > /dev/null
ipaddress=$(az vm list-ip-addresses --resource-group=ProctorVMRG --name=proctorVM --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -otsv)
SUBSCRIPTION_ID=$(az account show --query "id" -otsv)
echo "Proctor VM is at IP Address: $ipaddress"
    if [[ $ipaddress =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

    # Resetting the SSH key
    if [[ -n "$ID_RSA_PUBLIC" ]]; then
        echo "Resetting public key to ProctorVM "
        az vm user update --resource-group=ProctorVMRG --name=proctorVM --username azureuser --ssh-key-value $ID_RSA_PUBLIC
    else
        echo "[ERROR] Public key missing when resetting key for ProctorVM for $teamAAD - Subscription $subid - Exiting ..."
        exit 1
    fi

    # Launch the provisioning script of the monitoring infrastructure 
        ssh -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress "bash -s"  << EOF
            source ~/.bashrc
            export PATH=\$PATH:/opt/mssql-tools/bin
            export KVSTORE_DIR=/home/azureuser/team_env/kvstore
            [ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
            source <(kubectl completion bash)
            cd openhack-devops-proctor/provision-proctor/
            nohup ./setup.sh -i $SUBSCRIPTION_ID -l $AZURE_LOCATION -u $AZURE_USERNAME -p '$AZURE_PASSWORD' > monitoringdeploy.out &
            
            while ! grep "############ END OF MONITORING PROVISION ############" monitoringdeploy.out
            do
                echo "waiting for deployment"
                sleep 10
            done
EOF
    fi

# Collect the output file 
scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$ipaddress:./openhack-devops-proctor/provision-proctor/monitoringdeploy.out ${LOGFILE}
echo "The logs from the deployment of the monitoring environment are in ${LOGFILE}"

echo "###### Deployment of the monitoring solution completed successfully ######"

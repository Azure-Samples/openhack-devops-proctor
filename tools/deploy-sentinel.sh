#!/bin/bash

# This script deploys the monitoring infrastructure of the DevOps OpenHack.
# You need to provide the 
#  

usage() { echo "Usage: ./deploy-sentinel -u <azure_username> -k <ssh_private_key> -p '<azure_password>' -m <monitoring_environment> -c <credentials.csv> -f <logfile>" 1>&2; exit 1; }

while getopts ":c:f:k:m:p:t:u:" arg; do
    case "${arg}" in
        c)
            CREDENTIALS=${OPTARG}
        ;;
        f)
            LOGFILE=${OPTARG}
        ;;
        k)
            ID_RSA_PRIVATE=${OPTARG}
        ;;
        m)
            MONITOR_ENVIRONMENT=${OPTARG}
        ;;
        p)
            AZURE_PASSWORD=${OPTARG}
        ;;
        u)
            AZURE_USERNAME=${OPTARG}
        ;;
    esac
done

# Validating the Azure credentials
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

# Validating the credentials file
if [[ -z "$CREDENTIALS" ]]; then
    echo "Indicate the path to the csv file that you have downloaded from the classroom manager"
    read CREDENTIALS
fi

if [ ! -f $CREDENTIALS ]; then
    echo -e "File does not exist or unreadable\nExiting ..."
    exit 1
fi

if [[ -z "$ID_RSA_PRIVATE" ]]; then
    echo "Indicate the private key to acces the ProctorVM, press Enter to accept ./devops_openhack_key"
    read ID_RSA_PRIVATE
    ID_RSA_PRIVATE=${ID_RSA_PRIVATE:-./devops_openhack_key}
    if [ ! -e $ID_RSA_PRIVATE ]; then
        echo -e "Private key file not found\nExiting ..."
        exit 1 
    fi
fi

# Validating the name of the monitoring environment
az login --username=$AZURE_USERNAME --password=$AZURE_PASSWORD > /dev/null
MONITOR_ENVIRONMENT=$(az group list --query "[?starts_with(name, 'monitoring')].name" -o tsv)
PROVISIONVM_IP=$(az vm list-ip-addresses --resource-group=ProctorVMRG --name=proctorVM --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -otsv)
LOGFILE=${LOGFILE:-./sentinel.out}
KUBECONFIG_FILE="/home/azureuser/team_env/${MONITOR_ENVIRONMENT%??}/kubeconfig-${MONITOR_ENVIRONMENT%??}"

echo "Provision VM is at $PROVISIONVM_IP"
echo "Monitoring environment is ${MONITOR_ENVIRONMENT%??}"
echo "ssh key is $ID_RSA_PRIVATE"
echo "logfile is $LOGFILE"
echo "KubeConfig is in ${KUBECONFIG_FILE}"

# Obtain the IP Address of the Proctor VM on the specified subscription
echo "Proctor VM is at IP Address: $PROVISIONVM_IP"
    if [[ $PROVISIONVM_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Copy the credentials file to the provisioning VM
        scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE $CREDENTIALS azureuser@$PROVISIONVM_IP:./openhack-devops-proctor/provision-proctor/${CREDENTIALS##*/}
        echo "credentials file copied to provisioning VM"

        # Launch the script to deploy sentinel  
        ssh -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$PROVISIONVM_IP "bash -s"  << EOF
            source ~/.bashrc
            export PATH=\$PATH:/opt/mssql-tools/bin
            export KVSTORE_DIR=/home/azureuser/team_env/kvstore
            [ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
            source <(kubectl completion bash)
            cd openhack-devops-proctor/provision-proctor/
            echo "Monitoring environment is : ${MONITOR_ENVIRONMENT%??}"
            bash ./deploy_sentinel.sh -p ${MONITOR_ENVIRONMENT%??} -f ${CREDENTIALS##*/} -k ${KUBECONFIG_FILE} > sentinel.out
            rm ${CREDENTIALS##*/}

            while ! grep "############ END OF SENTINEL DEPLOYMENT ############" sentinel.out
            do
                echo "waiting for sentinel deployment"
                sleep 10
            done

EOF
    fi

# Collect the output file 
scp -o StrictHostKeyChecking=no -i $ID_RSA_PRIVATE azureuser@$PROVISIONVM_IP:./openhack-devops-proctor/provision-proctor/sentinel.out ${LOGFILE}
echo "The logs from the deployment of Sentinel are in ${LOGFILE}"

echo "###### Deployment of the monitoring solution completed ######"

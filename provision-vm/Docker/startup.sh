#!/bin/bash

echo "############### Azure credentials ###############"
echo "UserName: $AZUREUSERNAME"
echo "Password: $AZUREPASSWORD"
echo "Subscription ID: $SUBID"
echo "Location: $LOCATION"
echo "Team Name: $TEAMNAME"
echo "Recipient email: $RECIPIENTEMAIL"
echo "ChatConnectionString= $CHATCONNECTIONSTRING"
echo "ChatConnectionQueue= $CHATMESSAGEQUEUE"
echo "Tenant is $TENANTID"
echo "AppId is $APPID"

############### Pulling Openhack-tools from Github ###############
git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
# RUN chown azureuser:azureuser -R /home/azureuser/openhack-devops-proctor/.

##### TODO This line will be removed before the PR merged
cd /home/azureuser/openhack-devops-proctor
cd /home/azureuser

############### Install kvstore ###############
install -b /home/azureuser/openhack-devops-proctor/provision-team/kvstore.sh /usr/local/bin/kvstore
echo 'export KVSTORE_DIR=/home/azureuser/team_env/kvstore' >> /home/azureuser/.bashrc

cd /home/azureuser/openhack-devops-proctor/provision-team

# Running the provisioning of the team environment

if [[ -z "$TENANTID" ]]; then
    az login --username=$AZUREUSERNAME --password=$AZUREPASSWORD
else
    az login --service-principal --username=$AZUREUSERNAME --password=$AZUREPASSWORD --tenant=$TENANTID
fi

# Launching the team provisioning in background
PATH=$PATH:/opt/mssql-tools/bin KVSTORE_DIR=/home/azureuser/team_env/kvstore ./setup.sh -i $SUBID -l $LOCATION -n $TEAMNAME -u "$AZUREUSERNAME" -p "$AZUREPASSWORD" -r "$RECIPIENTEMAIL" -c "$CHATCONNECTIONSTRING" -q "$CHATMESSAGEQUEUE" -t "$TENANTID" -a "$APPID" 2>&1 | tee -a /home/azureuser/logs/teamdeploy.out

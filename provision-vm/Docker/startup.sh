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

cd /home/azureuser/openhack-devops-proctor/provision-team

# Running the provisioning of the team environment

if [[ -z "$TENANTID" ]]; then
    az login --username=$AZUREUSERNAME --password=$AZUREPASSWORD
else
    az login --service-principal --username=$AZUREUSERNAME --password=$AZUREPASSWORD --tenant=$TENANTID
fi 


# Launching the team provisioning in background
PATH=$PATH:/opt/mssql-tools/bin KVSTORE_DIR=/home/azureuser/team_env/kvstore ./setup.sh -i $SUBID -l $LOCATION -n $TEAMNAME -u "$AZUREUSERNAME" -p "$AZUREPASSWORD" -r "$RECIPIENTEMAIL" -c "$CHATCONNECTIONSTRING" -q "$CHATMESSAGEQUEUE" -t "$TENANTID" -a "$APPID"

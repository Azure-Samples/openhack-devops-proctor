
# ********************************************************************
# * Script run by the Custom Script Extension on the provisioning VM *
# ********************************************************************
# Set Azure Credentials by reading the command line arguments

AZUREUSERNAME=$1
AZUREPASSWORD=$2
SUBID=$3
LOCATION=$4
TEAMNAME=$5
RECIPIENTEMAIL=$6
CHATCONNECTIONSTRING=$7
CHATMESSAGEQUEUE=$8
TENANTID=$9
APPID=${10}
#GITBRANCH=

echo "############### Adding package respositories ###############"
# Get the Docker GPG key 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg 2>&1 | sudo apt-key add -

# Add Docker source
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "############### Installing Packages ###############" 

sudo DEBIAN_FRONTEND=noninteractive apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg-agent
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io

#Add user to docker usergroup
sudo usermod -aG docker azureuser

#Holding walinuxagent before upgrade
sudo apt-mark hold walinuxagent
sudo apt-get upgrade -y

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

# Launching the team provisioning in background

export AZUREUSERNAME=$AZUREUSERNAME
export AZUREPASSWORD=$AZUREPASSWORD
export SUBID=$SUBID
export LOCATION=$LOCATION
export TEAMNAME=$TEAMNAME
export RECIPIENTEMAIL=$RECIPIENTEMAIL
export CHATCONNECTIONSTRING=$CHATCONNECTIONSTRING
export CHATMESSAGEQUEUE=$CHATMESSAGEQUEUE
export TENANTID=$TENANTID
export APPID=$APPID

# /bin/bash -c 'docker run -d --name docker-daemon --privileged docker:stable-dind &'
/bin/bash -c 'docker run --mount '"'"'type=bind,src=/home/azureuser,dst=/home/azureuser'"'"' -v /var/run/docker.sock:/var/run/docker.sock -d -e  AZUREUSERNAME -e AZUREPASSWORD -e SUBID -e LOCATION -e TEAMNAME -e RECIPIENTEMAIL -e CHATCONNECTIONSTRING -e CHATMESSAGEQUEUE -e TENANTID -e APPID tsuyoshiushio/proctor-container &'
echo "############### End of custom script ###############"

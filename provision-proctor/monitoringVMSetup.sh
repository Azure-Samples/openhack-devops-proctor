
# ********************************************************************
# * Script run by the Custom Script Extension on the provisioning VM *
# ********************************************************************
# Set Azure Credentials by reading the command line arguments

AZUREUSERNAME=$1
AZUREPASSWORD=$2
SUBID=$3
LOCATION=$4
#GITBRANCH=$(git branch | grep \* | cut -d ' ' -f2)

echo "############### Adding package respositories ###############"
# Get the Microsoft signing key 
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Get the Docker GPG key 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893

# Azure-cli
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ xenial main"
# Dotnet SDK v2.1
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main"
# Add MSSQL source 
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main"
# Add Docker source
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"

echo "############### Installing Helm v2.10.0 ###############"
sudo curl -O https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.10.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

echo "############### Installing kubectl ###############"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "############### Installing Packages ###############" 
#  - apt-transport-https
#  - jq
#  - git
#  - zip
#  - azure-cli=2.0.31-1~xenial
#  - mssql-tools
#  - unixodbc-dev
#  - dotnet-sdk-2.1.4
#  - powershell 
#  - docker-ce

sudo DEBIAN_FRONTEND=noninteractive apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y jq git zip azure-cli=2.0.43-1~xenial
sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce

touch /home/azureuser/.bashrc
echo 'export PATH=$PATH:/opt/mssql-tools/bin' >> /home/azureuser/.bashrc

echo "############### Pulling Openhack-tools from Github ###############"
sudo git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
sudo chown azureuser:azureuser -R /home/azureuser/openhack-devops-proctor/.

echo "############### Install kvstore ###############"
sudo install -b /home/azureuser/openhack-devops-proctor/provision-team/kvstore.sh /usr/local/bin/kvstore
echo 'export KVSTORE_DIR=/home/azureuser/team_env/kvstore' >> /home/azureuser/.bashrc

#pick up changes to bash profile
#source /home/azureuser/.bashrc

echo azure-cli hold | sudo dpkg --set-selections

#Add user to docker usergroup
sudo usermod -aG docker azureuser
sudo apt-get upgrade -y

#Set environement variables
export PATH=$PATH:/opt/mssql-tools/bin
export KVSTORE_DIR=/home/azureuser/team_env/kvstore

cd /home/azureuser/openhack-devops-proctor/provision-proctor

echo "############### Azure credentials ###############"
echo "UserName: $AZUREUSERNAME"
echo "Password: $AZUREPASSWORD"
echo "Subscription ID: $SUBID"
echo "Location: $LOCATION"

# Running the provisioning of the team environment
az login --username=$AZUREUSERNAME --password=$AZUREPASSWORD

# Launching the team provisioning in background
sudo PATH=$PATH:/opt/mssql-tools/bin KVSTORE_DIR=/home/azureuser/team_env/kvstore nohup ./setup.sh -i $SUBID -l $LOCATION -u '$AZUREUSERNAME' -p '$AZUREPASSWORD'>monitoringeploy.out &

echo "############### End of custom script ###############"

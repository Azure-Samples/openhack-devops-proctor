echo "############### Installing Azure CLI v2.0.31 ###############"
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
     sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y azure-cli=2.0.31-1~xenial

echo "############### Installing Helm v2.9.1 ###############"
sudo curl -O https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.9.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

echo "############### Installing kubectl ###############"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.7/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "############### Installing Dotnet SDK v2.1.4 ###############"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-sdk-2.1.4

echo "############### Installing Jq ###############"
sudo apt-get install -y jq

echo "############### Installing Git ###############"
sudo apt-get install -y git

echo "############### Installing SQL cmd line tools ###############"
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt-get install -y mssql-tools unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

#pick up changes to bash profile
source ~/.bashrc

echo "############### Pulling Openhack-tools from Github ###############"
sudo git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
sudo chown azureuser -R ./openhack-devops-proctor

echo "############### Install Powershell Core and AzureRM modules "###############
# https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1604

# Can likely remove because same steps as SQL cmd line tools
# Import the public repository GPG keys
# curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Register the Microsoft Ubuntu repository
# sudo curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
# Update the list of products
# sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell
# Start PowerShell and install AzureRm modules
# https://docs.microsoft.com/en-us/powershell/azure/install-azurermps-maclinux?view=azurermps-6.0.0
sudo pwsh

#Change trust policy on powershell gallery to Trusted for unattended install
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

#Install AzureRM Modules
Install-Module AzureRM.NetCore
Import-Module AzureRM.Netcore
Import-Module AzureRM.Profile.Netcore
# Exit out of pwsh so bash can complete
exit


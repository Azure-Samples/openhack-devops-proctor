# echo "############### Installing Azure CLI v2.0.43 ###############"
# AZ_REPO=$(lsb_release -cs)
# echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#      sudo tee /etc/apt/sources.list.d/azure-cli.list
# sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
# sudo apt-get install -y apt-transport-https
# sudo apt-get update

echo "############### Installing Helm v2.9.1 ###############"
sudo curl -O https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.9.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

echo "############### Installing kubectl ###############"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.5/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# echo "############### Installing Dotnet SDK v2.1 ###############"
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

# sudo apt-get update
# sudo apt-get install -y dotnet-sdk-2.1

# echo "############### Installing Jq ###############"
# sudo apt-get install -y jq

# echo "############### Installing Git ###############"
# sudo apt-get install -y git

# echo "############### Installing zip ###############"
# sudo apt-get install -y zip

# whoami > ~/output.txt

# echo "############### Installing SQL cmd line tools ###############"
# curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
# sudo apt-get update
# sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
touch /home/azureuser/.bashrc
echo 'export PATH=$PATH:/opt/mssql-tools/bin' >> /home/azureuser/.bashrc

echo "############### Pulling Openhack-tools from Github ###############"
sudo git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
sudo chown azureuser:azureuser -R /home/azureuser/openhack-devops-proctor/.

echo "############### Install kvstore ###############"
sudo install -b /home/azureuser/openhack-devops-proctor/provision-team/kvstore.sh /usr/local/bin/kvstore
echo 'export KVSTORE_DIR=/home/azureuser/team_env/kvstore' >> /home/azureuser/.bashrc

#pick up changes to bash profile
# source /home/azureuser/.bashrc

# echo "############### Install Powershell Core and AzureRM modules ###############"
# # https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1604
# # Install PowerShell
# sudo apt-get install -y powershell
# # Start PowerShell and install AzureRm modules
# # https://docs.microsoft.com/en-us/powershell/azure/install-azurermps-maclinux?view=azurermps-6.0.0

# # #Change trust policy on powershell gallery to Trusted for unattended install
# sudo pwsh -command "& {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}"

# # Install AzureRM Modules
# sudo pwsh -command "& {Install-Module AzureRM.NetCore}"
# sudo pwsh -command "& {Import-Module AzureRM.Netcore}"
# sudo pwsh -command "& {Import-Module AzureRM.Profile.Netcore}"


# Installing this at the end because for some reason it doesn't take effect when immediately after the AZ setup
# sudo apt-get install -y azure-cli=2.0.43-1~xenial

# echo azure-cli hold | sudo dpkg --set-selection

# sudo apt-get upgrade -y


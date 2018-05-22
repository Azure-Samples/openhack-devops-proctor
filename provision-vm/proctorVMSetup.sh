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
sudo apt-get install mssql-tools unixodbc-dev
sudo apt-get update
sudo apt-get install mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

echo "############### Pulling Openhack-tools from Github ###############"
sudo git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor

#pick up changes to bash profile
source ~/.bashrc
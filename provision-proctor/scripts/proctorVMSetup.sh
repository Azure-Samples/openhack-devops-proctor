echo "######################### VERSION 1.1 ########################"
echo "######################### AZURE CLI ########################"
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
     sudo tee /etc/apt/sources.list.d/azure-cli.list
apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
apt-get install apt-transport-https -y
apt-get update 
sudo apt-get install azure-cli -y

echo "##################### DOTNET CORE ########################"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

apt-get update

apt-get install dotnet-sdk-2.1.4 -y

echo "####################### HELM ################################"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

echo "############################## JQ ############################"
apt-get install jq -y

echo "############################## PULL TEAM-CLI FROM GITHUB ##############################"
git clone https://github.com/Azure-Samples/openhack-team-cli.git

echo "############################## PULL OPENHACK-TOOLS FROM GITHUB ##############################"
git clone https://github.com/Azure-Samples/openhack-devops-tools.git



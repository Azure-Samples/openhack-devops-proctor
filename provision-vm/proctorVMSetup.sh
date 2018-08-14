#/bin/bash

touch /home/azureuser/.bashrc
echo 'export PATH=$PATH:/opt/mssql-tools/bin' >> /home/azureuser/.bashrc

echo "############### Pulling Openhack-tools from Github ###############"
sudo git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
sudo chown azureuser:azureuser -R /home/azureuser/openhack-devops-proctor/.

echo "############### Install kvstore ###############"
sudo install -b /home/azureuser/openhack-devops-proctor/provision-team/kvstore.sh /usr/local/bin/kvstore
echo 'export KVSTORE_DIR=/home/azureuser/team_env/kvstore' >> /home/azureuser/.bashrc



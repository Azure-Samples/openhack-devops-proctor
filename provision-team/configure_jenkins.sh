#!/bin/bash

JENKINSPASSWORD=$1

# Docker
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce -y

# Azure CLI
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli

# Kubectl
az aks install-cli

# Helm v2.9.1
sudo curl -O https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.9.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# Clone repo
sudo git clone https://github.com/OguzPastirmaci/openhack-jenkins-docker.git /home/jenkins/openhack-jenkins-docker
sudo chown jenkins:jenkins -R /home/jenkins/openhack-jenkins-docker/.

# Configure access for Docker
usermod -aG docker jenkins

# Delete if Jenkins mount exists
sudo rm -rf /var/lib/docker/volumes/jenkins_home/

# Enable Docker Remote API
sudo sed -i -e 's/ExecStart.*/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ -H tcp:\/\/0.0.0.0:4243/g' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker

cd /home/jenkins/openhack-jenkins-docker

# Change Jenkins password
sudo sed -i "s/jenkinspassword/${JENKINSPASSWORD}/g" Dockerfile

# Build image
sudo docker build . -t openhack-jenkins-local

# Run Jenkins
sudo docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 openhack-jenkins-local
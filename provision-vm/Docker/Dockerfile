From ubuntu:16.04

############### Adding package respositories ###############
ENV home /home/azureuser
RUN mkdir -p ${home}
WORKDIR ${home}

RUN apt-get update
RUN apt-get install -y gnupg
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  apt-utils curl
RUN apt-get install software-properties-common -y

# Get the Microsoft signing key 
RUN curl -L https://packages.microsoft.com/keys/microsoft.asc 2>&1 | apt-key add -

# Get the Docker GPG key 
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg 2>&1 | apt-key add -
# sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893

# Azure-cli
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ xenial main"
# Dotnet SDK v2.1
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main"
# Add MSSQL source 
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main"
# Add Docker source
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"

############### Installing Helm v2.12.2 ###############
RUN curl -s -O https://storage.googleapis.com/kubernetes-helm/helm-v2.12.2-linux-amd64.tar.gz
RUN tar -zxvf helm-v2.12.2-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm

############### Installing kubectl ###############
RUN curl -s -LO https://storage.googleapis.com/kubernetes-release/release/v1.11.7/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

############### Installing Packages ###############

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https
RUN DEBIAN_FRONTEND=noninteractive apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y dotnet-sdk-2.2 jq git zip azure-cli=2.0.49-1~xenial
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce

############### Locale Settings ###############

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN touch /home/azureuser/.bashrc
RUN echo 'export PATH=$PATH:/opt/mssql-tools/bin' >> /home/azureuser/.bashrc

############### Pulling Openhack-tools from Github ###############
RUN git clone https://github.com/Azure-Samples/openhack-devops-proctor.git /home/azureuser/openhack-devops-proctor
# RUN chown azureuser:azureuser -R /home/azureuser/openhack-devops-proctor/.

##### TODO This line will be removed before the PR merged 
WORKDIR /home/azureuser/openhack-devops-proctor
RUN git checkout -b refactor/provisionvm origin/refactor/nginx
WORKDIR ${home}

############### Install kvstore ###############
RUN install -b /home/azureuser/openhack-devops-proctor/provision-team/kvstore.sh /usr/local/bin/kvstore
RUN echo 'export KVSTORE_DIR=/home/azureuser/team_env/kvstore' >> /home/azureuser/.bashrc

RUN echo azure-cli hold | dpkg --set-selections

#Add user to docker usergroup
RUN usermod -aG docker root

#Holding walinuxagent before upgrade
RUN apt-mark hold walinuxagent
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

#Set environement variables
ENV PATH $PATH:/opt/mssql-tools/bin
ENV KVSTORE_DIR /home/azureuser/team_env/kvstore
#ENV DOCKER_HOST tcp://docker:2375

#Create nginx directory
RUN mkdir -p /home/nginx/config
RUN mkdir -p /home/nginx/contents

COPY startup.sh .
RUN chmod +x /home/azureuser/startup.sh
CMD ["/bin/bash", "-c", "/home/azureuser/startup.sh"]



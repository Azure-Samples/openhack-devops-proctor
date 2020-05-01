# SQL Server Command Line Tools
FROM ubuntu:16.04
LABEL maintainer="Opsgility"

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# install dig (dnstools)
RUN apt-get update && apt-get -y install dnsutils

# install git
RUN apt-get update && apt-get -y install git

# install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

COPY deploy.sh /deploy/
COPY azuredeploy.json /deploy/
COPY jenkins/* /deploy/jenkins/

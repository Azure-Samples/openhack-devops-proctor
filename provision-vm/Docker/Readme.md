# Docker support for provision vm

We are migrating the provision environment from Ubuntu VM to a doocker container.
It helps us to solve these problem. Currently, experimental.

* Deployment fails because of the upgrade of the apt packages. 
* We can deploy only from Ubuntu environment. 

# Get Started

For getting started, create a docker daemon using the docker image. For experimental purpose, 
Currently only support manual deployment for testing.

```
$ docker run -d --name some-docker --privileged docker:stable-dind
$ docker run --link some-docker:docker -it proctorvm /bin/bash
root@531ed021c2c5:/home/azureuser# export DOCKER_HOST='tcp://docker:2375'
root@531ed021c2c5:/home/azureuser# export AZUREUSERNAME=YOUR_SERVICE_PRINICPAL_NAME
root@531ed021c2c5:/home/azureuser# export AZUREPASSWORD=YOUR_SERVICE_PRINICPAL_PASSWORD
root@531ed021c2c5:/home/azureuser# export SUBID=YOUR_SUBSCRIPTION_ID
root@531ed021c2c5:/home/azureuser# export LOCATION=westus2
root@531ed021c2c5:/home/azureuser# export TEAMNAME=YOUR_TEAM_NAME (e.g. ushioh)
root@531ed021c2c5:/home/azureuser# export RECIPIENTEMAIL=YOUR_E_MAIL
root@531ed021c2c5:/home/azureuser# export CHATCONNECTIONSTRING=null 
root@531ed021c2c5:/home/azureuser# export CHATMESSAGEQUEUE=null
root@531ed021c2c5:/home/azureuser# export TENANTID=YOUR_TENANT_ID
root@531ed021c2c5:/home/azureuser# export APPID=YOUR_SERVICE_PRINICPAL_APP_ID
root@531ed021c2c5:/home/azureuser# chmod +x ./startup.sh
root@531ed021c2c5:/home/azureuser# ./start.sh
```

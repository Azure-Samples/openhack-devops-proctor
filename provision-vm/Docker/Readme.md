# Testing Dockerfile

# Local development

In case of you want to test it on your local machine, if you already have linux(includes WSL), Mac,
You can test it localy. 

# Get Started

For getting started, create a docker daemon using the docker image. For experimental purpose, 
Currently only support manual deployment for testing.

```
$ docker run --link some-docker:docker -it proctorvm /bin/bash
$ export AZUREUSERNAME=YOUR_SERVICE_PRINICPAL_NAME
$ export AZUREPASSWORD=YOUR_SERVICE_PRINICPAL_PASSWORD
$ export SUBID=YOUR_SUBSCRIPTION_ID
$ export LOCATION=westus2
$ export TEAMNAME=YOUR_TEAM_NAME (e.g. ushioh)
$ export RECIPIENTEMAIL=YOUR_E_MAIL
$ export CHATCONNECTIONSTRING=null 
$ export CHATMESSAGEQUEUE=null
$ export TENANTID=YOUR_TENANT_ID
$ export APPID=YOUR_SERVICE_PRINICPAL_APP_ID

$ docker run --privileged --name some-docker -d docker:stable-dind
$ docker build -t some .
$ cd YOUR_PREFERED_DIRECTORY
$ mkdir -p config
$ mkdir -p contents
$ mkdir -p logs
$ docker run --mount "type=bind,src=$(pwd)/config,dst=/home/nginx/config" --mount "type=bind,src=$(pwd)/contents,dst=/home/nginx/contents" --mount "type=bind,src=$(pwd)/logs,dst=/home/azureuser/logs" --link some-docker:docker -d -e AZUREUSERNAME -e AZUREPASSWORD -e SUBID -e LOCATION -e TEAMNAME -e RECIPIENTEMAIL -e CHATCONNECTIONSTRING -e CHATMESSAGEQUEUE -e TENANTID -e APPID -e "DOCKER_HOST=tcp://docker:2375" some
```

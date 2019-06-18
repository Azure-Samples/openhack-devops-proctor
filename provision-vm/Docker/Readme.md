# Docker support for provision vm

We have migrated the provision environment from Ubuntu VM to a docker container.

# Get Started

For getting started, create a docker daemon using the docker image. For experimental purpose,
If you want to run the container locally:

```
$ docker run -v /home/nginx/config:/home/nginx/config -v /home/nginx/contents:/home/nginx/contents -v /home/azureuser/logs:/home/azureuser/logs -v /var/run/docker.sock:/var/run/docker.sock -d -e  AZUREUSERNAME -e AZUREPASSWORD -e SUBID -e LOCATION -e TEAMNAME -e RECIPIENTEMAIL -e CHATCONNECTIONSTRING -e CHATMESSAGEQUEUE -e TENANTID -e APPID -e GITBRANCH devopsoh/proctor-container
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
root@531ed021c2c5:/home/azureuser# export GITBRANCH=master
root@531ed021c2c5:/home/azureuser# chmod +x ./startup.sh
root@531ed021c2c5:/home/azureuser# ./startup.sh
```

# Infrastructure deployment scripts

This is the guide to deploy the environment used by the monitoring solution of the OpenHack.
It may also be referenced sometimes as the proctor environment.

Identify a specific subscription to deploy the monitoing environment before your launch this deployment. 

## Usage

1. Deploy the provisioning VM for the monitoring environment using the following ARM Template or the button below.

2. Provision all the team envrionments.

3. <TO BE COMPLETED> Collect the kvstore files from the VM provisioning the teams. 

4. SSH to the VM using the private key provided in the DevOps OpenHack documentation or reset the public key on this VM.

5. From the directory `/home/azureuser/openhack-devops-proctor/provision-procotor  ` Run the deployment script [./setup.sh](./setup.sh) on the provisioning VM using the following command line: 

```
nohup ./setup.sh -i <subscriptionId> -l <resourceGroupLocation> -m <proctorName> -u <proctorNumber> -n <teamName> -e <totalTeams> > <proctorName><proctorNumber>.out &
```

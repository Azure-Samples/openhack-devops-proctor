# Infrastructure monitoring deployment scripts

This is the guide to deploy the environment used by the monitoring solution of the DevOps OpenHack.
It may also be referenced sometimes as the proctor environment.

Identify and reserve a specific subscription in your classroom to deploy the monitoring environment before you launch this deployment. It is recommended to use the last one.

## Usage

1. Identify the VM named "proctorVM" in the subscription that you have selected and update its ssh key pair with your own. Instructions how to do so are here: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/vmaccess#update-ssh-key 

2. SSH to the VM with the `azureuser` account and navigate to `/home/azureuser/openhack-devops-proctor/provision-proctor`

3. Run the following command `nohup ./setup.sh -i <subscriptionId> -l <location> -u <azureUserName> -p '<azurePassword>' > monitoringdeploy.out &`

### **Wait for the script to complete - It will take about 30 min**

4. The last line of the `monitoringdeploy.out` file should have this line "############ END OF MONITORING PROVISION ############"

5. From the classroom manager portal, download the CSV file with the azure credentials of the attendees subscriptions and upload it to the "proctorVM". You can use the following command:

`scp -o StrictHostKeyChecking=no -i ~/.ssh/openhack_rsa [local_path]/credentials.csv azureuser@<IP_ADDRESS>:~/openhack-devops-proctor/provision-proctor/credentials.csv`

6. Identify the _proctorEnvironmentName_. It is the first 18 characters of the monitoring resource group. For example if the monitoring resource group is named _monitoring2qy26600rg_ the proctorEnvironmentName is _monitoring2qy26600_.

7. Provision the monitoring agent _Sentinel_ using the following command: `bash ./deploy_sentinel.sh -p <proctorEnvironmentName> -f credentials.csv -k ~/.kube/config > deploysentinel.log`

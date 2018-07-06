# Infrastructure deployment scripts

## Usage

### Provisioning Scripts

ssh to the proctor VM then login with az command.

#### Login with Azure CLI

```shell
az login
```
#### Deploy proctor environment

**NOTE:** Until now, we need to edit `leaderboard/api/CLI/team_service_config.json` before deploy the proctor enviornment.
Unless it, you'll get `Report Status error: Object reference not set to an instance of an object` error. 


```shell
nohup setup.sh -i <subscriptionId> -l <resourceGroupLocation> -m <proctorName> -u <proctorNumber> -n <teamName> -e <totalTeams> > <proctorName><proctorNumber>.out &"
```

# Infrastructure deployment scripts

## Provisioning Scripts Usage

ssh to the proctor VM then login with az command.

### Login with Azure CLI

```shell
az login
```

### Deploy proctor environment

```shell
nohup ./setup.sh -i <subscriptionId> -l <resourceGroupLocation> -m <proctorName> -u <proctorNumber> -n <teamName> -e <totalTeams> > <proctorName><proctorNumber>.out &
```

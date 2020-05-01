# DevOps OpenHack Deployment

To initiate a deployment, download both the ARM template (`azuredeploy.json`), the bash script (`deploy.sh`), and the `jenkins/` folder to the same directory in a bash shell.

You can download these manually or using `git clone`. For example:

```sh
git clone https://github.com/Azure-Samples/openhack-devops-proctor.git
```

> **Note:** [Azure Cloud Shell](https://docs.microsoft.com/azure/cloud-shell/overview) will be the easiest to use as it has all of the required tooling (az/sqlcmd/bcp/dig/etc.) installed already.

## Execute Deployment

***You must be logged in to Azure already using `az login`. The deployment script as shown in the example will not perform a login for you.***

To execute a deployment, you can run deploy.sh with a single parameter (`-l` for location). *e.g.* To deploy into `eastus`:

```sh
bash deploy.sh -l eastus
```

> **Note:** Some Azure services are not available in all locations. A list of known locations will need to be built out over time.

### Optional container-based deployment

An optional container deployment is available if you wish to create your environment by supplying a username and password to the deployment script.

> **Note:** This method does not support MFA-enabled logins. Please clone the repository and use the deployment script manually after executing `az login`.

1. To execute a container deployment, build a container using the [Dockerfile](Dockerfile) located in the [provision-team](/provision-team/) directory.

    ```sh
    docker build -f Dockerfile . -t devopsohdeploy:latest
    ```

2. Run the container, replacing the tokens `<AZURE_USERNAME>` and `<AZURE_PASSWORD>` with a username and password that have the required permissions.

    ```sh
    docker run -i -t devopsohdeploy:latest /bin/bash -c "export PATH="$PATH:/opt/mssql-tools/bin" && cd /deploy && bash deploy.sh -l eastus -u '<AZURE_USERNAME>' -p '<AZURE_PASSWORD>'"
    ```

## Requirements

### Software requirements

The current deployment stack requires the following tooling and versions:

- Azure CLI v2.3.0 (or higher) ([Installation instructions](https://docs.microsoft.com/cli/azure/install-azure-cli))
- sqlcmd v17.5.0001.2 Linux (or higher) ([Installaton instructions](https://docs.microsoft.com/sql/linux/sql-server-linux-setup-tools))
    - bcp
- dig v9.10.3 (or higher)
- git

### Azure permissions

- You must be a Contributor or an Owner on the subscription where you would like to deploy.

    > **Note**: If you are using a custom role, you must have `write` permissions to create all the resources required for this OpenHack.

### Azure resource requirements

| Azure resource           | Pricing tier/SKU       | Purpose                                 |
| ------------------------ | ---------------------- | --------------------------------------- |
| Azure SQL Database       | Standard S3: 100 DTUs  | mydrivingDB                             |
| Azure Container Registry | Basic                  | Private container registry              |
| Azure Container Instance | 1 CPU core/1.5 GiB RAM | Jenkins container                       |
| Azure Key Vault          | Standard               | Key vault for database secrets          |
| App Service Plan         | Standard S2            | App Service Plan for all Azure Web Apps |
| Azure Container Instance | 1 CPU core/1.5 GiB RAM | Simulator                               |

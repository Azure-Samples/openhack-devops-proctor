# DevOps OpenHack Deployment

To initiate a deployment, download both the ARM template (`azuredeploy.json`) and the bash script (`deploy.sh`) to the same directory in a bash shell.

> Note: [Azure Cloud Shell](https://docs.microsoft.com/azure/cloud-shell/overview) will be the easiest to use as it has all of the required tooling (az/sqlcmd/bcp/dig/etc.) installed already.

## Execute Deployment

To execute a deployment, you can run deploy.sh with a single parameter (`-l` for location). *e.g.* To deploy into `eastus`:

```sh
bash deploy.sh -l eastus
```

> Note: Some Azure services are not available in all locations. A list of known locations will need to be built out over time.

## Requirements

### Software requirements

The current deployment stack requires the following tooling and versions:

- Azure CLI v2.3.0 (or higher) ([Installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- sqlcmd v17.5.0001.2 Linux (or higher) ([Installaton instructions](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools))
    - bcp
- dig v9.10.3 (or higher)

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

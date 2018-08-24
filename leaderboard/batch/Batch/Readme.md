# Leaderboard batch 

This batch execute three sql commands per one minutes. 

Build by Azure Functions. You can run locally with Visual Studio or Yo can run as container include kubernetes. 

# Configuration 

These environment variables are required.  

* `SqlConnectionString` : Connection String of SQL database
* `AzureWebJobsStorage` : Connection String of Azure Storage Account 

# Run locally

If you want to try to run locally for debugging, please configure `local.settings.json`. You can refer the `local.settings.json.example` as an example. 

# Build docker file 

If you want to pack into a container 

```
docker build . -t YOUR_IMAGE_NAME
```



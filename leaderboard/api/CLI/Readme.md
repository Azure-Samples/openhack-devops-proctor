# Openhack Database Seed CLI

This CLI is a tool for seeding initial data for CosmosDB. Also It includes some feature for seeding sample data.

# Usage

Configure several configration file and execute this CLI via Visual Studio. Eventually I make it executable. 

# Configuration


## appsettings.json

Set the CosmosDB configuration to the appsettings.json

You can copy it from appsettings.json.example. Also it define the number of the challenges.

```
{
  "EndpointUri": "YOUR_COSMOS_DB_ENDPOINT_HERE",
  "PrimaryKey": "YOUR_COSMOS_DB_PRIMARY_KEY_HERE",
  "DatabaseId": "leaderboard",
  "NumberOfChallenges": "3"
}
```

## openhack.json

Configure the starttime and endtime of your Openhack. The format is like this. 

```
{
  "StartTime": "2018-09-10T08:00:00",
  "EndTime": "2018-09-12T17:00:00"
}
```

## service.json

Configure the service.json. It is the same format as sample.json which is used 
for generating value.yaml of the sentinel helm chart. 

```
{
  "team01": {
    "endpoint": "https://sarmopenhack2.azurewebsites.net/api/team01/health"
  },
  "team02": {
    "endpoint": "https://sarmopenhack2.azurewebsites.net/api/team01/health"
  }
}
```

# Seed

After the configuration hit F5 and execute this app. Then you can find the all collections are 
configured with some intinal data. 

For the collection definition, you can refer `SharedLibrary/Models.cs` code. 


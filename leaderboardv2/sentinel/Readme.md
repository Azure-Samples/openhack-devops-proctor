# Sentinel 

Sentinel is the Status checking tools for the DevOps OpenHack. 

# Usage 

## Build Docker Image

```
docker build . -t  sentinel 
```

### Run 

You need to pass Environment variables 

```
docker run -e "key=value" sentinel
```

Required Environment Variables is here. You need to set required Environment Variables at least. 


```
	Endpoint      string `env:"SENTINEL_ENDPOINT,required"`
	PORT          int    `env:"SENTINEL_PORT" envDefault:"80"`
	TeamID        string `env:"SENTINEL_TEAM_ID,required"`
	ServiceType   string `env:"SENTINEL_SERVICE_TYPE,required"`
	APIURL        string `env:"SENTINEL_API_URL,required"`
	Interval      int    `env:"SENTINEL_POLLING_INTERVAL" envDefault:"1"`
	RetryDuration int    `env:"SENTINEL_RETRY_DURATION" envDefault:"1000"`
```

for example 

```
SENTINEL_ENDPOINT="http://bing.com" 
SENTINEL_PORT="80" 
SENTINEL_TEAM_ID="devteam" 
SENTINEL_SERVICE_TYPE="poi" 
SENTINEL_API_URL="https://changeme.azurewebsites.net" 
SENTINEL_POLLING_INTERVAL="5" 
SENTINEL_RETRY_DURATION="1000"
```

For more detail, please refer [Azure Cosmos DB: Build a MongoDB API console app with Golang and the Azure portal](https://docs.microsoft.com/ja-jp/azure/cosmos-db/create-mongodb-golang)

# Development

This repo requires these tools.

* [golang](https://golang.org/)
* [golang/dep](https://github.com/golang/dep)


# Restore Packages

After setting the GOPATH, then you can try

```
dep ensure
```

# Build

```
go build
```

# Run

```
go run main.go
```

or

```
./sentinel.exe
```



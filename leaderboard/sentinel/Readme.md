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
	TeamID        string `env:"SENTINEL_TEAM_ID, required"`
	ServiceID     string `env:"SENTINEL_SERVICE_ID,required"`
	Addrs         string `env:"SENTINEL_MONGO_ADDRESS,required"`
	Database      string `env:"SENTINEL_MONGO_DATABASE" envDefault:"sentineldb"`
	Username      string `env:"SENTINEL_MONGO_USERNAME,required"`
	Password      string `env:"SENTINEL_MONGO_PASSWORD,required"`
	Collection    string `env:"SENTINEL_MONGO_COLLECTION_NAME" envDefault:"collection"`
	Interval      int    `env:"SENTINEL_POLLING_INTERVAL" envDefault:"1"`
	RetryDuration int    `env:"SENTINEL_RETRY_DURATION" envDefault:"1000"`
```

for example 

```
SENTINEL_ENDPOINT=https://www.some.com/health
SENTINEL_TEAM_ID=1
SENTINEL_SERVICE_ID=1
SENTINEL_MONGO_ADDRESS=golang-couch.documents.azure.com:10255
SENTINEL_MONGO_USERNAME=username
SENTINEL_MONGO_PASSWORD="Azure database connect password from Azure Portal"
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



package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/caarlos0/env"
)

////////////////////////////
// Service Type Enum (values set in ./helm/templates/deployment.yaml)
// 1 = poi
// 2 = user
// 3 = trips
// 4 = user-java
////////////////////////////

type config struct {
	Endpoint      string `env:"SENTINEL_ENDPOINT,required"`
	PORT          int    `env:"SENTINEL_PORT" envDefault:"80"`
	TeamName      string `env:"SENTINEL_TEAM_NAME,required"`
	ServiceType   string `env:"SENTINEL_SERVICE_TYPE,required"`
	APIURL        string `env:"SENTINEL_API_URL,required"`
	Interval      int    `env:"SENTINEL_POLLING_INTERVAL" envDefault:"1"`
	RetryDuration int    `env:"SENTINEL_RETRY_DURATION" envDefault:"1000"`
	Debug         bool   `env:"SENTINEL_DEBUG" envDefault:"false"`
}

type logmsg struct {
	TeamName    string    //Name of Team
	Type        string    // Service Type
	CreatedDate time.Time // UTC DateTime
	StatusCode  int       // Returned Status Code (0 if no response)
	EndpointURI string    // Monitored Endpoint URI
}

func main() {
	// Get environment variables and validate them
	fmt.Println("Sentinel Initializing...")
	cfg := config{}
	err := env.Parse(&cfg)
	if err != nil {
		fmt.Println("Error parsing configuration.")
		fmt.Printf("%+v\n", err)
		return
	}

	fmt.Println(fmt.Sprintf("Sentinel - Monitoring endpoint %s", cfg.Endpoint))

	ticker := time.NewTicker(time.Duration(cfg.Interval) * time.Second)
	for t := range ticker.C {
		fmt.Println("Tick ...", t)
		statusCode, err := pingHealthCheck(&cfg)
		if err != nil {
			fmt.Printf("HealthCheck Error - Check your configuration: %v \n", err)
			statusCode = 0 // If they don't have a proper response, the statusCode becomes 0.
		}
		if cfg.Debug { // In Debug Print all ping status
			fmt.Println(fmt.Sprintf("Server: %s Status: %d", cfg.Endpoint, statusCode))
		}

		currentTime := time.Now()
		currentTimeRound := currentTime.Round(time.Duration(time.Second)) //round time to nearest second
		logmsg := &logmsg{
			TeamName:    cfg.TeamName,
			Type:        cfg.ServiceType,
			CreatedDate: currentTimeRound,
			StatusCode:  statusCode,
			EndpointURI: cfg.Endpoint,
		}

		// Monitored Endpoint is down
		if statusCode != 200 {
			res, err := logHealthcheckFailed(&cfg, logmsg)
			if err != nil {
				//error logging message to sentinel api
				logFailureToPostToSentinel(&cfg, err, res, logmsg)
			}
			fmt.Println(
				fmt.Sprintf("%s down! ping retry in %d ms",
					cfg.Endpoint,
					time.Duration(cfg.RetryDuration)*time.Millisecond))
			time.Sleep(time.Duration(cfg.RetryDuration) * time.Millisecond)
		}
	}

	fmt.Println("Exiting...")
}

func logFailureToPostToSentinel(cfg *config, err error, res *http.Response, logmsg *logmsg) {
	logJSON, err := json.Marshal(*logmsg)
	if err != nil {
		fmt.Println(fmt.Sprintf("Log marshal error: %s", err.Error()))
		return
	}
	body, parseErr := getBody(res)
	if parseErr != nil {
		body = "unavailable"
	}
	if cfg.Debug {
		fmt.Println(fmt.Sprintf("Log healthcheck to Sentinel failed for endpoint: %s \nErrorMessage: %s \nRemoteStatusCode: %d \nRemoteMessage: %s \nSentMessage: %s",
			cfg.APIURL, err.Error(), res.StatusCode, body, logJSON))
	} else {
		fmt.Println(fmt.Sprintf("Log healthcheck to Sentinel failed for endpoint: %s \nErrorMessage: %s \nRemoteStatusCode: %d",
			cfg.APIURL, err.Error(), res.StatusCode))
	}
}

func getBody(resp *http.Response) (string, error) {
	if resp.Body != nil {
		defer resp.Body.Close()
		body, err := ioutil.ReadAll(resp.Body)
		return string(body), err
	}
	// In case of 404, the body doesn't exist.
	return "", nil
}

func logHealthcheckFailed(cfg *config, logmsg *logmsg) (*http.Response, error) {
	reportJSON, err := json.Marshal(*logmsg)
	if err != nil {
		return nil, err
	}

	res, err := http.Post((*cfg).APIURL, "application/json", bytes.NewReader(reportJSON))
	return res, err
}

func pingHealthCheck(cfg *config) (int, error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", (*cfg).Endpoint, nil)
	req.Header.Set("Accept", "*/*")
	res, err := client.Do(req)
	if res != nil {
		return res.StatusCode, err
	}
	return 0, err
}

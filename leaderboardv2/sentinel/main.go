package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	"github.com/caarlos0/env"
)

type config struct {
	Endpoint      string `env:"SENTINEL_ENDPOINT,required"`
	PORT          int    `env:"SENTINEL_PORT" envDefault:"80"`
	TeamID        string `env:"SENTINEL_TEAM_ID,required"`
	ServiceType   string `env:"SENTINEL_SERVICE_TYPE,required"`
	APIURL        string `env:"SENTINEL_API_URL,required"`
	Interval      int    `env:"SENTINEL_POLLING_INTERVAL" envDefault:"1"`
	RetryDuration int    `env:"SENTINEL_RETRY_DURATION" envDefault:"1000"`
}

type logmsg struct {
	TeamID      string
	ServiceType string
	CreatedDate time.Time
	StatusCode  int
	Status      bool
}

func main() {
	// Get environment variables and validate it
	fmt.Println("Sentinel - Monitor an endpoint status for Openhack - DevOps")
	fmt.Println("\nStarting...")
	cfg := config{}
	err := env.Parse(&cfg)
	if err != nil {
		fmt.Println("Initialize Error")
		fmt.Printf("%+v\n", err)
		return
	}

	lastStatus := false
	ticker := time.NewTicker(time.Duration(cfg.Interval) * time.Second)
	for t := range ticker.C {
		fmt.Println("Tick ...", t)
		statusCode, err := healthCheck(&cfg)
		if err != nil {
			panic(err)
		}
		fmt.Println(fmt.Sprintf("Server: %s Status: %d", cfg.Endpoint, statusCode))
		currentTime := time.Now()
		currentTimeRound := currentTime.Round(time.Duration(time.Second))
		logmsg := &logmsg{
			TeamID:      cfg.TeamID,
			ServiceType: cfg.ServiceType,
			CreatedDate: currentTimeRound,
			StatusCode:  statusCode,
		}

		// Endpoint is dead
		if statusCode != 200 {
			logmsg.Status = false
			res, err := report(&cfg, logmsg)
			if err != nil {
				printAPIErrorMessage(&cfg, err, res, logmsg)
			}
			fmt.Println("Dead! wait for recovery for 1000 ms")
			time.Sleep(time.Duration(cfg.RetryDuration) * time.Millisecond)
			lastStatus = false
		} else {
			if !lastStatus {
				logmsg.Status = true
				res, err := report(&cfg, logmsg)
				if err != nil {
					printAPIErrorMessage(&cfg, err, res, logmsg)
				}
			}
			lastStatus = true
		}
	}

	fmt.Println("Hello")
}

func printAPIErrorMessage(cfg *config, err error, res *http.Response, logmsg *logmsg) {
	logJSON, err := json.Marshal(*logmsg)
	if err != nil {
		fmt.Println(fmt.Sprintf("Log marshal error: %s", err.Error()))
		return
	}
	body, parseErr := getBody(res)
	if parseErr != nil {
		fmt.Println(fmt.Sprintf("Error. During sending log to the API server: API Server: %s ErrorMessage: %s, RemoteStatusCode: %d RemoteMessage: unavailable SentMessage: %s", cfg.APIURL, err.Error(), res.StatusCode, logJSON))
	} else {
		fmt.Println(fmt.Sprintf("Error. During sending log to the API server: API Server: %s ErrorMessage: %s, RemoteStatusCode: %d RemoteMessage: %s SentMessage: %s", cfg.APIURL, err.Error(), res.StatusCode, body, logJSON))
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

func report(cfg *config, logmsg *logmsg) (*http.Response, error) {
	reportJSON, err := json.Marshal(*logmsg)
	if err != nil {
		return nil, err
	}
	res, err := http.Post((*cfg).APIURL, "application/json", bytes.NewReader(reportJSON))
	if res.StatusCode != 200 {
		log.Printf("Unable to post to functions API")
		log.Printf(string(reportJSON))
		log.Printf(res.Status)
	}
	return res, err
}

func healthCheck(cfg *config) (int, error) {
	res, err := http.Get((*cfg).Endpoint)
	if res != nil {
		return res.StatusCode, err
	}
	return 0, err
}

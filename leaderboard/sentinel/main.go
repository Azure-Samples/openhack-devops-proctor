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

type config struct {
	Endpoint      string `env:"SENTINEL_ENDPOINT,required"`
	PORT          int    `env:"SENTINEL_PORT" envDefault:"80"`
	TeamID        string `env:"SENTINEL_TEAM_ID,required"`
	ServiceID     string `env:"SENTINEL_SERVICE_ID,required"`
	APIURL        string `env:"SENTINEL_API_URL,required"`
	Interval      int    `env:"SENTINEL_POLLING_INTERVAL" envDefault:"1"`
	RetryDuration int    `env:"SENTINEL_RETRY_DURATION" envDefault:"1000"`
}

type log struct {
	TeamID     string
	ServiceID  string
	Date       time.Time
	StatusCode int
	Status     bool
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
		log := &log{
			TeamID:     cfg.TeamID,
			ServiceID:  cfg.ServiceID,
			Date:       time.Now(),
			StatusCode: statusCode,
		}

		// Endpoint is dead
		if statusCode != 200 {
			log.Status = false
			res, err := report(&cfg, log)
			if err != nil {
				printAPIErrorMessage(&cfg, err, res, log)
			}
			fmt.Println("Dead! wait for recovery for 1000 ms")
			time.Sleep(time.Duration(cfg.RetryDuration) * time.Millisecond)
			lastStatus = false
		} else {
			if !lastStatus {
				log.Status = true
				res, err := report(&cfg, log)
				if err != nil {
					printAPIErrorMessage(&cfg, err, res, log)
				}
			}
			lastStatus = true
		}
	}

	fmt.Println("Hello")
}

func printAPIErrorMessage(cfg *config, err error, res *http.Response, log *log) {
	logJSON, err := json.Marshal(*log)
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

func report(cfg *config, log *log) (*http.Response, error) {
	reportJSON, err := json.Marshal(*log)
	if err != nil {
		return nil, err
	}
	res, err := http.Post((*cfg).APIURL, "application/json", bytes.NewReader(reportJSON))
	return res, err
}

func healthCheck(cfg *config) (int, error) {
	res, err := http.Get((*cfg).Endpoint)
	if res != nil {
		return res.StatusCode, err
	}
	return 0, err
}

FROM golang:1.10.2 AS gobuild
WORKDIR /go/src/github.com/Azure-Samples/openhack-devops-proctor/leaderboard/sentinel
COPY . .
RUN go get -t 
RUN CGO_ENABLED=0 GOOS=linux go build -o sentinel .

FROM alpine:3.7 AS gorun

ENV SENTINEL_ENDPOINT="http://bing.com" \
	SENTINEL_PORT="80" \
	SENTINEL_TEAM_NAME="devteam" \
	SENTINEL_SERVICE_TYPE="devservice" \
	SENTINEL_API_URL="https://changeme.azurewebsites.net" \
	SENTINEL_POLLING_INTERVAL="5" \
	SENTINEL_RETRY_DURATION="1000"

WORKDIR /app

RUN apk add --update ca-certificates

COPY --from=gobuild /go/src/github.com/Azure-Samples/openhack-devops-proctor/leaderboard/sentinel/sentinel .

CMD ["./sentinel"]

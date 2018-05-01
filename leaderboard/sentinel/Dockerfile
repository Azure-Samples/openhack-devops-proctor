FROM alpine:3.7 AS base
WORKDIR /app

FROM golang:1.10-alpine AS build
WORKDIR /sentinel/src/github.com/Azure-Samples/openhack-devops-tools/sentinel
RUN mkdir /sentinel/bin
ENV GOPATH /sentinel
ENV PATH $PATH:$GOPATH/bin
COPY . .
RUN apk --update add git
RUN apk add --no-cache ca-certificates
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure
RUN go build

FROM base as final
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=build /sentinel/src/github.com/Azure-Samples/openhack-devops-tools/sentinel/sentinel /app/sentinel
# https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker
# I add this line to fix sentinel binary can't find even if it it is exists. 
# For more detail, ldd /app/sentinel might help.
# This happens when I use build image as golang:1.10 (not alpine)
# RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
ENTRYPOINT ["/app/sentinel"]



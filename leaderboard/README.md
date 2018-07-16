# Leaderboard 

The leaderboard's high-level purpose is to calculate and display the downtime for every team's APIs.

## Project structure

Under the leaderboard subdirectory, you can find these directories which correspond to the components required to achieve the leaderboard goal.  Go to the root of these folders to see a readme with deeper information on each component.

### api

An dotnet Core 2.1 API which connects to a SQL azure database backend.  This is where sentinel POSTs the downtime status and the web leaderboard GETs the report status. It contains a helm chart in the `helm` sub-directory.

### sentinel

Sentinel is the tool for watching the team health endpoints written in golang.  It contains a helm chart in the `helm` sub-directory.

### web

SPA application for the leaderboard based written in Angular 6 with Nebular. It has a Dockerfile and helm chart in the `helm` sub-directory.

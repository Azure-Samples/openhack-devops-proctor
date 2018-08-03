# Leaderboard

The leaderboard's high-level purpose is to calculate and display the downtime for every team's APIs.

Under the leaderboard subdirectory, you can find these directories which correspond to the components required to achieve the leaderboard goal.

## api

An dotnet Core 2.1 API which connects to a SQL azure database backend.  This is where sentinel POSTs the downtime status and the web leaderboard GETs the report status. It contains a helm chart in the `helm` sub-directory.

### ROUTES

* GET /api/leaderboard/teams/ - get teams
* GET /api/leaderboard/teams/{teamName} - get team record
* POST /api/leaderboard/teams/ - create a team
* PATCH /api/leaderboard/teams/{teamName} - update a team

* GET /api/leaderboard/challenges/ - get challenges for all teams
* GET /api/leaderboard/challenges/{teamName} - get challenges for a team
* POST /api/leaderboard/challenges/ - create a challenge for a team
* PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge

* GET /api/sentinel/logs/{teamId} - gets all logs for a team
* POST /api/sentinel/logs/{teamId} - posts logs for a team

## sentinel

Sentinel is the tool for watching the team health endpoints written in golang.  It contains a helm chart in the `helm` sub-directory.

## web

SPA application for the leaderboard based written in Angular 6 with Nebular. It has a Dockerfile and helm chart in the `helm` sub-directory.

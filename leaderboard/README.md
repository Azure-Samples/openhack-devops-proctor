# Open Hack tools - DevOps 

This repository deploy whole Proctor environments for Open Hack - DevOps
It includes code for Leaderboard

## Project structure

Under the leaderboard subdirectory, you can find these directories.

### api

* **Leaderboard**: BackendService of Leaderboard. This is the Azure Functions (v2) Project with Release Binary.
* **infastructure**: PowerShell/ARM template scripts for deploying Proctor enviornment

### sentinel

* **sentinel**: Sentinel is the tool for watching team endpoints written by go
* **helm chart**: helm chart which deploys the sentinel

### web 

* **leaderboard**: SPA application for the leaderboard written by Angular 4 with Nebular

## Detail

You can refer the Readme.md on the each directories. 
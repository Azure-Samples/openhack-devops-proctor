# DevOps Openhack Proctor Repository

This repo contains the code for a proctor to automatically provision the team and proctor environments necessary to execute a DevOps openhack event.  The relevant code individual teams use (i.e. the APIs) to complete their challenges can be found in the [DevOps Openhack Team repository](https://github.com/Azure-Samples/openhack-devops-team/).

## Components

The components are organized by folders which contain the following:

* **leaderboard** - visualizes the uptime for the teams' APIs and contains an Azure Functions API which connects to CosmosDB, Sentinel (pods to query the APIs and report status), and a web front end.
* **provision-proctor** - automates the provisioning of a complete proctor environment (1 needed per event).
* **provision-team** - automates the provisioning of a complete team environment.
* **provision-vm** - automates the provisioning of an Ubuntu 16.04 VM used as the foundation for provisioning the team and proctor environments.
* **simulator** - simulates traffic to the SQL database the APIs use for every team's environment.

Go to the root of these folders to see a readme with deeper information on each component.

## Getting Started

### Prerequisites

The first step is to create a virtual machine which has the necessary software installed required to provision the teams and proctor environments.  In order to create the VM, only the following needs to be installed

* Azure PowerShell
* An Azure Subscription

### High-Level Installation Flow

1. [Create A Proctor VM](./provision-vm)
2. [Create Team Environments](./provision-team) from the proctor VM
3. [Create A Proctor Environment](./provision-proctor) from the proctor VM

## Resources

For troubleshooting or answers to common questions, please [read the FAQ](FAQ.md).

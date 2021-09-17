---
page_type: sample
languages:
- csharp
- sql
products:
- azure
description: "This repo contains the code for the provisioning of the resources necessary to execute a DevOps OpenHack event."
---

# DevOps OpenHack Proctor Repository

This repo contains the code for the provisioning of the resources necessary to execute a DevOps OpenHack event.  The relevant code individual teams use (i.e. the APIs) to complete their challenges can be found in the [DevOps OpenHack Team repository](https://github.com/Azure-Samples/openhack-devops-team/).

## Components

The components are organized by folders which contain the following:

* **provision-team** - code to support the provisioning of a complete team environment.
* **simulator** - simulates traffic to the SQL database the APIs use for every team's environment.
* **tripviewer** - the team website that your customers are using to review their driving scores and trips which are being simulated against the APIs.

Go to the root of these folders to see a readme with deeper information on each component.

## Getting Started

### Prerequisites

* Bash Shell
* Azure CLI
* An Azure Subscription

### High-Level Installation Flow

 Deploy a team environment using the `deploy.sh` script and the guidance included in the  [provision-team](./provision-team) directory.

## Resources

For troubleshooting or answers to common questions, please [read the FAQ](FAQ.md).

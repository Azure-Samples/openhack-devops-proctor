terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.7"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/<your_org_name>"
  personal_access_token = ""
  # export AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
  # export AZDO_ORG_SERVICE_URL=https://dev.azure.com/<Your Org Name>
}

provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}
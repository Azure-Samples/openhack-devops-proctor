terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.15.1"
    }
  }
}

provider "azurerm" {
  features {
  }
}

provider "github" {
}

data "azurerm_client_config" "current" {}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.76.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}